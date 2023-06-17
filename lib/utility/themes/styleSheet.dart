import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../main.dart';

class StyleSheet {
  inputstyle(title, hint) => InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      hintText: hint,
      hintStyle: font.h4reguler(col.hint),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(width: .3.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(width: .5.w),
      ));

  layoutPad() => EdgeInsets.symmetric(horizontal: 2.h, vertical: 4.w);
}
