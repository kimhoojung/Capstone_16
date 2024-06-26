import 'package:flutter/material.dart';
import 'search_page_2.dart';

class SearchPage1 extends StatelessWidget {
  const SearchPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('제품 쇼핑'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: '제품을 입력하세요',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text("오늘의 추천"),
          Container(
            padding: EdgeInsets.all(16),
            height: 160, // 전체 가로 스크롤 섹션의 높이 설정

            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 스크롤 방향을 가로로 설정
              itemCount: 5, // 생성할 아이템의 개수
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 160, // 카드의 너비 설정
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage2(
                            productName: '제품 $index', // 제품 이름
                            productInfo: '제품에 대한 설명 $index', // 제품 설명
                            productImage: 'assets/images/cosmetic${index + 1}.jpg', // 제품 이미지
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 8), // 좌우 마진 설정
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Image.asset(
                              'assets/images/cosmetic${index + 1}.jpg', // 이미지 URL
                              fit: BoxFit.cover, // 컨테이너에 맞게 이미지를 채움
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8), // 이미지 아래의 텍스트에 패딩 설정
                            child: Text(
                              '제품 $index',
                              style: TextStyle(fontSize: 16), // 텍스트 크기 설정
                              overflow: TextOverflow.ellipsis, // 긴 텍스트를 줄임표로 처리
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Text("카테고리별 랭킹"),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: 5, // 세로 스크롤 카드 개수
              itemBuilder: (BuildContext context, int index) {
                // 카드에 표시할 정보 (더미 데이터)
                String name = '제품 $index';
                String personalColorInfo = '퍼스널 컬러 정보 $index';
                String productInfo = '제품에 대한 설명 $index';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _buildProfileCard(context, name, personalColorInfo, productInfo),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, String name, String personalColorInfo, String productInfo) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage2(
              productName: name,
              productInfo: productInfo,
              productImage: 'assets/images/cosmetic2.jpg', // 임시 이미지 URL
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Image.asset(
                'assets/images/cosmetic2.jpg', // 임시 이미지 URL
                fit: BoxFit.cover,
                width: 100, // 이미지 너비
                height: 100, // 이미지 높이
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(personalColorInfo),
                    SizedBox(height: 8),
                    Text(productInfo),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
