import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String note;
  Timestamp createdOn;
  Timestamp updatedOn;
  String createdBy;

  Note({
    required this.note,
    required this.createdOn,
    required this.updatedOn,
    required this.createdBy,
  });

  Note.fromJson(Map<String, dynamic> json)
      : this(
          note: json['note'] as String,
          createdOn: json['createdOn'] as Timestamp,
          updatedOn: json['updatedOn'] as Timestamp,
          createdBy: json['createdBy'] as String,
        );

  Note copyWith({
    String? note,
    Timestamp? createdOn,
    Timestamp? updatedOn,
    String? createdBy,
  }) {
    return Note(
      note: note ?? this.note,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  Map<String, Object> toJson() {
    return {
      'note': note,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'createdBy': createdBy,
    };
  }
}
