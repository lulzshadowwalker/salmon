// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
final class Agency {
  final String? id;
  final String? name;
  final String? logo;

  const Agency({
    this.id,
    this.name,
    this.logo,
  });

  Agency copyWith({
    String? id,
    String? name,
    String? logo,
  }) {
    return Agency(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'logo': logo,
    };
  }

  factory Agency.fromMap(Map<String, dynamic> map) {
    return Agency(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      logo: map['logo'] != null ? map['logo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Agency.fromJson(String source) =>
      Agency.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Agency(id: $id, name: $name, logo: $logo)';

  @override
  bool operator ==(covariant Agency other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.logo == logo;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ logo.hashCode;
}
