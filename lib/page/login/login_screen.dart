import 'package:flutter/material.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/page/login/logic_bloc.dart';

import '../sign_up/sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    LoginBloc bloc = LoginBloc();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.login, style: TextStyle(color: Colors.black),),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  AppString.login,
                  style: TextStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: AppString.email,
                    focusColor: AppColor.primaryColor
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: AppString.password,
                    focusColor: AppColor.primaryColor
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton (
                  child: const Text(AppString.login, style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom( backgroundColor: AppColor.primaryColor ),
                  onPressed: () => bloc.login(emailController.text, passwordController.text)
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom( backgroundColor: AppColor.primaryColor),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen())), 
                  child: const Text(AppString.notHaveAccount, style: TextStyle(color: Colors.black),)
                ),
                const SizedBox(height: 16.0,),
                GestureDetector(
                  child: const Text(AppString.forgotPassword),
                  onTap: () => bloc.forgotPassword(),  
                ),
                const SizedBox(height: 16.0,),
                StreamBuilder(
                  stream: bloc.error.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("");
                    } else {
                      return Text(
                        snapshot.data as String,
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}