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
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      noOfTours: json['no_of_tours'],
      rating: json['rating'],
      preViewImg: json['preViewImg'],
      description: json['description'],
      type: json['type'],
      subtype: json['subtype'],
      price: json['price'],
      eventDate: json['event_date'] != null
          ? DateTime.parse(json['event_date'])
          : null,
      createdBy: json['created_by'],
      createdDate: json['created_date'] != null
          ? DateTime.parse(json['created_date'])
          : null,
      lastModifiedBy: json['last_modified_by'],
      lastModifiedDate: json['last_modified_date'] != null
          ? DateTime.parse(json['last_modified_date'])
          : null,
      companyId: json['company_id'],
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
      };
}
