import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:githubwork/utility/sharedPref/SharedPrefManager.dart';
import 'package:githubwork/view/auth/Login.dart';
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
  bool isSort = false;

//  ************* refresh list  data *****************************************
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
    });
  }

//  ************* Search Product area *****************************************
  searchProduct(String str) {
    var strisEiext = str.length > 0 ? true : false;
    if (strisEiext) {
      var filterdata = [];
      for (var i = 0; i < unfilddata.length; i++) {
        String name = unfilddata[i]['name'].toUpperCase();
        if (name.contains(str.toUpperCase())) {
          filterdata.add(unfilddata[i]);
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

  logMeout() async {
    await SharedPrefManager.logout();
    Navigator.pushAndRemoveUntil(
        context, CupertinoPageRoute(builder: (_) => Login()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/logo.png')),
        ),
        title: Text(
          'My Github/${widget.repo}',
          style: font.h4semibold(col.white),
        ),
        actions: [
          PopupMenuButton(onSelected: (value) {
            // log out ****************************************
            if (value == '0') {
              logMeout();
            }
          }, itemBuilder: (_) {
            return [
              PopupMenuItem(
                child: Text("Logout"),
                value: '0',
              )
            ];
          })
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: sheet.layoutPad(),
        child: Column(
          children: [
            //************************* */ search area *****************************************************
            Row(
              children: [
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      onChanged: (String value) {
                        searchProduct(value);
                      },
                      decoration: InputDecoration(
                          hintText: "Search Here !",
                          labelStyle: TextStyle(fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.h, vertical: 2.w))),
                )),

                //...........................
                //.end search textfield..........
                //..................

                // ***************sorting buttton *******************************************************
                IconButton(
                    onPressed: () {
                      if (isSort == false) {
                        data.sort((a, b) => (b['stargazers_count'])
                            .compareTo(a['stargazers_count']));
                        isSort = true;
                        SharedPrefManager.setSorting(true);
                        setState(() {});
                      } else {
                        isSort = false;
                        setState(() {});
                        SharedPrefManager.setSorting(false);
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(builder: (_) => Dashboard(repo: widget.repo,)),
                            (route) => false);
                      }
                    },
                    icon: Icon(
                      Icons.sort,
                      color: isSort ? col.red : col.hint,
                      size: 5.h,
                    ))
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            //  ************* Repo list Ui *****************************************
            Flexible(
                child: searchs
                    ? _items == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  //  ************* Navigating to Singel details page *****************************************
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
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            child: Text(
                                              data[index]['visibility'],
                                              style: font.h7semibold(col.black),
                                            ),
                                          ),
                                          RatingBarIndicator(
                                            rating: double.parse(data[index]
                                                    ['stargazers_count']
                                                .toString()),
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 11.0,
                                            direction: Axis.horizontal,
                                          ),
                                        ],
                                      ),
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
                              //  ************* Navigating to Singel details page *****************************************
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
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1.h),
                                        child: Text(
                                          data[index]['visibility'],
                                          style: font.h7semibold(col.black),
                                        ),
                                      ),
                                      RatingBarIndicator(
                                        rating: double.parse(data[index]
                                                ['stargazers_count']
                                            .toString()),
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 11.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ],
                                  ),
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

//  ************* featch data online @ offline *****************************************
  featchRepo() async {
    var mySavedRepo = await SharedPrefManager.getMyRepo();
    isSort= (await SharedPrefManager.getSort())!;
    print(isSort);
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
      if(isSort){
      data.sort((a, b) => (b['stargazers_count'])
                            .compareTo(a['stargazers_count']));
      }
    });
  }
}
