
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/userModel.dart';


class SharedPrefKeys{
static final String USER = "USER";
  
  static const String USERINFO = "USERINFO";
  static const String ISUSERLOGIN = "ISUSERLOGIN";
 
}


class SharedPrefManager{

  static Future <bool> setUserLogin(data)async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.setBool("ISUSERLOGIN", data);
  }
  static Future<bool?> isUserLogin()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getBool(SharedPrefKeys.ISUSERLOGIN);
  }

static setUser(String data)async{
    SharedPreferences pref= await  SharedPreferences.getInstance();
  
   return pref.setString("USER", data);
  }
static Future<dynamic> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var d= pref.getString("USER");
    return d;
  }
static setMyRepo(String data)async{
    SharedPreferences pref= await  SharedPreferences.getInstance();
  
   return pref.setString("repo", data);
  }
static Future<dynamic> getMyRepo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var d= pref.getString("repo");
    return d;
  }

Future<void> logut()async{
SharedPreferences pref= await  SharedPreferences.getInstance();
pref.clear();

}
}