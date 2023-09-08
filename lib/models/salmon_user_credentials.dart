// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:salmon/helpers/salmon_const.dart';
import 'package:salmon/models/salmon_user.dart';

@immutable
class SalmonUserCredentials {
  /// defaults to [username]
  final String? displayName;
  final String? id;
  final String? email;
  final String? password;
  final XFile? pfpRaw;
  final String? pfpUrl;

  const SalmonUserCredentials({
    this.displayName,
    this.email,
    this.password,
    this.pfpRaw,
    this.pfpUrl,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'display_name': displayName,
      'email': email,
      'pfp_raw': pfpRaw,
      'pfp_url': pfpUrl,
      'id': id,
    };
  }

  SalmonUserCredentials.fromMap(Map<String, dynamic> map)
      : displayName = map['display_name'],
        email = map['email'],
        pfpUrl = map['pfp_url'],
        id = map['id'],
        password = map['password'],
        pfpRaw = map['pfp_raw'];

  SalmonUserCredentials.fromSalmonUser(SalmonUser? user)
      : displayName = user?.displayName,
        email = user?.email,
        pfpUrl = user?.pfp,
        id = user?.id,
        password = null,
        pfpRaw = null;

  SalmonUserCredentials.fromGoogleAuth(Map<String, dynamic> profile)
      : email = profile[SalmonConst.gEmail],
        displayName = profile[SalmonConst.gName],
        pfpUrl = profile[SalmonConst.gProfilePicture],
        id = profile[SalmonConst.gUserId],
        password = null,
        pfpRaw = null;

  String toJson() => json.encode(toMap());

  factory SalmonUserCredentials.fromJson(String source) =>
      SalmonUserCredentials.fromMap(
          json.decode(source) as Map<String, dynamic>);

  SalmonUserCredentials copyWith({
    String? displayName,
    String? id,
    String? username,
    String? email,
    String? password,
    XFile? pfpRaw,
    String? pfpUrl,
  }) {
    return SalmonUserCredentials(
      displayName: displayName ?? this.displayName,
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      pfpRaw: pfpRaw ?? this.pfpRaw,
      pfpUrl: pfpUrl ?? this.pfpUrl,
    );
  }

  @override
  String toString() {
    return 'SalmonUserCredentials(displayName: $displayName, id: $id, email: $email, password: $password, pfpRaw: $pfpRaw, pfpUrl: $pfpUrl)';
  }

  @override
  bool operator ==(covariant SalmonUserCredentials other) {
    if (identical(this, other)) return true;

    return other.displayName == displayName &&
        other.id == id &&
        other.email == email &&
        other.password == password &&
        other.pfpRaw == pfpRaw &&
        other.pfpUrl == pfpUrl;
  }

  @override
  int get hashCode {
    return displayName.hashCode ^
        id.hashCode ^
        email.hashCode ^
        password.hashCode ^
        pfpRaw.hashCode ^
        pfpUrl.hashCode;
  }
}
