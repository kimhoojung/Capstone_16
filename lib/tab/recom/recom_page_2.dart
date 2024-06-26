import 'package:flutter/material.dart';
import 'recom_page_3.dart';

class RecomPage2 extends StatelessWidget {
  const RecomPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI 추천'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                '당신은 웜톤인가요? 쿨톤인가요?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecomPage3(isWarmTone: true)
                      ),
                    ),
                    child: Text('웜톤'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecomPage3(isWarmTone: false)
                      ),
                    ),
                    child: Text('쿨톤'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
