import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:githubwork/utility/sharedPref/SharedPrefManager.dart';
import 'package:githubwork/view/dashboard/singelview.dart';

import 'package:http/http.dart' as http;
import 'package:githubwork/main.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

import '../../utility/apis.dart';

class Dashboard extends StatefulWidget {
  final repo;
  const Dashboard({this.repo, super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> data = [];
  List<dynamic> unfilddata = [];
  bool searchs = false;
  var _items = 0;
  var _isLoading = false;

//   refresh list  data
  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = false;
      if (_items + data.length.remainder(10) + 1 > data.length) {
        _items = data.length;
      } else {
        _items = _items + 10;
      }
      print(_items);
    });
  }

  searchProduct(String str) {
    var strisEiext = str.length > 0 ? true : false;
    if (strisEiext) {
      var filterdata = [];
      for (var i = 0; i < unfilddata.length; i++) {
        String name = unfilddata[i]['name'].toUpperCase();
        if (name.contains(str.toUpperCase())) {
          filterdata.add(unfilddata[i]);
          print(unfilddata);
        }
      }
      setState(() {
        data = filterdata;
        searchs = true;
      });
    } else {
      setState(() {
        data = unfilddata;
        searchs = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    featchRepo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Image(image: AssetImage('assets/logo.png')),
        title: Text(
          'My Github/${widget.repo}',
          style: font.h4semibold(col.white),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: sheet.layoutPad(),
        child: Column(
          children: [
            TextField(
                autofocus: false,
                onChanged: (String value) {
                  print(value);
                  searchProduct(value);
                },
                decoration: InputDecoration(
                    hintText: "Search Here !",
                    enabled: false,
                    labelStyle: TextStyle(fontSize: 15),
                    suffixIcon: Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 3.h, vertical: 2.w))),
            SizedBox(
              height: 2.h,
            ),
            Flexible(
                child: searchs
                    ? _items == null
                        ? Column(
                            children: [
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          )
                        : InfiniteList(
                            itemCount: data.length,
                            isLoading: _isLoading,
                            onFetchData: _fetchData,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => SingelView(
                                                data: data[index],
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 12.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: col.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xffDDDDDD),
                                            blurRadius: 6.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(0.0, 0.0),
                                          )
                                        ]),
                                    child: ListTile(
                                      leading: Image(
                                        image:
                                            const AssetImage('assets/logo.png'),
                                        width: 14.w,
                                      ),
                                      title: Text(
                                        data[index]['name'],
                                        style: font.h4semibold(col.black),
                                      ),
                                      subtitle: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1.h),
                                        child: Text(
                                          data[index]['visibility'],
                                          style: font.h7semibold(col.black),
                                        ),
                                      ),
                                      trailing: Text(index.toString()),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                    : InfiniteList(
                        itemCount: _items,
                        isLoading: _isLoading,
                        onFetchData: _fetchData,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => SingelView(
                                            data: data[index],
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 12.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: col.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xffDDDDDD),
                                        blurRadius: 6.0,
                                        spreadRadius: 2.0,
                                        offset: Offset(0.0, 0.0),
                                      )
                                    ]),
                                child: ListTile(
                                  leading: Image(
                                    image: const AssetImage('assets/logo.png'),
                                    width: 14.w,
                                  ),
                                  title: Text(
                                    data[index]['name'],
                                    style: font.h4semibold(col.black),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 1.h),
                                    child: Text(
                                      data[index]['visibility'],
                                      style: font.h7semibold(col.black),
                                    ),
                                  ),
                                  trailing: Text(index.toString()),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
          ],
        ),
      )),
    );
  }

  featchRepo() async {
    var mySavedRepo = await SharedPrefManager.getMyRepo();
    var res;
    var jsonResponse;
    if (mySavedRepo == null) {
      res = await http.get(Uri.parse(Api().getRepoInfo(widget.repo)));
      await SharedPrefManager.setMyRepo(res.body);
      jsonResponse = json.decode(res.body);
    } else {
      res = mySavedRepo;
      jsonResponse = json.decode(res);
    }

 

    setState(() {
      data = jsonResponse;
      unfilddata = data;
      _items = 0;
    });
  }
}
