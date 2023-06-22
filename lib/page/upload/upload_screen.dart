import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reading_book_4k/page/upload/upload_bloc.dart';

import '../../assets/app_string.dart';
import '../../config/app_color.dart';

class UploadScreen extends StatefulWidget {
  UploadScreen({Key? key}) : super(key: key);
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final UploadBloc bloc = UploadBloc();
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  bool isPublic = true;

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.addYourStory, style: TextStyle(color: Colors.black),),
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
                child: Padding(
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
                                child: Image.asset('assets/images/img_holder.png'),
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
                      const Text(AppString.cover),
                      TextField(
                        controller: widget.titleController,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          labelText: AppString.title,
                        ),
                      ),
                      TextField(
                        controller: widget.contentController,
                        textAlignVertical: TextAlignVertical.top,
                        minLines: 10,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          labelText: AppString.content,
                          
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: isPublic, 
                            checkColor: Colors.black,
                            activeColor: AppColor.primaryColor,
                            onChanged: (value) {
                              setState(() {
                                isPublic = value ?? true;
                                widget.bloc.isPublic = value ?? true;
                              });
                            }
                          ),
                          const Text(AppString.public, textAlign: TextAlign.center,),
                      ]),
                      const SizedBox(height: 5,),
                      ElevatedButton(
                        child: const Text(AppString.addYourStory, style: TextStyle(color: Colors.black),),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor),
                        onPressed: () {
                          widget.bloc.addStory(widget.titleController.text, widget.contentController.text);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return Container();
          }
        }) 
      )
    );
  }
}