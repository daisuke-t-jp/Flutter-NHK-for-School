import 'package:flutter/material.dart';
import 'package:nhk_for_school/api/nhk_uri.dart';
import 'package:provider/provider.dart';

import 'package:nhk_for_school/widget/detail_widget.dart';
import 'package:nhk_for_school/model/info_model.dart';
import 'package:nhk_for_school/model/state_model.dart';

// お気に入りウィジェット
class FavroiteWidget extends StatefulWidget {
  const FavroiteWidget({Key? key}) : super(key: key);

  @override
  State<FavroiteWidget> createState() => _FavroiteWidgetState();
}

class _FavroiteWidgetState extends State<FavroiteWidget> {
  @override
  void initState() {
    super.initState();
  }

  // コンテンツなしテキスト
  Widget _noContentsText() {
    return Align(
        alignment: Alignment.center,
        child: Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Text(NHKUri.apiKey.isNotEmpty ? 'お気に入りがありません。': 'API キーが設定されていません。',
                style: const TextStyle(color: Colors.blueGrey, fontSize: 18))));
  }

  // 検索結果リスト
  Widget _listView(List<InfoModel> infoList) {
    return ListView.builder(
      itemCount: infoList.length,
      itemExtent: 100,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Column(
            children: <Widget>[
              ListTile(
                dense: true,
                leading: Image.network(
                  infoList[index].result.thumbnailUrl,
                ),
                title: Text(infoList[index].result.name,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(infoList[index].result.description,
                    maxLines: 3, overflow: TextOverflow.ellipsis),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailWidget(contentId: infoList[index].result.id),
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
    final FavoriteInfoStateModel favoriteInfoState =
        Provider.of<FavoriteInfoStateModel>(context, listen: true);

    return Scaffold(
        body: Column(children: <Widget>[
      favoriteInfoState.infoList.isEmpty
          // コンテンツなしテキスト
          ? _noContentsText()

          // リストビュー
          : Flexible(child: _listView(favoriteInfoState.infoList)),
    ]));
  }
}
