// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
final class PollVote {
  final String? id;
  final String? userId;
  final String? optionId;

  const PollVote({
    this.id,
    this.userId,
    this.optionId,
  });

  PollVote copyWith({
    String? id,
    String? userId,
    String? optionId,
  }) {
    return PollVote(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      optionId: optionId ?? this.optionId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'optionId': optionId,
    };
  }

  factory PollVote.fromMap(Map<String, dynamic> map) {
    return PollVote(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      optionId: map['optionId'] != null ? map['optionId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PollVote.fromJson(String source) =>
      PollVote.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'id: $id, PollOption(userId: $userId, optionId: $optionId)';

  @override
  bool operator ==(covariant PollVote other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.optionId == optionId;
  }

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ optionId.hashCode;
}
