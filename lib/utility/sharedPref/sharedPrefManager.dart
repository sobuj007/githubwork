
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/userModel.dart';


class SharedPrefKeys{
 
  static const String ISUSERLOGIN = "ISUSERLOGIN";
  static const String ISSORT = "ISSORT";
 
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
  static Future <bool> setSorting(data)async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.setBool("ISSORT", data);
  }
  static Future<bool?> getSort()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getBool(SharedPrefKeys.ISSORT);
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

 static logout()async{
SharedPreferences pref= await  SharedPreferences.getInstance();
pref.clear();

}
}