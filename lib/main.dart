import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:githubwork/utility/apis.dart';
import 'package:githubwork/utility/sharedPref/SharedPrefManager.dart';

import 'package:githubwork/utility/themes/colors.dart';

import 'package:githubwork/utility/themes/fonts.dart';
import 'package:githubwork/utility/themes/styleSheet.dart';
import 'package:githubwork/view/init/splash.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

// Global  object area ..............................
Fonts font = Fonts();
ColorData col = ColorData();
StyleSheet sheet = StyleSheet();
// final box = GetStorage();

void refreshTimer(name) {
  Timer.periodic(const Duration(minutes: 30), (timer) {
    updateData(name);
    print("timer start time complete");
  });
}

updateData(name) async {
  var res = await http.get(Uri.parse(Api().getRepoInfo(name)));
  await SharedPrefManager.setMyRepo(res.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var userName;
  if (await SharedPrefManager.getUser() != null) {
    userName = json.decode(await SharedPrefManager.getUser());
    refreshTimer(userName['login']);
  }

//*************** */ setting  screen Orentation *********************************
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
        builder: (context, orientaion, screenType) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "My Github",
              home: Splash(),
            ));
  }
}
