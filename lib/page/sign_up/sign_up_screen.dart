import 'package:flutter/material.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/page/sign_up/sign_up_bloc.dart';

import '../../assets/app_string.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    SignUpBloc bloc = SignUpBloc();
    bloc.init();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.signUp, style: TextStyle(color: Colors.black),),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Center(
        child: StreamBuilder(
          stream: bloc.loading.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              final data = snapshot.data as bool;
              if (data) {
                return const CircularProgressIndicator();
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppString.createAcoount,
                          style: TextStyle(fontSize: 24.0),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: AppString.email,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: AppString.password,
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: confirmPasswordController,
                          decoration: const InputDecoration(
                            labelText: AppString.confirmPassword,
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          child: const Text(AppString.signUp, style: TextStyle(color: Colors.black),),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor),
                          onPressed: () {
                            bloc.signUp(emailController.text, passwordController.text, confirmPasswordController.text);
                          },
                        ),
                        const SizedBox(height: 16.0,),
                        StreamBuilder(
                          stream: bloc.error.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Text("");
                            } else {
                              var data = snapshot.data as String;
                              return Text(data, style: const TextStyle(color: Colors.red),);
                            }
                          }
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          }
        ),
      ),
    );
  }
}