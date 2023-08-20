// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import './poll_option.dart';

@immutable
class Poll {
  final String? id;
  final String? enTitle;
  final String? arTitle;
  final List<PollOption>? options;
  final String? createdBy;
  final int? totalInteractions;

  const Poll({
    this.id,
    this.enTitle,
    this.arTitle,
    this.options,
    this.createdBy,
    this.totalInteractions,
  });

  Poll copyWith({
    String? id,
    String? enTitle,
    String? arTitle,
    List<PollOption>? options,
    String? createdBy,
    int? totalInteractions,
  }) {
    return Poll(
      id: id ?? this.id,
      enTitle: enTitle ?? this.enTitle,
      arTitle: arTitle ?? this.arTitle,
      options: options ?? this.options,
      createdBy: createdBy ?? this.createdBy,
      totalInteractions: totalInteractions ?? this.totalInteractions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'enTitle': enTitle,
      'arTitle': arTitle,
      'options': options?.map((x) => x.toMap()).toList(),
      'createdBy': createdBy,
      'totalInteractions': totalInteractions,
    };
  }

  factory Poll.fromMap(Map<String, dynamic> map) {
    return Poll(
      id: map['id'] != null ? map['id'] as String : null,
      enTitle: map['enTitle'] != null ? map['enTitle'] as String : null,
      arTitle: map['arTitle'] != null ? map['arTitle'] as String : null,
      options: map['options'] != null
          ? List<PollOption>.from(
              (map['options']).map(
                (x) => PollOption.fromMap(x),
              ),
            )
          : null,
      createdBy: map['createdBy'] != null ? map['createdBy'] as String : null,
      totalInteractions: map['totalInteractions'] != null
          ? map['totalInteractions'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Poll.fromJson(String source) =>
      Poll.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Poll(id: $id, enTitle: $enTitle, arTitle: $arTitle, options: $options, createdBy: $createdBy, totalInteractions: $totalInteractions)';
  }

  @override
  bool operator ==(covariant Poll other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.enTitle == enTitle &&
        other.arTitle == arTitle &&
        listEquals(other.options, options) &&
        other.createdBy == createdBy &&
        other.totalInteractions == totalInteractions;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        enTitle.hashCode ^
        arTitle.hashCode ^
        options.hashCode ^
        createdBy.hashCode ^
        totalInteractions.hashCode;
  }
}
