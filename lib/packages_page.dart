import 'package:ethiotel/home_page.dart';
import 'package:ethiotel/packages_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ussd/ussd.dart';

class PackagesPage extends GetView<PackageController> {
  //item
  final Map<dynamic, dynamic> item;
  PackagesPage(this.item);

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
                                  onTap: () async {
                                    await Ussd.runUssd(bundle["shortCode"]);
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
                                      onTap: () async {
                                        await Ussd.runUssd(bundle["shortCode"]);
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
}
