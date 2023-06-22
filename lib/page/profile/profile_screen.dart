import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/page/login/login_screen.dart';
import 'package:reading_book_4k/page/profile/profile_bloc.dart';

import '../../model/author.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ProfileBloc bloc = ProfileBloc();
    bloc.init();
    return Scaffold(
      floatingActionButton: StreamBuilder(
        stream: bloc.logoutStatus.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            final data = snapshot.data as bool;
            if (data) {
              return Container();
            } else {
              return FloatingActionButton( 
                backgroundColor: AppColor.primaryColor,
                child: const FaIcon(FontAwesomeIcons.penToSquare, color: Colors.black,),
                onPressed: () => bloc.openEditProfile(),
              );
            }
          }
        }
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: bloc.logoutStatus.stream,
            builder: (context, snapshot) { 
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                var data = snapshot.data as bool;
                if (data) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor),
                    child: const Text(AppString.login, style: TextStyle(color: Colors.black),),
                    onPressed: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()))
                    },
                  );
                } else {
                  return StreamBuilder(
                    stream: bloc.currentAuthor.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        final data = snapshot.data as Author;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage: NetworkImage(data.avatarLink),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              data.name,
                              style: const TextStyle(fontSize: 24.0),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              data.email,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primaryColor,
                              ),
                              child: const Text(AppString.logout, style: TextStyle(color: Colors.black),),
                              onPressed: () {
                                bloc.logout();
                              },
                            ),
                          ],
                        );
                      }
                    },
                  );
                }
              }
            }
          ),
        ),
      ),
    );
  }
}