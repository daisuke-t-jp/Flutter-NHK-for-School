import 'package:flutter/material.dart';

import 'package:nhk_for_school/widget/webview_widget.dart';

// クレジットウィジェット
class CreditWidget extends StatefulWidget {
  const CreditWidget({Key? key}) : super(key: key);

  @override
  State<CreditWidget> createState() => _CreditWidgetState();
}

class _CreditWidgetState extends State<CreditWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              children: <Widget>[
                // タイトル
                const Align(
                  alignment: Alignment.center,
                  child: Text('情報提供:NHK',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                ),

                const SizedBox(height: 20),

                // 説明
                const Text('本アプリは NHK が公開している「NHK for School API」を使用しています。'),

                const SizedBox(height: 10),

                // リンク
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WebViewWidget(
                                    title: "NHK for School API について",
                                    url: 'https://school-api-portal.nhk.or.jp/',
                                  )));
                    },
                    child: const Text('NHK for School APIについて'))
              ],
            )));
  }
}
