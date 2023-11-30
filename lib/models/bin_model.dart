// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BinModel {
  String id;
  String? name;
  String? description;
  String? address;
  GeoPoint? location;
  String? image;
  String? status;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  String? assingedTo;
  String? assignedToName;
  BinModel({
    required this.id,
    this.name,
    this.description,
    this.address,
    this.location,
    this.image,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.assingedTo,
    this.assignedToName,
  });

  BinModel copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    GeoPoint? location,
    String? image,
    String? status,
    String? createdBy,
    String? createdAt,
    String? updatedBy,
    String? updatedAt,
    String? assingedTo,
    String? assignedToName,
  }) {
    return BinModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      location: location ?? this.location,
      image: image ?? this.image,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      assingedTo: assingedTo ?? this.assingedTo,
      assignedToName: assignedToName ?? this.assignedToName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'location': location,
      'image': image,
      'status': status,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'assingedTo': assingedTo,
      'assignedToName': assignedToName,
    };
  }

  factory BinModel.fromMap(Map<String, dynamic> map) {
    return BinModel(
      id: map['id'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      location: map['location'] != null ? map['location'] as GeoPoint : null,
      image: map['image'] != null ? map['image'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      createdBy: map['createdBy'] != null ? map['createdBy'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedBy: map['updatedBy'] != null ? map['updatedBy'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      assingedTo: map['assingedTo'] != null ? map['assingedTo'] as String : null,
      assignedToName: map['assignedToName'] != null ? map['assignedToName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BinModel.fromJson(String source) => BinModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BinModel(id: $id, name: $name, description: $description, address: $address, location: $location, image: $image, status: $status, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt, assingedTo: $assingedTo)';
  }

  @override
  bool operator ==(covariant BinModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.address == address &&
        other.location == location &&
        other.image == image &&
        other.status == status &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.updatedBy == updatedBy &&
        other.updatedAt == updatedAt &&
        other.assingedTo == assingedTo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        address.hashCode ^
        location.hashCode ^
        image.hashCode ^
        status.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedBy.hashCode ^
        updatedAt.hashCode ^
        assingedTo.hashCode;
  }
}
