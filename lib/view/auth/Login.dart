import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:githubwork/main.dart';
import 'package:githubwork/utility/sharedPref/SharedPrefManager.dart';
import 'package:githubwork/view/dashboard/dashboard.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

import '../../utility/apis.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
//text controler for username
  TextEditingController userName = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 2.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ******************* Logo image ********************************************
              Image(
                image: const AssetImage('assets/logo.png'),
                width: 35.w,
              ),
              Text(
                "Github Username",
                style: font.custom(col.black, 24.0, FontWeight.w700, 1.0),
              ),
              Text(
                "And connect ",
                style: font.custom(col.black, 30.0, FontWeight.w900, 2.0),
              ),
              SizedBox(
                height: 2.h,
              ),
              // ******************* Input area ********************************************
              TextField(
                  controller: userName,
                  decoration: sheet.inputstyle('', "username")),
              SizedBox(
                height: 2.h,
              ),
              // ******************* Login Button********************************************
              GestureDetector(
                onTap: () {
                  // ******************* Featching user info ********************************************
                  getuserInfo();
                },
                child: Container(
                  width: 100.w,
                  height: 7.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: col.black),
                  child: Text(
                    "Login".toUpperCase(),
                    style: font.h4semibold(col.white),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

// ******************* Function  ********************************************
  getuserInfo() async {
    showLoader();
    var res =
        await http.get(Uri.parse(Api().getuserInfo(userName.text.toString())));
    var jsonResponse = json.decode(res.body);
    try {
      if (res.statusCode == 200) {
        try {
          await SharedPrefManager.setUserLogin(true);
          await SharedPrefManager.setUser(json.encode(jsonResponse));
          Navigator.pop(context);
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) => Dashboard(
                        repo: jsonResponse['login'].toString(),
                      )));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Check Your Internet")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Somting Worng")));
      }
    } catch (e) {
      print(e);
    }
  }

  showLoader() => showDialog(
      context: context,
      builder: (_) => Container(
            height: 100.h,
            width: 100.w,
            color: col.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ));
}
