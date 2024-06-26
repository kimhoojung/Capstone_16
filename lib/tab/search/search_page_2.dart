import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage2 extends StatefulWidget {
  final String productName;
  final String productInfo;
  final String productImage;

  const SearchPage2({
    Key? key,
    required this.productName,
    required this.productInfo,
    required this.productImage,
  }) : super(key: key);

  @override
  _SearchPage2State createState() => _SearchPage2State();
}

class _SearchPage2State extends State<SearchPage2> {
  int _likesCount = 0;
  bool _isLiked = false;
  String _userId = '';

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
    });
  }

  Future<void> _loadLikesCount() async {
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance.collection('products').doc(widget.productName).get();
    if (productSnapshot.exists) {
      setState(() {
        _likesCount = productSnapshot['likeCount'] ?? 0;
      });
    }
  }

  Future<void> _checkIfLiked() async {
    DocumentSnapshot likeSnapshot = await FirebaseFirestore.instance.collection('likes').doc('$_userId${widget.productName}').get();
    if (likeSnapshot.exists) {
      setState(() {
        _isLiked = true;
      });
    }
  }

  Future<void> _toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });

    final productRef = FirebaseFirestore.instance.collection('products').doc(widget.productName);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot productSnapshot = await transaction.get(productRef);

      if (!productSnapshot.exists) {
        await productRef.set({
          'productName': widget.productName,
          'productInfo': widget.productInfo,
          'productImage': widget.productImage,
          'likeCount': _isLiked ? 1 : 0,
        });
      } else {
        int newLikesCount = (productSnapshot['likeCount'] ?? 0) + (_isLiked ? 1 : -1);
        transaction.update(productRef, {'likeCount': newLikesCount});
      }
    });

    if (_isLiked) {
      await FirebaseFirestore.instance.collection('likes').doc('$_userId${widget.productName}').set({
        'userId': _userId,
        'productName': widget.productName,
      });
    } else {
      await FirebaseFirestore.instance.collection('likes').doc('$_userId${widget.productName}').delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        actions: [
          IconButton(
            icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleLike,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 400.0,
              width: double.infinity,
              child: Image.asset(widget.productImage, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.productInfo,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Text('$_likesCount likes'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
