import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/config/app_color.dart';
import 'package:reading_book_4k/data/stories.dart';
import 'package:reading_book_4k/page/reading/reading_bloc.dart';

class ReadingScreen extends StatefulWidget {
  final String content;
  final String id;
  final String name;
  const ReadingScreen(
      {Key? key, required this.content, required this.id, required this.name})
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
    if (widget.content.isEmpty) {
      bloc.getStoryInfo(widget.id);
    } else {
      bloc.text = widget.content;
    }
    return Scaffold(
      appBar: AppBar(
        title: widget.name.isEmpty
            ? const Text(
                AppString.content,
                style: TextStyle(fontStyle: FontStyle.italic),
              )
            : Text(widget.name),
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
                        ? bloc.removeFromFav(widget.id)
                        : bloc.addToFav(widget.id);
                  },
                );
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
                    return SizedBox(
                      child: SingleChildScrollView(
                        child: bodyStory(widget.content, bloc),
                      ),
                    );
                  } else {
                    var data = snapshot.data as Stories;
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
                  playButton(bloc),
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
              primary: AppColor.primaryColor,
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
