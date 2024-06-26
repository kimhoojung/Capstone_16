import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // 날짜 포맷팅을 위한 패키지

class CommunityPage2 extends StatefulWidget {
  final String postId;
  final String productName;
  final String productInfo;

  const CommunityPage2({
    Key? key,
    required this.postId,
    required this.productName,
    required this.productInfo,
  }) : super(key: key);

  @override
  _CommunityPage2State createState() => _CommunityPage2State();
}

class _CommunityPage2State extends State<CommunityPage2> {
  final TextEditingController _commentController = TextEditingController();
  String _userId = '';
  String _nickname = '';
  int _likesCount = 0;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadLikesCount();
    _checkIfLiked();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
      _nickname = prefs.getString('nickname') ?? '';
    });
  }

  Future<void> _loadLikesCount() async {
    DocumentSnapshot postSnapshot = await FirebaseFirestore.instance.collection('posts').doc(widget.postId).get();
    if (postSnapshot.exists) {
      setState(() {
        _likesCount = postSnapshot['likeCount'] ?? 0;
      });
    }
  }

  Future<void> _checkIfLiked() async {
    QuerySnapshot likeSnapshot = await FirebaseFirestore.instance
        .collection('likes')
        .where('userId', isEqualTo: _userId)
        .where('postId', isEqualTo: widget.postId)
        .get();

    if (likeSnapshot.docs.isNotEmpty) {
      setState(() {
        _isLiked = true;
      });
    }
  }

  Future<void> _submitComment() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글을 입력하세요.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('comments').add({
        'content': _commentController.text,
        'nickname': _nickname,
        'postId': widget.postId,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': _userId,
      });

      _commentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글 작성에 실패했습니다: $e')),
      );
    }
  }

  Future<void> _toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference postRef = FirebaseFirestore.instance.collection('posts').doc(widget.postId);
      DocumentSnapshot postSnapshot = await transaction.get(postRef);

      if (!postSnapshot.exists) {
        throw Exception("Post does not exist!");
      }

      int newLikesCount = postSnapshot['likeCount'] + (_isLiked ? 1 : -1);
      transaction.update(postRef, {'likeCount': newLikesCount});
    });

    if (_isLiked) {
      await FirebaseFirestore.instance.collection('likes').add({
        'userId': _userId,
        'postId': widget.postId,
      });
    } else {
      QuerySnapshot likeSnapshot = await FirebaseFirestore.instance
          .collection('likes')
          .where('userId', isEqualTo: _userId)
          .where('postId', isEqualTo: widget.postId)
          .get();

      for (var doc in likeSnapshot.docs) {
        await FirebaseFirestore.instance.collection('likes').doc(doc.id).delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.productName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(widget.productInfo, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                  onPressed: _toggleLike,
                ),
                SizedBox(width: 8),
                Text('$_likesCount likes'),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('comments')
                    .where('postId', isEqualTo: widget.postId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No comments found'));
                  }

                  final comments = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      final timestamp = comment['timestamp'] as Timestamp?;
                      final formattedTime = timestamp != null
                          ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate())
                          : 'Unknown time';

                      return ListTile(
                        title: Text(comment['nickname'] ?? 'Unknown'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(formattedTime),
                            SizedBox(height: 4),
                            Text(comment['content'] ?? ''),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: '댓글 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitComment,
              child: Text('댓글 등록'),
            ),
          ],
        ),
      ),
    );
  }
}
