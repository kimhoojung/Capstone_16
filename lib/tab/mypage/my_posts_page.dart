import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({Key? key}) : super(key: key);

  @override
  _MyPostsPageState createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  String _userId = '';
  List<DocumentSnapshot> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadUserPosts();
  }

  Future<void> _loadUserPosts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        print('User ID: $userId');  // 로그 추가

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where('authorId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .get();

        setState(() {
          _userId = userId;
          _posts = querySnapshot.docs;
          print('Loaded ${_posts.length} posts');  // 로그 추가
        });
      } else {
        print('No user ID found');  // 로그 추가
      }
    } catch (e) {
      print('Error loading user posts: $e');  // 로그 추가
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 게시물'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _posts.isEmpty
            ? Center(child: Text('작성한 게시물이 없습니다.'))
            : ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            var post = _posts[index];
            return Card(
              child: ListTile(
                title: Text(post['title'] ?? 'No Title'),
                subtitle: Text(post['content'] ?? 'No Content'),
                onTap: () {
                  // 게시물 클릭 시 자세히 보기
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
