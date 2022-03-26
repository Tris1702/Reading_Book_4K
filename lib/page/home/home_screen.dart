import 'package:flutter/material.dart';
import 'package:reading_book_4k/page/home/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = HomeBloc();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => bloc.pickFile(),
              child: const Text('Pick'),
            ),
            ElevatedButton(
              onPressed: () => bloc.play(),
              child: const Text('play'),
            ),
            ElevatedButton(
              onPressed: () => bloc.pause(),
              child: const Text('pause'),
            ),
            StreamBuilder(
              stream: bloc.text.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  String text = snapshot.data.toString();
                  return Text(text);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
