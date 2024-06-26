import 'package:flutter/material.dart';
import 'recom_page_7.dart';

class RecomPage6 extends StatelessWidget {
  const RecomPage6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI 추천'),
      ),
      body: SingleChildScrollView(
        child: Center( // Center 위젯을 추가하여 내용을 중앙에 정렬
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '사용하시는 제품을 알려주세요.',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: '제품명을 입력해주세요.',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                SizedBox(height: 160),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecomPage7()), // RecomPage6로 이동
                    );
                  },
                  child: Text(
                    '이 제품이 맞아요.',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(400, 50), // 버튼의 최소 사이즈 설정
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 버튼의 둥근 모서리
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
