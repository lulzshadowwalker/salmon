// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:salmon/helpers/salmon_const.dart';

@immutable
class SalmonUser {
  /// defaults to [username]
  final String? displayName;
  final String? id;
  final String? email;
  final String? password;
  final String? pfp;

  const SalmonUser({
    this.displayName,
    this.email,
    this.password,
    this.pfp,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'display_name': displayName,
      'email': email,
      'pfp': pfp,
      'id': id,
    };
  }

  SalmonUser.fromMap(Map<String, dynamic> map)
      : displayName = map['display_name'],
        email = map['email'],
        pfp = map['pfp'],
        id = map['id'],
        password = map['password'];

  SalmonUser.fromGoogleAuth(Map<String, dynamic> profile)
      : email = profile[SalmonConst.gEmail],
        displayName = profile[SalmonConst.gName],
        pfp = profile[SalmonConst.gProfilePicture],
        id = profile[SalmonConst.gUserId],
        password = null;

  String toJson() => json.encode(toMap());

  factory SalmonUser.fromJson(String source) =>
      SalmonUser.fromMap(json.decode(source) as Map<String, dynamic>);

  SalmonUser copyWith({
    String? displayName,
    String? id,
    String? username,
    String? email,
    String? password,
    Uint8List? pfpRaw,
    String? pfpUrl,
  }) {
    return SalmonUser(
      displayName: displayName ?? this.displayName,
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      pfp: pfpUrl ?? pfp,
    );
  }

  @override
  String toString() {
    return 'SalmonUserCredentials(displayName: $displayName, id: $id, email: $email, password: $password, pfpUrl: $pfp)';
  }

  @override
  bool operator ==(covariant SalmonUser other) {
    if (identical(this, other)) return true;

    return other.displayName == displayName &&
        other.id == id &&
        other.email == email &&
        other.password == password &&
        other.pfp == pfp;
  }

  @override
  int get hashCode {
    return displayName.hashCode ^
        id.hashCode ^
        email.hashCode ^
        password.hashCode ^
        pfp.hashCode;
  }
}
