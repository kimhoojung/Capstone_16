import 'package:flutter/material.dart';

class SearchPage2 extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName), // 제품 이름을 앱 바에 표시
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // 좋아요 버튼 눌렀을 때의 액션 구현
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // 상하 여백 없이 좌우만 16의 패딩 추가
            child: Container(
              height: 400.0, // 이미지 높이 300으로 고정
              width: double.infinity, // 너비를 최대로 설정하여 좌우 여백이 동일하게 적용
              child: Image.asset(productImage, fit: BoxFit.cover), // 제품 이미지
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 0), // 이미지 아래와 좌우에만 패딩 추가
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName, // 제품 이름
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8), // 제품 이름과 설명 사이 8의 공간 추가
                Text(
                  productInfo, // 제품 설명
                  style: TextStyle(fontSize: 18),
                ),
                // 나머지 UI 요소들을 여기에 추가합니다.
              ],
            ),
          ),
        ],
      ),
    );
  }
}
