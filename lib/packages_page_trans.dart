import 'package:contact_picker/contact_picker.dart';
import 'package:ethiotel/packages_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ussd/ussd.dart';

class PackagesPageTrans extends GetView<PackageController> {
  //item
  final Map<dynamic, dynamic> item;
  PackagesPageTrans(this.item);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: item['special'] ? 0 : item["type"].length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            item['name'],
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          bottom: TabBar(
            unselectedLabelColor: Colors.black54,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            isScrollable: true,
            // indicator: BoxDecoration(
            //     borderRadius: BorderRadius.circular(50), color: Colors.black),
            tabs: item['special']
                ? []
                : <Widget>[
                    ...item["type"].map(
                      (type) {
                        return Tab(
                            child: Text(
                          type['name'],
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ));
                      },
                    ),
                  ],
          ),
        ),
        body: item['special']
            ? Container(
                child: Container(
                  child: ListView(
                    children: [
                      ...item["dates"].map((date) {
                        return Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  date['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              ...date['type'].map((bundle) {
                                return GestureDetector(
                                  onTap: () {
                                    getDialog(bundle["shortCode"]);
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.all(8),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 40,
                                          child: Text(
                                            bundle['price'].toString() + " ETB",
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                        ),
                                        title: Text(bundle["title"]),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                );
                              })
                            ],
                          ),
                        );
                      })
                    ],
                  ),
                ),
              )
            : TabBarView(
                children: [
                  ...item['type'].map((type) {
                    return Container(
                      child: ListView(
                        children: [
                          ...type["dates"].map((date) {
                            return Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      date['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  ...date['bundles'].map((bundle) {
                                    return GestureDetector(
                                      onTap: () {
                                        getDialog(bundle["shortCode"]);
                                      },
                                      child: Column(
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.all(8),
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.black,
                                              radius: 40,
                                              child: Text(
                                                bundle['price'].toString() +
                                                    " ETB",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            title: Text(bundle["title"]),
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    );
                                  })
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    );
                  })
                ],
              ),
      ),
    );
  }

  getDialog(shortCode) {
    Get.defaultDialog(
      title: "selectPhoneNumber".tr,
      confirm: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Text("send".tr),
          onPressed: () {
            if (controller.formKey.currentState.validate()) {
              // *999*2*1*3*1*1# -4
              var newShortCode = shortCode
                  .toString()
                  .replaceRange(7, 8, "2")
                  .replaceRange(shortCode.length - 2, shortCode.length - 1,
                      controller.phoneNumberInput.text + "*1");
              Ussd.runUssd(newShortCode);
            }
          },
        ),
      ),
      confirmTextColor: Colors.white,
      content: Container(
        margin: EdgeInsets.symmetric(vertical: 25),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: false,
                controller: controller.phoneNumberInput,
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                cursorColor: Colors.black,
                validator: (value) {
                  if (value.isEmpty ||
                      !value.isNumericOnly ||
                      value.length != 10) {
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
