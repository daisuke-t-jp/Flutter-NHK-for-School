import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nhk_for_school/api/nhk_uri.dart';
import 'package:nhk_for_school/model/info_model.dart';

// お気に入りリストの状態モデル
class FavoriteStateModel with ChangeNotifier {
  List<String> _favoriteList = [];
  FavoriteInfoStateModel? favoriteInfoState;
  static const String sharedPreferenceKeyFavoriteList = 'favorite_list';

  void addFavorite(String contentId) {
    _favoriteList.add(contentId);

    _save();

    notifyListeners();

    favoriteInfoState?.fetch(_favoriteList);
  }

  void removeFavorite(String contentId) {
    _favoriteList.remove(contentId);

    _save();

    notifyListeners();

    favoriteInfoState?.fetch(_favoriteList);
  }

  bool isFavorite(String contentId) {
    return _favoriteList.contains(contentId);
  }

  List<String> favoriteList() {
    return _favoriteList;
  }

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _favoriteList = prefs.getStringList(sharedPreferenceKeyFavoriteList) ?? [];

    favoriteInfoState?.fetch(_favoriteList);
  }

  Future<void> _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(sharedPreferenceKeyFavoriteList, _favoriteList);
  }
}

// お気に入り情報の状態モデル
class FavoriteInfoStateModel with ChangeNotifier {
  final List<InfoModel> _infoList = [];
  List<InfoModel> get infoList => _infoList;

  void fetch(List<String> favoriteList) async {
    _infoList.clear();

    if (NHKUri.apiKey.isEmpty) {
      return;
    }

    for (final contentId in favoriteList) {
      var response = await http.get(NHKUri.detail(contentId));
      _infoList.add(InfoModel.fromJson(jsonDecode(response.body)));
    }

    notifyListeners();
  }
}
