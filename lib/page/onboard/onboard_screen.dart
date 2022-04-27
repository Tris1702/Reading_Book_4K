import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/page/onboard/onboard_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../config/app_color.dart';

class OnBoard extends StatelessWidget {
  final int initialIndex;
  const OnBoard({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OnBoardBloc bloc = OnBoardBloc();
    bloc.init();
    bloc.changeIndex(initialIndex);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          AppString.yourBookShelf,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic),
        ),
      ),
      body: StreamBuilder(
        stream: bloc.page.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return snapshot.data! as Widget;
          }
        },
      ),
      bottomNavigationBar: StreamBuilder(
        stream: bloc.index.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return SalomonBottomBar(
                items: [
                  SalomonBottomBarItem(
                    icon: const FaIcon(FontAwesomeIcons.house),
                    title: const Text(AppString.home),
                  ),
                  SalomonBottomBarItem(
                    icon: const FaIcon(FontAwesomeIcons.solidHeart),
                    title: const Text(AppString.favorite),
                  ),
                  SalomonBottomBarItem(
                    icon: const FaIcon(FontAwesomeIcons.bookBookmark),
                    title: const Text(AppString.library2),
                  ),
                  SalomonBottomBarItem(
                    icon: const FaIcon(FontAwesomeIcons.upload),
                    title: const Text(AppString.onPhone),
                  ),
                ],
                currentIndex: snapshot.data! as int,
                selectedItemColor: AppColor.selectedColor,
                onTap: (index) => bloc.changeIndex(index)
                // unselectedItemColor: Colors.white,
                );
          }
        },
      ),
    );
  }
}
