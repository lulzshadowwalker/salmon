// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:salmon/models/location.dart';

@immutable
final class Post {
  final String? id;
  final String? title;
  final String? tag;
  final String? lightBody;
  final String? darkBody;
  final String? coverImage;
  final String? createdBy;
  final Location? location;
  final String? urlAction;

  const Post({
    this.id,
    this.title,
    this.tag,
    this.lightBody,
    this.darkBody,
    this.coverImage,
    this.createdBy,
    this.location,
    this.urlAction,
  });

  Post copyWith({
    String? id,
    String? title,
    String? tag,
    String? lightBody,
    String? darkBody,
    String? coverImage,
    String? createdBy,
    Location? location,
    String? urlAction,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      lightBody: lightBody ?? this.lightBody,
      darkBody: darkBody ?? this.darkBody,
      coverImage: coverImage ?? this.coverImage,
      createdBy: createdBy ?? this.createdBy,
      location: location ?? this.location,
      urlAction: urlAction ?? this.urlAction,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'tag': tag,
      'light_body': lightBody,
      'dark_body': darkBody,
      'cover_image': coverImage,
      'created_by': createdBy,
      'location': location?.toMap(),
      'url_action': urlAction,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      tag: map['tag'] != null ? map['tag'] as String : null,
      lightBody: map['light_body'] != null ? map['light_body'] as String : null,
      darkBody: map['dark_body'] != null ? map['dark_body'] as String : null,
      coverImage:
          map['cover_image'] != null ? map['cover_image'] as String : null,
      createdBy: map['created_by'] != null ? map['created_by'] as String : null,
      location: map['location'] != null
          ? Location.fromMap(map['location'] as Map<String, dynamic>)
          : null,
      urlAction: map['url_action'] != null ? map['url_action'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(id: $id, title: $title, tag: $tag, lightBody: $lightBody, darkBody: $darkBody, coverImage: $coverImage, createdBy: $createdBy, location: $location, urlAction: $urlAction)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.tag == tag &&
        other.lightBody == lightBody &&
        other.darkBody == darkBody &&
        other.coverImage == coverImage &&
        other.createdBy == createdBy &&
        other.location == location &&
        other.urlAction == urlAction;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        tag.hashCode ^
        lightBody.hashCode ^
        darkBody.hashCode ^
        coverImage.hashCode ^
        createdBy.hashCode ^
        location.hashCode ^
        urlAction.hashCode;
  }
}
