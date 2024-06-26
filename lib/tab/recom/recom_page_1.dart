import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'recom_page_2.dart';

class RecomPage1 extends StatefulWidget {
  const RecomPage1({Key? key}) : super(key: key);

  @override
  _RecomPage1State createState() => _RecomPage1State();
}

class _RecomPage1State extends State<RecomPage1> {
  String _name = 'Loading...';
  String _personalColorInfo = '퍼스널 컬러 정보';
  String _productInfo = '사용 제품 정보';

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
            // 필요한 경우 다른 사용자 정보도 가져올 수 있음
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('프로필 정보'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _buildProfileCard(_name, _personalColorInfo, _productInfo),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecomPage2())
                );
              },
              child: Text('내 퍼스널 컬러 입력하기'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(String name, String personalColorInfo, String productInfo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(radius: 30),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(personalColorInfo),
                      Text(productInfo),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
