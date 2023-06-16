import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:githubwork/utility/sharedPref/SharedPrefManager.dart';

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
            Flexible(
              child: _items == null
                  ?  Column(
                    children: [
                      Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  )
                  : InfiniteList(
                      itemCount: _items,
                      isLoading: _isLoading,
                      onFetchData: _fetchData,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return Padding(
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
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                child: Text(
                                  data[index]['visibility'],
                                  style: font.h7semibold(col.black),
                                ),
                              ),
                              trailing: Text(index.toString()),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      )),
    );
  }

  featchRepo() async {
    var mySavedRepo = await SharedPrefManager.getMyRepo();

    var res;

    if (mySavedRepo == null) {
      res = await http.get(Uri.parse(Api().getRepoInfo(widget.repo)));
      await SharedPrefManager.setMyRepo(res.body);
    } else {
      res = mySavedRepo;
    }

    var jsonResponse = json.decode(res);

    print(jsonResponse.length);

    setState(() {
      data = jsonResponse;
      _items = 0;
    });
  }
}
