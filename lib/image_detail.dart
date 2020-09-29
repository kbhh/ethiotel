import 'package:contact_picker/contact_picker.dart';
import 'package:ethiotel/camera_page.dart';
import 'package:ethiotel/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:ussd/ussd.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;
  DetailScreen(this.imagePath);

  @override
  _DetailScreenState createState() => new _DetailScreenState(imagePath);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(this.path);

  final String path;

  Size _imageSize;
  List<TextElement> _elements = [];
  String recognizedText;

  final phoneNumberController = TextEditingController(text: "0914696545");
  List<String> _registeredPatterns = [];
  bool isReady = false;
  String errorMessage = "";

  initPkgs() async {
    var initPatterns = [
      r"^[0-9]{3}\s[0-9]{3}\s[0-9]{4}\s[0-9]{4}$",
      r"^[0-9]{5}\s[0-9]{4}\s[0-9]{5}$",
    ];
    try {
      await Hive.initFlutter();
      var box = await Hive.openBox('etlbox');
      var etlPatterns = await box.get("etlPatterns");
      if (etlPatterns == null) {
        box.put("etlPatterns", initPatterns);
        setState(() {
          _registeredPatterns = initPatterns;
        });
      } else {
        setState(() {
          _registeredPatterns = etlPatterns;
        });
      }
      setState(() {
        isReady = true;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Cant get available patterns";
      });
    }
  }

  void _initializeVision() async {
    final File imageFile = File(path);

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    List<RegExp> cardRegxs = isReady
        ? this
            ._registeredPatterns
            .map((cardPattern) => RegExp(cardPattern))
            .toList()
        : [];

    String cardNumber = "";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        cardRegxs.forEach((element) {
          if (element.hasMatch(line.text)) {
            cardNumber += line.text + '\n';
            for (TextElement element in line.elements) {
              _elements.add(element);
            }
          }
        });
      }
    }
    if (this.mounted) {
      setState(() {
        recognizedText = cardNumber;
      });
    }
    if (recognizedText == "") {
      Get.snackbar(
        "voucherNotRecognized".tr,
        "voucherError".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  @override
  void initState() {
    initPkgs();
    _initializeVision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "voucherDetail".tr,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _imageSize != null
          ? Stack(
              children: [
                Container(
                  height: Get.context.height * 0.90,
                  width: double.maxFinite,
                  color: Colors.black,
                  child: CustomPaint(
                    foregroundPainter:
                        TextDetectorPainter(_imageSize, _elements),
                    child: AspectRatio(
                      aspectRatio: _imageSize.aspectRatio,
                      child: Image.file(
                        File(path),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 320),
                  child: recognizedText != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              child: Text(
                                recognizedText != "" ? "go".tr : "back".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                              backgroundColor: Colors.white,
                              onPressed: () {
                                if (recognizedText == "") {
                                  Get.to(CameraScreen());
                                } else {
                                  Ussd.runUssd("*805*" + recognizedText + "#")
                                      .then((value) {
                                    Get.to(HomePage());
                                  });
                                }
                              },
                            ),
                          ],
                        )
                      : CircularProgressIndicator(),
                ),
              ],
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<TextElement> elements;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextContainer container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (TextElement element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}
