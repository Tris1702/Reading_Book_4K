import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/model/story.dart';
import 'package:reading_book_4k/page/reading/reading_bloc.dart';

class ReadingScreen extends StatefulWidget {
  final Story story;
  const ReadingScreen(
      {Key? key, required this.story})
      : super(key: key);
  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final ReadingBloc bloc = ReadingBloc();
  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.getAccess(widget.story.id!);
    bloc.getStoryInfo(widget.story.id!);
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [ 
                Text(widget.story.title),
                StreamBuilder(
                  stream: bloc.authorName.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      final authorName = snapshot.data as String;
                      return Text(authorName, style: const TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontSize: 11.0),);
                    }
                  })
              ]),
        elevation: 0,
        actions: [
          StreamBuilder(
            stream: bloc.textSize.stream,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                return IconButton(
                  icon: const FaIcon(FontAwesomeIcons.font),
                  onPressed: () => bloc.changeTextSize(context),
                );
              }
            },
          ),
          StreamBuilder(
            stream: bloc.allowUpdate.stream,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                bool allowUpdate = snapshot.data as bool;
                if (allowUpdate) {
                  return IconButton(
                    icon: const FaIcon(FontAwesomeIcons.penToSquare),
                    onPressed: () {
                      bloc.openUpdateStory(widget.story.id!);
                    },
                  );
                } else {
                  return Container();
                }
              }
            },
          ),
          StreamBuilder(
            stream: bloc.allowDelete.stream,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                bool allowDelete = snapshot.data as bool;
                if (allowDelete) {
                  return IconButton(
                    icon: const FaIcon(FontAwesomeIcons.trash),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(AppString.confirm),
                            content: const Text(AppString.areUSureDelete),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text(AppString.cancel, style: TextStyle(color: Colors.white),),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryColor),
                                child: StreamBuilder(
                                  stream: bloc.loading.stream,
                                  builder: (contextt, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Text(AppString.agree, style: TextStyle(color: Colors.black),);
                                    } else {
                                      final data = snapshot.data as bool;
                                      if (data) {
                                        return const CircularProgressIndicator();  
                                      } else {
                                        Navigator.of(context).pop();
                                        return const Text(AppString.agree);
                                      }
                                    }
                                  }
                                ),
                                onPressed: () {
                                  bloc.delete(widget.story);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Container();
                }
              }
            },
          ),
        ],
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.angleLeft),
          onPressed: () => bloc.backPress(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: bloc.stories.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    var data = snapshot.data as Story;
                    return SizedBox(
                      child: SingleChildScrollView(
                        child: bodyStory(data.content, bloc),
                      ),
                    );
                  }
                }),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StreamBuilder(
                        stream: bloc.isFav.stream,
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            bool isFav = snapshot.data as bool;
                            return IconButton(
                              icon: isFav
                                  ? const FaIcon(FontAwesomeIcons.solidHeart,
                                      color: Colors.red)
                                  : const FaIcon(
                                      FontAwesomeIcons.heart,
                                    ),
                              onPressed: () {
                                isFav
                                    ? bloc.removeFromFav(widget.story)
                                    : bloc.addToFav(widget.story);
                              },
                            );
                          }
                        },
                      ),
                      playButton(bloc),
                      GestureDetector(
                        child: StreamBuilder(
                          stream: bloc.speed.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Text("");
                            } else {
                              final speed = snapshot.data as int;
                              switch(speed) {
                                case 0:
                                  return const Text("0.5x");
                                case 1:
                                  return const Text("1x");
                                case 2:
                                  return const Text("2x");
                              }
                              return const Text("");
                            }
                          }
                        ),
                        onTap: () => bloc.changeSpeed(),
                      )
                    ]),
                  const SizedBox(
                    height: 5.0,
                  ),
                  slider(bloc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget bodyStory(String content, ReadingBloc bloc) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    child: StreamBuilder(
      stream: bloc.textSize.stream,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          var size = snapshot.data as double;
          return Text(
            content,
            style: TextStyle(color: Colors.black, fontSize: size),
          );
        }
      },
    ),
  );
}

Widget playButton(ReadingBloc bloc) {
  return StreamBuilder(
      stream: bloc.playing.stream,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          var isPlaying = snapshot.data as bool;
          return ElevatedButton(
            onPressed: () {
              isPlaying ? bloc.pause() : bloc.play();
            },
            child: isPlaying
                ? const FaIcon(FontAwesomeIcons.pause)
                : const FaIcon(FontAwesomeIcons.play),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(18),
              backgroundColor: AppColor.primaryColor,
            ),
          );
        }
      });
}

Widget slider(ReadingBloc bloc) {
  return StreamBuilder(
    stream: bloc.progress.stream,
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Container();
      var value = snapshot.data! as double;
      return Slider(
        value: value,
        onChanged: (newValue) {
          bloc.changeProgress(newValue);
        },
        activeColor: AppColor.primaryColor,
        inactiveColor: AppColor.backgroundLinearProgressBar,
      );
    },
  );
}
