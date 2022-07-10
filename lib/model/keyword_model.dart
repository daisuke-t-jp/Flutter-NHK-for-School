// キーワード検索 API のレスポンスモデル
class KeywordModel {
  final int counts;
  final int page;
  final int totalPages;
  final int perPage;
  final List<KeywordResultModel> result;

  KeywordModel({
    required this.counts,
    required this.page,
    required this.totalPages,
    required this.perPage,
    required this.result,
  });

  factory KeywordModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] == null) {
      return KeywordModel(
          counts: 0, page: 0, totalPages: 0, perPage: 0, result: []);
    }

    List<KeywordResultModel> result = [];
    List jsonArray = json['result'] as List;
    for (int i = 0; i < jsonArray.length; i++) {
      result.add(KeywordResultModel.fromJson(json['result'][i]));
    }

    return KeywordModel(
      counts: json['counts'],
      page: json['page'],
      totalPages: json['totalPages'],
      perPage: json['perPage'],
      result: result,
    );
  }
}

class KeywordResultModel {
  final String id;
  final String contentType;
  final String name;
  final String about;
  final String description;
  final String url;
  final String thumbnailUrl;
  final List<String> grades;
  final List<String> subjectAreas;

  KeywordResultModel({
    required this.id,
    required this.contentType,
    required this.name,
    required this.about,
    required this.description,
    required this.url,
    required this.thumbnailUrl,
    required this.grades,
    required this.subjectAreas,
  });

  factory KeywordResultModel.fromJson(Map<String, dynamic> json) {
    return KeywordResultModel(
      id: json['id'],
      contentType: json['contentType'],
      name: json['name'],
      about: json['about']['nfsSeriesName'] ?? "",
      description: json['description'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
      grades: json['grades'].cast<String>(),
      subjectAreas: json['subjectAreas'].cast<String>(),
    );
  }
}
