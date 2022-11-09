import 'package:betagram/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';

class webScreenLayout extends StatefulWidget {
  const webScreenLayout({super.key});

  @override
  State<webScreenLayout> createState() => _webScreenLayoutState();
}

class _webScreenLayoutState extends State<webScreenLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  // String username = "";
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTap(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
              onPressed: () => navigationTap(0),
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              )),
          IconButton(
            icon: Icon(Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor),
            onPressed: () => navigationTap(1),
          ),
          IconButton(
              onPressed: () => navigationTap(2),
              icon: Icon(Icons.add_a_photo,
                  color: _page == 2 ? primaryColor : secondaryColor)),
          IconButton(
              onPressed: () => navigationTap(3),
              icon: Icon(Icons.favorite_outlined,
                  color: _page == 3 ? primaryColor : secondaryColor)),
          IconButton(
              onPressed: () => navigationTap(4),
              icon: Icon(Icons.person,
                  color: _page == 4 ? primaryColor : secondaryColor)),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
        controller: pageController,
        children: navBarWidgets,
      ),
    );
  }
}
