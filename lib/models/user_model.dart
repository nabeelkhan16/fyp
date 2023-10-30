// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? name;
  String? email;
  String? uId;
  String? image;
  String? phoneNo;
  String? city;
  String? area;
  bool isCollector;
  UserModel({
    this.name,
    this.email,
  
    this.uId,
    this.image,
    this.phoneNo,
    this.city,
    this.area,
    this.isCollector = false,
  });

   

  UserModel copyWith({
    String? name,
    String? email,
    String? uId,
    String? image,
    String? phoneNo,
    String? city,
    String? area,
    bool? isCollector,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      uId: uId ?? this.uId,
      image: image ?? this.image,
      phoneNo: phoneNo ?? this.phoneNo,
      city: city ?? this.city,
      area: area ?? this.area,
      isCollector: isCollector ?? this.isCollector,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'uId': uId,
      'image': image,
      'phoneNo': phoneNo,
      'city': city,
      'area': area,
      'isCollector': isCollector,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      uId: map['uId'] != null ? map['uId'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      area: map['area'] != null ? map['area'] as String : null,
      isCollector: map['isCollector'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, uId: $uId, image: $image, phoneNo: $phoneNo, city: $city, area: $area, isCollector: $isCollector)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.email == email &&
      other.uId == uId &&
      other.image == image &&
      other.phoneNo == phoneNo &&
      other.city == city &&
      other.area == area &&
      other.isCollector == isCollector;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      email.hashCode ^
      uId.hashCode ^
      image.hashCode ^
      phoneNo.hashCode ^
      city.hashCode ^
      area.hashCode ^
      isCollector.hashCode;
  }
}
