// 詳細 API のレスポンスモデル
class InfoModel {
  final InfoResultModel result;

  InfoModel({
    required this.result,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    List jsonArray = json['result'] as List;
    Map<String, dynamic> map = jsonArray.first as Map<String, dynamic>;

    return InfoModel(
      result: InfoResultModel.fromJson(map),
    );
  }
}

class InfoResultModel {
  final String id;
  final String contentType;
  final String name;
  final String? about;
  final String description;
  final String text;
  final String url;
  final String thumbnailUrl;
  final List<String> grades;
  final List<String> subjectAreas;

  InfoResultModel({
    required this.id,
    required this.contentType,
    required this.name,
    required this.about,
    required this.description,
    required this.text,
    required this.url,
    required this.thumbnailUrl,
    required this.grades,
    required this.subjectAreas,
  });

  factory InfoResultModel.fromJson(Map<String, dynamic> json) {
    return InfoResultModel(
      id: json['id'],
      contentType: json['contentType'],
      name: json['name'],
      about: json['about']['nfsSeriesName'],
      description: json['description'],
      text: json['text'] ?? "",
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
      grades: json['grades'].cast<String>(),
      subjectAreas: json['subjectAreas'].cast<String>(),
    );
  }
}
