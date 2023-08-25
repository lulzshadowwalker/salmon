// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:salmon/models/location.dart';

@immutable
final class Event {
  final String? id;
  final String? enTitle;
  final String? arTitle;
  final String? enSummary;
  final String? arSummary;
  final String? enBody;
  final String? arBody;
  final String? enLocationTitle;
  final String? arLocationTitle;
  final Location? location;
  final DateTime? date;
  final String? createdBy;
  final String? coverImage;

  const Event({
    this.id,
    this.enTitle,
    this.arTitle,
    this.enSummary,
    this.arSummary,
    this.enBody,
    this.arBody,
    this.enLocationTitle,
    this.arLocationTitle,
    this.location,
    this.date,
    this.createdBy,
    this.coverImage,
  });

  Event copyWith({
    String? id,
    String? enTitle,
    String? arTitle,
    String? enSummary,
    String? arSummary,
    String? enBody,
    String? arBody,
    String? enLocationTitle,
    String? arLocationTitle,
    Location? location,
    DateTime? date,
    String? createdBy,
    String? coverImage,
  }) {
    return Event(
      id: id ?? this.id,
      enTitle: enTitle ?? this.enTitle,
      arTitle: arTitle ?? this.arTitle,
      enSummary: enSummary ?? this.enSummary,
      arSummary: arSummary ?? this.arSummary,
      enBody: enBody ?? this.enBody,
      arBody: arBody ?? this.arBody,
      enLocationTitle: enLocationTitle ?? this.enLocationTitle,
      arLocationTitle: arLocationTitle ?? this.arLocationTitle,
      location: location ?? this.location,
      date: date ?? this.date,
      createdBy: createdBy ?? this.createdBy,
      coverImage: coverImage ?? this.coverImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'enTitle': enTitle,
      'arTitle': arTitle,
      'enSummary': enSummary,
      'arSummary': arSummary,
      'enBody': enBody,
      'arBody': arBody,
      'enLocationTitle': enLocationTitle,
      'arLocationTitle': arLocationTitle,
      'location': location?.toMap(),
      'date': date?.millisecondsSinceEpoch,
      'createdBy': createdBy,
      'coverImage': coverImage,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] != null ? map['id'] as String : null,
      enTitle: map['enTitle'] != null ? map['enTitle'] as String : null,
      arTitle: map['arTitle'] != null ? map['arTitle'] as String : null,
      enSummary: map['enSummary'] != null ? map['enSummary'] as String : null,
      arSummary: map['arSummary'] != null ? map['arSummary'] as String : null,
      enBody: map['enBody'] != null ? map['enBody'] as String : null,
      arBody: map['arBody'] != null ? map['arBody'] as String : null,
      enLocationTitle: map['enLocationTitle'] != null
          ? map['enLocationTitle'] as String
          : null,
      arLocationTitle: map['arLocationTitle'] != null
          ? map['arLocationTitle'] as String
          : null,
      location: map['location'] != null
          ? Location.fromMap(map['location'] as Map<String, dynamic>)
          : null,
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int)
          : null,
      createdBy: map['createdBy'] != null ? map['createdBy'] as String : null,
      coverImage:
          map['coverImage'] != null ? map['coverImage'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) =>
      Event.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Event(id: $id, enTitle: $enTitle, arTitle: $arTitle, enSummary: $enSummary, arSummary: $arSummary, enBody: $enBody, arBody: $arBody, enLocationTitle: $enLocationTitle, arLocationTitle: $arLocationTitle, location: $location, date: $date, createdBy: $createdBy, coverImage: $coverImage)';
  }

  @override
  bool operator ==(covariant Event other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.enTitle == enTitle &&
        other.arTitle == arTitle &&
        other.enSummary == enSummary &&
        other.arSummary == arSummary &&
        other.enBody == enBody &&
        other.arBody == arBody &&
        other.enLocationTitle == enLocationTitle &&
        other.arLocationTitle == arLocationTitle &&
        other.location == location &&
        other.date == date &&
        other.createdBy == createdBy &&
        other.coverImage == coverImage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        enTitle.hashCode ^
        arTitle.hashCode ^
        enSummary.hashCode ^
        arSummary.hashCode ^
        enBody.hashCode ^
        arBody.hashCode ^
        enLocationTitle.hashCode ^
        arLocationTitle.hashCode ^
        location.hashCode ^
        date.hashCode ^
        createdBy.hashCode ^
        coverImage.hashCode;
  }
}
