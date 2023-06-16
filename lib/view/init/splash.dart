import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:githubwork/main.dart';
import 'package:githubwork/utility/sharedPref/SharedPrefManager.dart';
import 'package:githubwork/view/dashboard/dashboard.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../auth/Login.dart';
class Splash extends StatefulWidget {

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  startTimer()async{
var isUserLogin= await SharedPrefManager.isUserLogin();


   if(isUserLogin ==true){
    var userData=json.decode(await SharedPrefManager.getUser()) ;
var userName=userData['login'].toString();

     Future.delayed(const Duration(seconds: 2)).then((value) => {
      Navigator.push(context, CupertinoPageRoute(builder: (_)=> Dashboard(repo: userName,)))
   });
   }else{
        Future.delayed(const Duration(seconds: 2)).then((value) => {
      Navigator.push(context, CupertinoPageRoute(builder: (_)=> Login()))
   });
   }

  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: const AssetImage('assets/logo.png'),width: 38.w,),
        Text("My Github",style: font.h1semibold(col.black),),
      ],
    ),)),);
  }
}