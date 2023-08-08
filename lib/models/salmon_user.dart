// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
final class SalmonUser {
  /// defaults to [username]
  final String? displayName;
  final String? id;
  final String? email;
  final String? password;
  final String? pfp;
  final List? topics;

  const SalmonUser({
    this.displayName,
    this.id,
    this.email,
    this.password,
    this.pfp,
    this.topics,
  });

  SalmonUser copyWith({
    String? displayName,
    String? id,
    String? email,
    String? password,
    String? pfp,
    List? topics,
  }) {
    return SalmonUser(
      displayName: displayName ?? this.displayName,
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      pfp: pfp ?? this.pfp,
      topics: topics ?? this.topics,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'display_name': displayName,
      'id': id,
      'email': email,
      'password': password,
      'pfp_url': pfp,
      'topics': topics,
    };
  }

  factory SalmonUser.fromMap(Map<String, dynamic> map) {
    return SalmonUser(
      displayName:
          map['display_name'] != null ? map['display_name'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      pfp: map['pfp_url'] != null ? map['pfp_url'] as String : null,
      topics: map['topics'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SalmonUser.fromJson(String source) =>
      SalmonUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SalmonUser(displayName: $displayName, id: $id, email: $email, password: $password, pfp: $pfp, topics: $topics)';
  }

  @override
  bool operator ==(covariant SalmonUser other) {
    if (identical(this, other)) return true;

    return other.displayName == displayName &&
        other.id == id &&
        other.email == email &&
        other.password == password &&
        other.pfp == pfp &&
        other.topics == topics;
  }

  @override
  int get hashCode {
    return displayName.hashCode ^
        id.hashCode ^
        email.hashCode ^
        password.hashCode ^
        pfp.hashCode ^
        topics.hashCode;
  }
}
