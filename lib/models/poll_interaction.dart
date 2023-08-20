import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
final class PollInteraction {
  final String? id;
  final String? pollId;
  final String? userId;
  final int? selectedOption;

  const PollInteraction({
    this.id,
    this.pollId,
    this.userId,
    this.selectedOption,
  });

  PollInteraction copyWith({
    String? id,
    String? pollId,
    String? userId,
    int? selectedOption,
  }) {
    return PollInteraction(
      id: id ?? this.id,
      pollId: pollId ?? this.pollId,
      userId: userId ?? this.userId,
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pollId': pollId,
      'userId': userId,
      'selectedOption': selectedOption,
    };
  }

  factory PollInteraction.fromMap(Map<String, dynamic> map) {
    return PollInteraction(
      id: map['id'] != null ? map['id'] as String : null,
      pollId: map['pollId'] != null ? map['pollId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      selectedOption:
          map['selectedOption'] != null ? map['selectedOption'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PollInteraction.fromJson(String source) =>
      PollInteraction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PollInteraction(id: $id, pollId: $pollId, userId: $userId, selectedOption: $selectedOption)';
  }

  @override
  bool operator ==(covariant PollInteraction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.pollId == pollId &&
        other.userId == userId &&
        other.selectedOption == selectedOption;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        pollId.hashCode ^
        userId.hashCode ^
        selectedOption.hashCode;
  }
}
