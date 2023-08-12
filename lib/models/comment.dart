// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
final class Comment {
  final String? id;
  final String? postId;
  final String? userId;
  final String? comment;
  final DateTime? createdOn;

  const Comment({
    this.id,
    this.postId,
    this.userId,
    this.comment,
    this.createdOn,
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? comment,
    DateTime? createdOn,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      comment: comment ?? this.comment,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'comment': comment,
      'created_on': createdOn?.millisecondsSinceEpoch,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] != null ? map['id'] as String : null,
      postId: map['post_id'] != null ? map['post_id'] as String : null,
      userId: map['user_id'] != null ? map['user_id'] as String : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      createdOn: map['created_on'] != null
          ? (map['created_on'] as Timestamp).toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postId, userId: $userId, comment: $comment, createdOn: $createdOn)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.postId == postId &&
        other.userId == userId &&
        other.comment == comment &&
        other.createdOn == createdOn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postId.hashCode ^
        userId.hashCode ^
        comment.hashCode ^
        createdOn.hashCode;
  }
}
