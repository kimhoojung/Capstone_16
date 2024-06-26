import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_post_screen.dart';
import 'community_page_2.dart';

class CommunityPage1 extends StatefulWidget {
  const CommunityPage1({Key? key}) : super(key: key);

  @override
  _CommunityPage1State createState() => _CommunityPage1State();
}

class _CommunityPage1State extends State<CommunityPage1> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
    });
  }

  void _navigateToAddPostScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPostScreen(),
      ),
    );

    if (result != null && result is Map<String, String>) {
      await _firestore.collection('posts').add({
        'title': result['title']!,
        'content': result['content']!,
        'authorId': _userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
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
        automaticallyImplyLeading: false,
        title: Text('게시판'),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _navigateToAddPostScreen(context),
            child: Text('게시물 추가'),
          ),
          SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('posts').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No posts found'));
                }

                final posts = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = posts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () => _navigateToPostDetail(
                          context,
                          post.id,
                          post['title'] ?? 'No title',
                          post['content'] ?? 'No content',
                        ),
                        child: _buildProfileCard(
                          context,
                          post['title'] ?? 'No title',
                          post['content'] ?? 'No content',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, String title, String content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
