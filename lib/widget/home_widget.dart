import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:nhk_for_school/api/nhk_uri.dart';
import 'package:nhk_for_school/model/keyword_model.dart';
import 'package:nhk_for_school/widget/detail_widget.dart';

// ホームウィジェット
class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  KeywordModel _data =
      KeywordModel(counts: 0, page: 0, totalPages: 0, perPage: 0, result: []);

  Future<void> getData(String keyword) async {
    var response = await http.get(NHKUri.keyword(keyword));

    var result = KeywordModel.fromJson(jsonDecode(response.body));

    setState(() {
      _data = result;
    });
  }

  @override
  void initState() {
    super.initState();

    const List<String> keywords = [
      '気候',
      '環境',
      '植物',
      '動物',
      '平和',
      '歴史',
      '条約',
      '産業',
    ];

    if(NHKUri.apiKey.isNotEmpty) {
      getData(keywords[math.Random().nextInt(keywords.length)]);
    }
  }

  // 検索テキストフィールド
  Widget _searchTextField() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: TextField(
          onChanged: (String s) {
            setState(() {
              if(NHKUri.apiKey.isEmpty) {
                return;
              }
              
              _data = KeywordModel(
                  counts: 0, page: 0, totalPages: 0, perPage: 0, result: []);
              getData(s);
            });
          },
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'キーワードで検索',
          ),
        ));
  }

  // コンテンツなしテキスト
  Widget _noContentsText() {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Text(NHKUri.apiKey.isNotEmpty ? '検索結果がありません。': 'API キーが設定されていません。',
            style: const TextStyle(color: Colors.blueGrey, fontSize: 18)));
  }

  // 検索結果リスト
  Widget _listView() {
    return ListView.builder(
      itemCount: _data.result.length,
      itemExtent: 100,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Column(
            children: <Widget>[
              ListTile(
                dense: true,
                leading: Image.network(
                  _data.result[index].thumbnailUrl,
                ),
                title: Text(_data.result[index].name, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(_data.result[index].description, maxLines: 3, overflow: TextOverflow.ellipsis),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailWidget(contentId: _data.result[index].id),
                      ));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      // 検索テキストフィールド
      _searchTextField(),

      const SizedBox(height: 5),

      _data.result.isEmpty
          // コンテンツなしテキスト
          ? _noContentsText()

          // リストビュー
          : Flexible(child: _listView()),
    ]));
  }
}
