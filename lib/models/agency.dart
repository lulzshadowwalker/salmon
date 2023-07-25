// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
final class Agency implements Comparable<Agency> {
  final String? id;
  final String? enName;
  final String? arName;
  final String? logo;

  const Agency({
    this.id,
    this.enName,
    this.arName,
    this.logo,
  });

  Agency copyWith({
    String? id,
    String? enName,
    String? arName,
    String? logo,
  }) {
    return Agency(
      id: id ?? this.id,
      enName: enName ?? this.enName,
      arName: arName ?? this.arName,
      logo: logo ?? this.logo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'en_name': enName,
      'ar_name': arName,
      'logo': logo,
    };
  }

  factory Agency.fromMap(Map<String, dynamic> map) {
    return Agency(
      id: map['id'] != null ? map['id'] as String : null,
      enName: map['en_name'] != null ? map['en_name'] as String : null,
      arName: map['ar_name'] != null ? map['ar_name'] as String : null,
      logo: map['logo'] != null ? map['logo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Agency.fromJson(String source) =>
      Agency.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Agency(id: $id, enName: $enName, arName: $arName, logo: $logo)';
  }

  @override
  bool operator ==(covariant Agency other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.enName == enName &&
        other.arName == arName &&
        other.logo == logo;
  }

  bool containsSearchQuery(String query) {
    if (query.isEmpty) return true;

    final lowerCaseQuery = query.toLowerCase();
    return (enName?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
        (arName?.toLowerCase().contains(lowerCaseQuery) ?? false);
  }

  @override
  int get hashCode {
    return id.hashCode ^ enName.hashCode ^ arName.hashCode ^ logo.hashCode;
  }

  @override
  int compareTo(Agency other) {
    if (containsSearchQuery(other.enName ?? '') ||
        containsSearchQuery(other.arName ?? '')) {
      return 0;
    } else {
      return -1;
    }
  }
}
