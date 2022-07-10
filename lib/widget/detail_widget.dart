import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:nhk_for_school/api/nhk_uri.dart';
import 'package:nhk_for_school/widget/webview_widget.dart';
import 'package:nhk_for_school/model/info_model.dart';
import 'package:nhk_for_school/model/state_model.dart';

// 詳細ウィジェット
class DetailWidget extends StatefulWidget {
  const DetailWidget({Key? key, required this.contentId}) : super(key: key);
  final String contentId;

  @override
  State<DetailWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  bool _hasData = false;
  InfoModel _data = InfoModel(
      result: InfoResultModel(
          id: "",
          contentType: "",
          name: "",
          about: "",
          description: "",
          text: "",
          url: "",
          thumbnailUrl: "",
          grades: [],
          subjectAreas: []));

  Future<void> getData() async {
    final String contentId = widget.contentId;
    var response = await http.get(NHKUri.detail(contentId));
    var result = InfoModel.fromJson(jsonDecode(response.body));

    if (mounted) {
      setState(() {
        _hasData = true;
        _data = result;
      });
    }
  }

  Future<void> toggleFavorite(FavoriteStateModel appState) async {
    if (appState.isFavorite(widget.contentId)) {
      appState.removeFavorite(widget.contentId);
    } else {
      appState.addFavorite(widget.contentId);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  // お気に入りボタン
  Widget _favoriteButton(FavoriteStateModel appState) {
    return Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: const Icon(Icons.favorite),
          color: appState.isFavorite(widget.contentId)
              ? Colors.pink.shade300
              : Colors.grey,
          iconSize: 30,
          onPressed: () {
            toggleFavorite(appState);

            Fluttertoast.showToast(
                msg: appState.isFavorite(widget.contentId)
                    ? 'お気に入りに追加しました。'
                    : 'お気に入りから削除しました。',
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.lightGreen.withAlpha(220));
          },
        ));
  }

  // タイトル
  Widget _titleText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(_data.result.name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  // 説明テキスト
  Widget _descriptionText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(_data.result.description,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
    );
  }

  // 内容テキスト
  Widget _contentText() {
    return _data.result.text.isNotEmpty
        ? // 下地の灰色
        Container(
            width: double.infinity,
            color: Colors.grey.shade200,
            alignment: Alignment.center, // where to position the child

            child: Column(children: <Widget>[
              // ヘッダー
              Container(
                width: double.infinity,
                height: 40.0,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('内容',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),

              // 本文
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_data.result.text,
                      style: const TextStyle(fontSize: 12)),
                ),
              ),
            ]))
        : Container();
  }

  // Web リンクボタン
  Widget _webLinkButton() {
    return SizedBox(
      width: 180,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          onPrimary: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewWidget(
                        title: _data.result.name,
                        url: _data.result.url,
                      )));
        },
        child: const Text('NHK for School で\nくわしく見る',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FavoriteStateModel appState = Provider.of<FavoriteStateModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(_hasData ? _data.result.name : ""),
      ),
      body: _hasData
          ? SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 60),
              child: Column(
                children: <Widget>[
                  // サムネイル
                  Image(
                    image: NetworkImage(_data.result.thumbnailUrl),
                  ),

                  const SizedBox(height: 0),

                  // お気に入りボタン
                  _favoriteButton(appState),

                  const SizedBox(height: 0),

                  // タイトルテキスト
                  _titleText(),

                  const SizedBox(height: 5),

                  // 説明テキスト
                  _descriptionText(),

                  const SizedBox(height: 20),

                  // 内容テキスト
                  _contentText(),

                  const SizedBox(height: 30),

                  // 動画を見るボタン
                  _webLinkButton(),
                ],
              ),
            )
          : Container(),
    );
  }
}
