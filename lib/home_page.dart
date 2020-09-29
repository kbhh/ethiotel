import 'package:abushakir/abushakir.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:ethiotel/bindings/pkgs_bindings.dart';
import 'package:ethiotel/camera_page.dart';
import 'package:ethiotel/home_controller.dart';
import 'package:ethiotel/pkgs_page.dart';
import 'package:ethiotel/pkgs_page_trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:ussd/ussd.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    EtDatetime etToday = EtDatetime.now();
    String etDate = etToday.day.toString() +
        "/" +
        etToday.month.toString() +
        "/" +
        etToday.year.toString();
    String geezDate = etToday.monthGeez.toString() +
        " - " +
        etToday.dayGeez.toString() +
        " - " +
        etToday.year.toString();
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        iconTheme: new IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    'SNAP Telecom',
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  )),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            Obx(
              () {
                return ListTile(
                  leading: Icon(Icons.language),
                  title: ToggleButtons(
                    selectedColor: Colors.white,
                    fillColor: Colors.black,
                    color: Colors.black,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("አማርኛ"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("English"),
                      ),
                    ],
                    onPressed: (int index) {
                      controller.setSelectedLang = index;
                    },
                    isSelected: controller.selectedLang,
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('shareApp'.tr),
              onTap: () {
                Share();
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text('rateApp'.tr),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text(
                'App Version 1.0',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ), // Populate the Drawer in the next step.
      ),
      body: GetX<HomeController>(
        init: HomeController(),
        builder: (contro) {
          return Column(
            children: [
              Container(
                color: Colors.white,
                height: Get.context.height * 0.20,
                width: Get.context.width,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                child: Card(
                  margin: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                backgroundColor: Colors.black,
                                onPressed: () {
                                  Get.to(CameraScreen());
                                },
                                child: Icon(Icons.camera_alt),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "flash".tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "recharge".tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  contro.currentTime.toString().contains("ከሰዓት")
                                      ? contro.currentTime
                                          .replaceAll("ከሰዓት", "ቀን")
                                      : contro.currentTime
                                          .toString()
                                          .replaceAll("ጥዋት", "ማታ"),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  etDate,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  geezDate,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Card(
                  child: Form(
                    key: contro.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          autofocus: false,
                          controller: contro.cardPattern,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          cursorColor: Colors.black,
                          validator: (value) {
                            if (value.isEmpty || !value.isNumericOnly) {
                              return "Please input the card numbers from voucher";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              focusColor: Colors.black,
                              prefixIcon: Icon(
                                Icons.confirmation_number,
                                color: Colors.black,
                              ),
                              prefixStyle: TextStyle(
                                  color: Colors.black,
                                  decorationColor: Colors.black),
                              fillColor: Colors.black,
                              hintText: "0000 0000 00000",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 2.0),
                              ),
                              suffixIcon: RaisedButton(
                                child: Text("recharge".tr),
                                color: Colors.black,
                                textColor: Colors.white,
                                onPressed: () {
                                  if (contro.formKey.currentState.validate()) {
                                    Ussd.runUssd("*805*" +
                                        contro.cardPattern.text +
                                        "#");
                                  }
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: 170,
                    child: RaisedButton(
                      color: Colors.black87,
                      textColor: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance,
                          ),
                          Text(
                            "checkBalance".tr,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                      onPressed: () {
                        Ussd.runUssd("*804#");
                      },
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 170,
                    child: RaisedButton(
                      color: Colors.black87,
                      textColor: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.card_giftcard,
                          ),
                          Text(
                            "transferBalance".tr,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                      onPressed: () {
                        getDialog("*806*");
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: 170,
                    child: RaisedButton(
                      color: Colors.black87,
                      textColor: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call,
                          ),
                          Text(
                            "callMeBack".tr,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                      onPressed: () {
                        getDialog("*807#");
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  children: [
                    Container(
                      height: 70,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(PkgsPage(), binding: PkgsBinding());
                        },
                        child: Card(
                          shadowColor: Colors.black,
                          margin: EdgeInsets.all(5),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi, size: 48),
                              Text("packages".tr),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(PkgsPageTrans(), binding: PkgsBinding());
                        },
                        child: Card(
                          shadowColor: Colors.black,
                          margin: EdgeInsets.all(5),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.card_giftcard, size: 48),
                              Text("gift".tr),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  getDialog(shortCode) {
    Get.defaultDialog(
      title: "checkBalance".tr,
      confirm: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Text("send".tr),
          onPressed: () {
            if (controller.formKey.currentState.validate()) {
              var shortCodeText = shortCode == "*807*"
                  ? shortCode + controller.phoneNumberInput.text + "#"
                  : shortCode +
                      controller.phoneNumberInput.text +
                      controller.amountInput.text +
                      "#";

              Ussd.runUssd(shortCodeText);
            }
          },
        ),
      ),
      confirmTextColor: Colors.white,
      content: Container(
        margin: EdgeInsets.symmetric(vertical: 25),
        child: Form(
          key: controller.formKey2,
          child: Column(
            children: [
              Container(
                child: shortCode == "*806*"
                    ? TextFormField(
                        autofocus: false,
                        controller: controller.amountInput,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please input amount";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusColor: Colors.black,
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.black,
                          ),
                          prefixStyle: TextStyle(
                              color: Colors.black,
                              decorationColor: Colors.black),
                          fillColor: Colors.black,
                          hintText: "amount".tr,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                          ),
                        ),
                      )
                    : SizedBox(),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                autofocus: false,
                controller: controller.phoneNumberInput,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                cursorColor: Colors.black,
                validator: (value) {
                  if (value.isEmpty || value.length != 10) {
                    return "Please input the valid Phone Number";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    focusColor: Colors.black,
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    prefixStyle: TextStyle(
                        color: Colors.black, decorationColor: Colors.black),
                    fillColor: Colors.black,
                    hintText: "094324322",
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                    ),
                    suffixIcon: RaisedButton(
                      child: Text("select".tr),
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {
                        ContactPicker().selectContact().then((value) {
                          controller.phoneNumberInput.text = value
                              .phoneNumber.number
                              .replaceAll("+251", "0")
                              .trim()
                              .replaceAll(" ", "");
                        });
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
