import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_book_4k/assets/app_string.dart';
import 'package:reading_book_4k/page/onboard/onboard_bloc.dart';

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
        backgroundColor: AppColor.primaryColor,
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
            return BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.house),
                    label: AppString.home,
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.solidHeart),
                    label: AppString.favorite,
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.bookBookmark),
                    label: AppString.library2,
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.upload),
                    label: AppString.onPhone,
                  ),
                ],
                backgroundColor: AppColor.primaryColor,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                currentIndex: snapshot.data! as int,
                selectedItemColor: Colors.black,
                onTap: (index) => bloc.changeIndex(index)
                // unselectedItemColor: Colors.white,
                );
          }
        },
      ),
    );
  }
}
