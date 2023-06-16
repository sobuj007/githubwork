import 'dart:io';
import 'package:flutter/material.dart';
import 'package:githubwork/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SingelView extends StatefulWidget {
  final data;
  SingelView({this.data, super.key});

  @override
  State<SingelView> createState() => _SingelViewState();
}

class _SingelViewState extends State<SingelView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: sheet.layoutPad(),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(
                   3.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(radius:35 ,
                         backgroundImage: NetworkImage(widget.data['owner']['avatar_url'])
                             
                        ),
                        SizedBox(width: 3.w,),
                        Container(
                          width: 60.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data['name'],
                                style: font.h4bold(col.black),
                                
                                maxLines: 2,softWrap: false,overflow: TextOverflow.ellipsis,
                              )
                             ,
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.w),
                                child: Text(
                                  widget.data['owner']['login'].toString(),
                                  style: font.h5semibold(col.black),
                                ),
                              ),
                              Text(
                                DateTime.tryParse( widget.data
                                ['pushed_at']).toString(),
                                style: font.h7semibold(col.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    //Image(image: NetworkImage(widget.data['owner']['avatar_url'])),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
