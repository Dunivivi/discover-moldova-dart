class User {
  int id;
  String login;
  String firstName;
  String lastName;
  String email;
  String company;
  String createdBy;
  DateTime createdDate;
  String lastModifiedBy;
  DateTime lastModifiedDate;
  List<String> authorities;

  User({
    this.id,
    this.login,
    this.firstName,
    this.lastName,
    this.email,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
    this.authorities,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      login: json['login'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      company: json['company'],
      email: json['email'],
      createdBy: json['createdBy'],
      // You can parse date strings to DateTime objects if needed
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      lastModifiedBy: json['lastModifiedBy'],
      lastModifiedDate: json['lastModifiedDate'] != null
          ? DateTime.parse(json['lastModifiedDate'])
          : null,
      authorities: List<String>.from(json['authorities']),
    );
  }
}
