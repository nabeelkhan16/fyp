// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum AccountType { collector, user, admin }

class UserModel {
  String? name;
  String? email;
  String? uId;
  String? image;
  String? phoneNo;
  String? city;
  String? area;
  AccountType? accountType;
  bool? isApproved;
  GeoPoint? location;
  List<String>? assignedBins;

  UserModel({
    this.name,
    this.email,
    this.uId,
    this.image,
    this.phoneNo,
    this.city,
    this.area,
    this.location,
    this.isApproved,
    this.accountType,
    this.assignedBins,
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
    bool? isApproved,
    bool? isAdmin,
    AccountType? accountType,
    GeoPoint? location,
    List<String>? assignedBins,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      uId: uId ?? this.uId,
      image: image ?? this.image,
      phoneNo: phoneNo ?? this.phoneNo,
      city: city ?? this.city,
      area: area ?? this.area,
      location: location ?? this.location,
      isApproved: isApproved ?? this.isApproved,
      accountType: accountType ?? this.accountType,
      assignedBins: assignedBins ?? this.assignedBins,
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
      'location': location,
      'isApproved': isApproved,
      'accountType': accountType.toString().split('.').last,
      'assignedBins': assignedBins,
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
      location: map['location'] != null ? map['location'] as GeoPoint : null,
      isApproved: map['isApproved'] != null ? map['isApproved'] as bool : false,
      accountType: map['accountType'] != null
          ? map['accountType'] == 'collector'
              ? AccountType.collector
              : map['accountType'] == 'admin'
                  ? AccountType.admin
                  : AccountType.user
          : AccountType.user,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, uId: $uId, image: $image, phoneNo: $phoneNo, city: $city, area: $area,  isApproved: $isApproved,  accountType: $accountType)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.uId == uId &&
        other.image == image &&
        other.phoneNo == phoneNo &&
        other.city == city &&
        other.area == area &&
        other.location == location &&
        other.isApproved == isApproved &&
        other.accountType == accountType;
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
        isApproved.hashCode ^
        accountType.hashCode;
  }
}
