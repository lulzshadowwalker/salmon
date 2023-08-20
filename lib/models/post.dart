// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:salmon/models/location.dart';

@immutable
final class Post {
  final String? id;
  final String? enTitle;
  final String? arTitle;
  final String? arBody;
  final String? enBody;
  final String? coverImage;
  final String? createdBy;
  final Location? location;
  final String? urlAction;
  final int? clapCount;
  final List? claps;
  final DateTime? dateCreated;

  const Post(
      {this.id,
      this.enTitle,
      this.arTitle,
      this.arBody,
      this.enBody,
      this.coverImage,
      this.createdBy,
      this.location,
      this.urlAction,
      this.clapCount,
      this.claps,
      this.dateCreated});

  Post copyWith({
    String? id,
    String? enTitle,
    String? arTitle,
    String? arBody,
    String? enBody,
    String? coverImage,
    String? createdBy,
    Location? location,
    String? urlAction,
    int? clapCount,
    List? claps,
    DateTime? dateCreated,
  }) {
    return Post(
      id: id ?? this.id,
      enTitle: enTitle ?? this.enTitle,
      arTitle: arTitle ?? this.arTitle,
      arBody: arBody ?? this.arBody,
      enBody: enBody ?? this.enBody,
      coverImage: coverImage ?? this.coverImage,
      createdBy: createdBy ?? this.createdBy,
      location: location ?? this.location,
      urlAction: urlAction ?? this.urlAction,
      clapCount: clapCount ?? this.clapCount,
      claps: claps ?? this.claps,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'en_title': enTitle,
      'ar_title': arTitle,
      'ar_body': arBody,
      'en_body': enBody,
      'cover_image': coverImage,
      'created_by': createdBy,
      'location': location?.toMap(),
      'url_action': urlAction,
      'clap_count': clapCount,
      'claps': claps,
      'date_created': dateCreated,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] != null ? map['id'] as String : null,
      enTitle: map['en_title'] != null ? map['en_title'] as String : null,
      arTitle: map['ar_title'] != null ? map['ar_title'] as String : null,
      arBody: map['ar_body'] != null ? map['ar_body'] as String : null,
      enBody: map['en_body'] != null ? map['en_body'] as String : null,
      coverImage:
          map['cover_image'] != null ? map['cover_image'] as String : null,
      createdBy: map['created_by'] != null ? map['created_by'] as String : null,
      location: map['location'] != null
          ? Location.fromMap(map['location'] as Map<String, dynamic>)
          : null,
      urlAction: map['url_action'] != null ? map['url_action'] as String : null,
      clapCount: map['clap_count'] != null ? map['clap_count'] as int : null,
      claps: map['claps'],
      dateCreated: map['date_created'] != null
          ? (map['date_created'] as Timestamp).toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(id: $id, enTitle: $enTitle, arTitle: $arTitle, arBody: $arBody, enBody: $enBody, coverImage: $coverImage, createdBy: $createdBy, location: $location, urlAction: $urlAction, clapCount: $clapCount, claps: $claps, date_created: $dateCreated)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.enTitle == enTitle &&
        other.arTitle == arTitle &&
        other.arBody == arBody &&
        other.enBody == enBody &&
        other.coverImage == coverImage &&
        other.createdBy == createdBy &&
        other.location == location &&
        other.urlAction == urlAction &&
        other.clapCount == clapCount &&
        other.dateCreated == dateCreated &&
        other.claps == claps;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        enTitle.hashCode ^
        arTitle.hashCode ^
        arBody.hashCode ^
        enBody.hashCode ^
        coverImage.hashCode ^
        createdBy.hashCode ^
        location.hashCode ^
        urlAction.hashCode ^
        clapCount.hashCode ^
        dateCreated.hashCode ^
        claps.hashCode;
  }
}
