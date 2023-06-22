import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reading_book_4k/page/edit_profile/edit_profile_bloc.dart';

import '../../assets/app_string.dart';
import '../../config/app_color.dart';
import '../../model/author.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  EditProfileBloc bloc = EditProfileBloc();
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  @override
  Widget build(BuildContext context) {
    widget.bloc.init();
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.editProfile, style: TextStyle(color: Colors.black),),
        backgroundColor: AppColor.primaryColor,
      ),
      body: StreamBuilder(
          stream: widget.bloc.loading,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as bool;
              if (data) {
                return const Center(child: CircularProgressIndicator(color: AppColor.primaryColor,));
              } else {
                return SingleChildScrollView(
                  child: StreamBuilder(
                    stream: widget.bloc.author.stream,
                    builder: (context, snapshot)  {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator(color: AppColor.primaryColor,));
                      } else {
                        final data = snapshot.data as Author;
                        widget.bloc.nameController.text = data.name;
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              StreamBuilder(
                                stream: widget.bloc.file,
                                builder: ((context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox(
                                      width: 100,
                                      height: 200,
                                      child: GestureDetector(
                                        child: Image.network(data.avatarLink),
                                        onTap: () => widget.bloc.pickImage(),
                                      ),
                                    );
                                  } else {
                                    return Image.file(
                                      snapshot.data as File,
                                      width: 100,
                                      height: 200,
                                    );
                                  }
                                }), 
                              ),
                              const Text(AppString.avatar),
                              TextField(
                                controller: widget.bloc.nameController,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: const InputDecoration(
                                  labelText: AppString.name,
                                  
                                ),
                              ),
                              const SizedBox(height: 5,),
                              ElevatedButton(
                                child: const Text(AppString.update, style: TextStyle(color: Colors.black),),
                                style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor),
                                onPressed: () {
                                  widget.bloc.updateProfile();
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  ),
                );
              }
            } else {
              return Container();
            }
          }) 
        ),
    );
  }
}