// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
final class Attachment {
  final String? name;
  final String? mimeType;
  final String? url;
  
  const Attachment({
    this.name,
    this.mimeType,
    this.url,
  });

  Attachment copyWith({
    String? name,
    String? mimeType,
    String? url,
  }) {
    return Attachment(
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'mime_type': mimeType,
      'url': url,
    };
  }

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      name: map['name'] != null ? map['name'] as String : null,
      mimeType: map['mime_type'] != null ? map['mime_type'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Attachment.fromJson(String source) => Attachment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Attatchment(name: $name, mimeType: $mimeType, url: $url)';

  @override
  bool operator ==(covariant Attachment other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.mimeType == mimeType &&
      other.url == url;
  }

  @override
  int get hashCode => name.hashCode ^ mimeType.hashCode ^ url.hashCode;
}
