import 'package:discounttour/model/asset_model.dart';

class EventModel {
  final int id;
  final String title;
  final int noOfTours;
  final double rating;
  final String preViewImg;
  final String description;
  final String type;
  final String subtype;
  final double price;
  final DateTime eventDate;
  final String createdBy;
  final DateTime createdDate;
  final String lastModifiedBy;
  final DateTime lastModifiedDate;
  final int companyId;
  final bool favorite;
  final List<AssetModel> assets;
  final String lat;
  final String longitudine;
  final String url;
  final String location;
  final String phone;

  EventModel({
    this.id,
    this.title,
    this.noOfTours,
    this.rating,
    this.preViewImg,
    this.description,
    this.type,
    this.subtype,
    this.price,
    this.eventDate,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
    this.companyId,
    this.favorite,
    this.assets,
    this.lat,
    this.longitudine,
    this.url,
    this.location,
    this.phone,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> assetsJson = json['assets'] != null
        ? List<Map<String, dynamic>>.from(json['assets'])
        : null;

// Mapping 'assetsJson' to List of assets (optional)
    final List<AssetModel> assets =
        assetsJson?.map((assetJson) => AssetModel.fromJson(assetJson)).toList();

    return EventModel(
      id: json['id'],
      title: json['title'],
      noOfTours: json['noOfTours'],
      rating: json['rating'],
      preViewImg: json['preViewImg'],
      description: json['description'],
      type: json['type'],
      subtype: json['subtype'],
      price: json['price'],
      eventDate:
          json['eventDate'] != null ? DateTime.parse(json['eventDate']) : null,
      createdBy: json['createdBy'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      lastModifiedBy: json['lastModifiedBy'],
      lastModifiedDate: json['lastModifiedDate'] != null
          ? DateTime.parse(json['lastModifiedDate'])
          : null,
      companyId: json['companyId'],
      favorite: json['favorite'],
      lat: json['lat'],
      longitudine: json['longitudine'],
      url: json['url'],
      location: json['location'],
      phone: json['phone'],
      assets: assets,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'no_of_tours': noOfTours,
        'rating': rating,
        'preViewImg': preViewImg,
        'description': description,
        'type': type,
        'subtype': subtype,
        'price': price,
        'event_date': eventDate?.toIso8601String(),
        'created_by': createdBy,
        'created_date': createdDate?.toIso8601String(),
        'last_modified_by': lastModifiedBy,
        'last_modified_date': lastModifiedDate?.toIso8601String(),
        'company_id': companyId,
        'favorite': favorite,
        // 'assets': assets,
      };
}
