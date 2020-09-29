import 'package:ethiotel/packages_page.dart';
import 'package:ethiotel/pkgs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PkgsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'packages'.tr,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Container(child: GetX<PkgsController>(
        builder: (controller) {
          return !controller.isReady &&
                  controller.pkgsList != null &&
                  controller.pkgsList.length == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: [
                            ...controller.pkgsList[0][Get.locale.languageCode]
                                    ['packages']
                                .map((item) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(PackagesPage(item));
                                },
                                child: Card(
                                  shape: CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    radius: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.data_usage,
                                          size: 50,
                                        ),
                                        Text(
                                          item['name'],
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      )),
    );
  }
}
