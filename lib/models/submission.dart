// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'attachment.dart';

@immutable
final class Submission {
  final String? id;
  final String? summary;
  final String? details;
  final String? submittedBy;
  final String? agency;
  final GeoPoint? location;
  final List? attachments;
  final String? status;
  final String? type;

  const Submission({
    this.id,
    this.summary,
    this.details,
    this.submittedBy,
    this.agency,
    this.location,
    this.attachments,
    this.status,
    this.type,
  });

  Submission copyWith({
    String? id,
    String? summary,
    String? details,
    String? submittedBy,
    String? agency,
    GeoPoint? location,
    List? attachments,
    String? status,
    String? type,
  }) {
    return Submission(
      id: id ?? this.id,
      summary: summary ?? this.summary,
      details: details ?? this.details,
      submittedBy: submittedBy ?? this.submittedBy,
      agency: agency ?? this.agency,
      location: location ?? this.location,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'summary': summary,
      'details': details,
      'submitted_by': submittedBy,
      'agency': agency,
      'location': location != null
          ? {
              'latitude': location!.latitude,
              'longitude': location!.longitude,
            }
          : null,
      'attachments': attachments,
      'status': status,
      'type': type,
    };
  }

  factory Submission.fromMap(Map<String, dynamic> map) {
    return Submission(
      id: map['id'] != null ? map['id'] as String : null,
      summary: map['summary'] != null ? map['summary'] as String : null,
      details: map['details'] != null ? map['details'] as String : null,
      submittedBy:
          map['submitted_by'] != null ? map['submitted_by'] as String : null,
      agency: map['agency'] != null ? map['agency'] as String : null,
      location: map['location'] != null
          ? GeoPoint(map['location']['latitude'], map['location']['longitude'])
          : null,
      attachments: map['attachments'] != null
          ? (map['attachments'] as List)
              .map((e) => Attachment.fromMap(e))
              .toList()
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Submission.fromJson(String source) =>
      Submission.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubmissionRaw(id: $id, summary: $summary, details: $details, submittedBy: $submittedBy, agency: $agency, location: $location, attachments: $attachments, status: $status, type: $type)';
  }

  @override
  bool operator ==(covariant Submission other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.summary == summary &&
        other.details == details &&
        other.submittedBy == submittedBy &&
        other.agency == agency &&
        other.location == location &&
        other.attachments == attachments &&
        other.status == status &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        summary.hashCode ^
        details.hashCode ^
        submittedBy.hashCode ^
        agency.hashCode ^
        location.hashCode ^
        attachments.hashCode ^
        status.hashCode ^
        type.hashCode;
  }
}
