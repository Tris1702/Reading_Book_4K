import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reading_book_4k/page/update_story/update_story_bloc.dart';

import '../../assets/app_string.dart';
import '../../config/app_color.dart';
import '../../model/story.dart';

class UpdateStoryScreen extends StatefulWidget {
  final String storyId;
  final UpdateStoryBloc bloc = UpdateStoryBloc();
  
  UpdateStoryScreen({Key? key, required this.storyId}) : super(key: key);
  
  @override
  State<UpdateStoryScreen> createState() => _UpdateStoryScreenState();
}

class _UpdateStoryScreenState extends State<UpdateStoryScreen> {

  bool? isPublic;

  @override
  Widget build(BuildContext context) {
    widget.bloc.init();
    widget.bloc.getStory(widget.storyId);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.updateYourStory, style: TextStyle(color: Colors.black),),
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
              return StreamBuilder(
                stream: widget.bloc.story.stream,
                builder: (context, snapshot)  {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator(color: AppColor.primaryColor,));
                  } else {
                    final data = snapshot.data as Story;
                    isPublic ??= data.isGlobal;
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
                                      child: Image.network(data.coverLink),
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
                              controller: widget.bloc.titleController,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: const InputDecoration(
                                labelText: AppString.title,
                              ),
                            ),
                            TextField(
                              controller: widget.bloc.contentController,
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
                              child: const Text(AppString.update, style: TextStyle(color: Colors.black),),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor),
                              onPressed: () {
                                widget.bloc.updateStory(widget.storyId, widget.bloc.titleController.text, widget.bloc.contentController.text);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
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