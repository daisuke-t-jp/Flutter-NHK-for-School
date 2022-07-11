# Flutter-NHK-for-School

[NHK for School API](https://school-api-portal.nhk.or.jp/) を使用したデモアプリです。  
Flutter で作成されています。

`nhk_uri.dart` 内に API キーを設定してビルドしてください。

```dart
// NHK for School Uri クラス
class NHKUri {
  static const apiKey = ''; // ここに API キーを設定する

  static Uri keyword(String keyword) {
    return Uri.https('api.nhk.or.jp', '/school/v1/nfsvideos/keyword', {
```

<img src="https://raw.githubusercontent.com/daisuke-t-jp/Flutter-NHK-for-School/main/doc/home.png" width="280px"> <img src="https://raw.githubusercontent.com/daisuke-t-jp/Flutter-NHK-for-School/main/doc/detail.png" width="280px">

「情報提供:NHK」
