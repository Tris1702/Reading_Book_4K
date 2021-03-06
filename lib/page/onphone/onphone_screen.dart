import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/page/onphone/onphone_bloc.dart';

class OnphoneScreen extends StatelessWidget {
  const OnphoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("onphone reloaded");
    OnphoneBloc bloc = OnphoneBloc();

    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.boxesPacking,
              color: AppColor.backgroundLinearProgressBar,
              size: MediaQuery.of(context).size.width * 0.4,
            ),
            ElevatedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  FaIcon(
                    FontAwesomeIcons.upload,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    AppString.uploadFile,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              onPressed: () => bloc.pickFile(context),
              style: ElevatedButton.styleFrom(
                primary: AppColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ]),
    );
  }
}
