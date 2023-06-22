import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reading_book_4k/config/app_color.dart';

import '../../assets/app_string.dart';
import 'forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final bloc = ForgotPasswordBloc();
  @override
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.resetPassword, style: TextStyle(color: Colors.black),),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: AppString.email),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text(AppString.reset, style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor),
                onPressed: () {
                  widget.bloc.resetPassword(_emailController.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}