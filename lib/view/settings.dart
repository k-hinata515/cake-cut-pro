import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isAutoPercentageOn = false; // 自動割合のスイッチの状態を保持する変数
  List<String> textBoxValues = []; // 各テキストボックスの値を保持するリスト
  int textBoxCount = 1; // テキストボックスの数を保持する変数

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'), // アプリバーのタイトル
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 画面のパディング
        child: Column(
          children: [
            SwitchListTile(
              title: Text('自動割合ON/OFF'), // スイッチのタイトル
              value: isAutoPercentageOn, // スイッチの現在の状態
              onChanged: (bool value) {
                setState(() {
                  isAutoPercentageOn = value; // スイッチの状態を更新
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: textBoxCount, // テキストボックスの数
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0), // テキストボックス間のパディング
                    child: TextField(
                      onChanged: (value) {
                        if (index < textBoxValues.length) {
                          textBoxValues[index] = value; // 既存のテキストボックスの値を更新
                        } else {
                          textBoxValues.add(value); // 新しいテキストボックスの値を追加
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), // テキストボックスの枠線
                        labelText: '${index + 1}人目', // テキストボックスのラベル
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // ボタンを左右に配置
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      textBoxCount++; // テキストボックスの数を増やす
                    });
                  },
                  child: Text('追加'), // ボタンのラベル
                ),
                FloatingActionButton(
                  onPressed: textBoxCount == 1
                      ? null
                      : () {
                          // ここに画面遷移のコードを追加します
                        },
                  child: Icon(Icons.camera_alt), // カメラアイコン
                  backgroundColor:
                      textBoxCount == 1 ? Colors.grey : Colors.blue,
                  tooltip: 'カメラを開く', // ツールチップ
                ),
                ElevatedButton(
                  onPressed: () {
                    if (textBoxCount > 1) {
                      setState(() {
                        textBoxCount--; // テキストボックスの数を減らす
                        if (textBoxValues.length > textBoxCount) {
                          textBoxValues.removeLast(); // 最後のテキストボックスの値を削除
                        }
                      });
                    }
                  },
                  child: Text('削除'), // ボタンのラベル
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
