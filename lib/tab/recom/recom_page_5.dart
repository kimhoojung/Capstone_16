import 'package:flutter/material.dart';
import 'recom_page_6.dart';

class RecomPage5 extends StatelessWidget {
  const RecomPage5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정보 입력'),
      ),
      body: SingleChildScrollView(
        child: Center( // Center 위젯을 추가하여 내용을 중앙에 정렬
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '당신의 퍼스널 컬러는...',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32), // 텍스트와 이미지 사이의 여백
                Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/lip2.png"), // 이미지 경로
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12), // 이미지의 모서리를 둥글게 처리
                  ),
                ),
                SizedBox(height: 32), // 이미지와 버튼 사이의 여백
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecomPage6()), // RecomPage6로 이동
                    );
                  },
                  child: Text(
                    '사용하시던 제품이 있나요?',
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
