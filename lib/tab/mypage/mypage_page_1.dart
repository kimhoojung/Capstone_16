import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lip_service_2/login/login_page.dart';
import 'my_posts_page.dart';

class MypagePage1 extends StatefulWidget {
  const MypagePage1({Key? key}) : super(key: key);

  @override
  _MypagePage1State createState() => _MypagePage1State();
}

class _MypagePage1State extends State<MypagePage1> {
  String _name = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

        if (userDoc.exists) {
          setState(() {
            _name = userDoc['name'] ?? 'Unknown';
          });
        } else {
          setState(() {
            _name = 'User not found';
          });
        }
      } else {
        setState(() {
          _name = 'No user ID found';
        });
      }
    } catch (e) {
      setState(() {
        _name = 'Error loading user data';
      });
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '안녕하세요, $_name님!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPostsPage()),
                );
              },
              child: Text('내 게시물'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 좋아요 한 게시물 화면으로 이동
              },
              child: Text('좋아요 한 게시물'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 찜한 목록 화면으로 이동
              },
              child: Text('찜한 목록'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _logout,
              child: Text('로그아웃'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), backgroundColor: Colors.red, // 로그아웃 버튼을 빨간색으로 설정
              ),
            ),
          ],
        ),
      ),
    );
  }
}
