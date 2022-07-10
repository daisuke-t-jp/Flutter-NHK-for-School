// NHK for School Uri クラス
class NHKUri {
  static const apiKey = ''; // ここに API キーを設定する

  static Uri keyword(String keyword) {
    return Uri.https('api.nhk.or.jp', '/school/v1/nfsvideos/keyword', {
      'keywords': keyword,
      'apikey': apiKey,
    });
  }

  static Uri detail(String contentId) {
    return Uri.https('api.nhk.or.jp', '/school/v1/nfsvideo/id/$contentId', {
      'apikey': apiKey,
    });
  }
}
