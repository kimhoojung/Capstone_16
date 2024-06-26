import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lip_service_2/tab//community/community_page_2.dart';

class LikedPostsPage extends StatefulWidget {
  const LikedPostsPage({Key? key}) : super(key: key);

  @override
  _LikedPostsPageState createState() => _LikedPostsPageState();
}

class _LikedPostsPageState extends State<LikedPostsPage> {
  String _userId = '';
  List<DocumentSnapshot> _likedPosts = [];

  @override
  void initState() {
    super.initState();
    _loadLikedPosts();
  }

  Future<void> _loadLikedPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      QuerySnapshot likesSnapshot = await FirebaseFirestore.instance
          .collection('likes')
          .where('userId', isEqualTo: userId)
          .get();

      List<String> likedPostIds = likesSnapshot.docs.map((doc) => doc['postId'] as String).toList();

      if (likedPostIds.isNotEmpty) {
        QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where(FieldPath.documentId, whereIn: likedPostIds)
            .orderBy('timestamp', descending: true)
            .get();

        setState(() {
          _userId = userId;
          _likedPosts = postsSnapshot.docs;
        });
      }
    }
  }

  void _navigateToPostDetail(BuildContext context, String postId, String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityPage2(
          postId: postId,
          productName: title,
          productInfo: content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('좋아요 한 게시물'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _likedPosts.isEmpty
            ? Center(child: Text('좋아요 한 게시물이 없습니다.'))
            : ListView.builder(
          itemCount: _likedPosts.length,
          itemBuilder: (context, index) {
            var post = _likedPosts[index];
            return Card(
              child: ListTile(
                title: Text(post['title'] ?? 'No Title'),
                subtitle: Text(post['content'] ?? 'No Content'),
                onTap: () {
                  _navigateToPostDetail(
                    context,
                    post.id,
                    post['title'] ?? 'No title',
                    post['content'] ?? 'No content',
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
