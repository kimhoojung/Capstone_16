import 'package:flutter/material.dart';
import 'recom/recom_page_1.dart';
import 'search/search_page_1.dart';
import 'community/community_page_1.dart';
import 'mypage/mypage_page_1.dart';

class TabPage extends StatefulWidget {
  static const routeName = '/tab';

  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _currentIndex = 0;

  final _pages = const [
    RecomPage1(),
    SearchPage1(),
    CommunityPage1(),
    MypagePage1(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'AI추천',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '제품 검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: '게시판',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
