import 'package:flutter/material.dart';
import 'dart:math';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('ホールケーキ切り分け表示')),
        body: CakeDivision(
          initialNumberOfSlices: 9,
          initialSize: 300,
          names: ['鎌野', '三宅', '大西', '本杉', 'Eve', 'Frank', 'Grace', 'Hank', 'Ivy'],
        ),
      ),
    );
  }
}

class CakeDivision extends StatefulWidget {
  final int initialNumberOfSlices;
  final double initialSize;
  final List<String> names;

  CakeDivision({required this.initialNumberOfSlices, required this.initialSize, required this.names});

  @override
  _CakeDivisionState createState() => _CakeDivisionState();
}

class _CakeDivisionState extends State<CakeDivision> {
  late List<String> randomizedNames;
  late int numberOfSlices;
  late double cakeSize;

  @override
  void initState() {
    super.initState();
    // 初期値の設定
    numberOfSlices = widget.initialNumberOfSlices;
    cakeSize = widget.initialSize;
    randomizedNames = List.from(widget.names)..shuffle();
  }

  void _randomizeNames() {
    // 名前をランダムにシャッフルして更新
    setState(() {
      randomizedNames.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ホールケーキの描画
        Container(
          width: cakeSize,
          height: cakeSize,
          child: CustomPaint(
            painter: CakePainter(numberOfSlices, randomizedNames),
          ),
        ),
        SizedBox(height: 20),
        
        // ケーキの大きさ調整用のスライダー
        Text('ケーキの大きさ: ${cakeSize.toInt()}'),
        Slider(
          value: cakeSize,
          min: 100,
          max: 400,
          divisions: 10,
          label: cakeSize.toInt().toString(),
          onChanged: (value) {
            setState(() {
              cakeSize = value;
            });
          },
        ),

        // スライス数を調整するスライダー
        Text('スライス数: $numberOfSlices'),
        Slider(
          value: numberOfSlices.toDouble(),
          min: 2,
          max: widget.names.length.toDouble(),
          divisions: widget.names.length - 1,
          label: numberOfSlices.toString(),
          onChanged: (value) {
            setState(() {
              numberOfSlices = value.toInt();
            });
          },
        ),

        // 更新ボタン
        ElevatedButton(
          onPressed: _randomizeNames, // ボタンを押すと名前を再シャッフル
          child: Text('更新する'),
        ),
      ],
    );
  }
}

// ケーキを描画するためのカスタムペインター
class CakePainter extends CustomPainter {
  final int numberOfSlices;
  final List<String> names;

  CakePainter(this.numberOfSlices, this.names);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 中心を計算
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    // 円を描画
    canvas.drawCircle(center, radius, paint);

    // 切り分ける角度を計算
    double sliceAngle = 2 * pi / numberOfSlices;

    for (int i = 0; i < numberOfSlices; i++) {
      double angle = sliceAngle * i;

      // 線の終点を計算
      final offset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      // 線を描画
      canvas.drawLine(center, offset, paint);

      // 名前を描画する座標を計算
      final textAngle = angle + sliceAngle / 2; // スライスの真ん中に配置
      final textOffset = Offset(
        center.dx + (radius / 1.5) * cos(textAngle),
        center.dy + (radius / 1.5) * sin(textAngle),
      );

      // 名前を描画
      _drawText(canvas, size, names[i], textOffset);
    }
  }

  // 名前を描画するヘルパー関数
  void _drawText(Canvas canvas, Size size, String text, Offset offset) {
    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 14), text: text);
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(offset.dx - tp.width / 2, offset.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
