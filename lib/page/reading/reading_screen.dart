import 'package:flutter/material.dart';
import 'package:reading_book_4k/data/stories.dart';
import 'package:reading_book_4k/page/reading/reading_bloc.dart';

class ReadingScreen extends StatelessWidget {
  final String name;
  const ReadingScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReadingBloc bloc = ReadingBloc();
    bloc.getStory(name);
    return Scaffold(
      body: StreamBuilder(
        stream: bloc.stories.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            var data = snapshot.data as Stories;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title:
                    Text(data.name, style: const TextStyle(color: Colors.black)),
              ),
              body: SingleChildScrollView(
                child: Text(data.content,
                    style: const TextStyle(color: Colors.black, fontSize: 18)),
              ),
            );
          }
        },
      ),
    );
  }
}
