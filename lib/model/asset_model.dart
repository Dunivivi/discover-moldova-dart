class AssetModel {
  final int id;
  final String url;

  AssetModel({this.id, this.url});

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'],
      url: json['url'],
    );
  }
}