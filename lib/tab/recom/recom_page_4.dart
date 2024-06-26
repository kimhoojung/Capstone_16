import 'package:flutter/material.dart';
import 'recom_page_5.dart';

class RecomPage4 extends StatelessWidget {
  const RecomPage4({Key? key}) : super(key: key);

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
                  '거의 다 왔어요!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                Wrap(
                  spacing: 16, // 가로 간격
                  runSpacing: 16, // 세로 간격
                  alignment: WrapAlignment.center,
                  children: List<Widget>.generate(
                    7, // 버튼 개수
                        (index) => ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecomPage5()),
                        );
                      },
                      child: Text(
                        '#${['Soft(Mute)', 'Light', 'Bright', 'Deep(Dark)', 'Vivid', 'True', 'Strong'][index]}',
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // 둥근 모서리
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      ),
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
