// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
final class PollOption {
  final String? id;
  final String? enTitle;
  final String? arTitle;
  final int? interactionCount;

  const PollOption({
    this.id,
    this.enTitle,
    this.arTitle,
    this.interactionCount,
  });

  PollOption copyWith({
    String? id,
    String? enTitle,
    String? arTitle,
    int? interactionCount,
  }) {
    return PollOption(
      id: id ?? this.id,
      enTitle: enTitle ?? this.enTitle,
      arTitle: arTitle ?? this.arTitle,
      interactionCount: interactionCount ?? this.interactionCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'enTitle': enTitle,
      'arTitle': arTitle,
      'interactionCount': interactionCount,
    };
  }

  factory PollOption.fromMap(Map<String, dynamic> map) {
    return PollOption(
      id: map['id'] != null ? map['id'] as String : null,
      enTitle: map['enTitle'] != null ? map['enTitle'] as String : null,
      arTitle: map['arTitle'] != null ? map['arTitle'] as String : null,
      interactionCount: map['interactionCount'] != null
          ? map['interactionCount'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PollOption.fromJson(String source) =>
      PollOption.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'id: $id, PollOption(enTitle: $enTitle, arTitle: $arTitle, interactionCount: $interactionCount)';

  @override
  bool operator ==(covariant PollOption other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.enTitle == enTitle &&
        other.arTitle == arTitle &&
        other.interactionCount == interactionCount;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      enTitle.hashCode ^
      arTitle.hashCode ^
      interactionCount.hashCode;
}
