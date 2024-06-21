import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/models/note.dart';

const String notesCollectionReference = "notess";

class DatabaseServices {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _noteCollectionRef;

  DatabaseServices() {
    _noteCollectionRef =
        _firestore.collection(notesCollectionReference).withConverter<Note>(
              fromFirestore: (snapshots, _) => Note.fromJson(
                snapshots.data()!,
              ),
              toFirestore: (note, _) => note.toJson(),
            );
  }

  Stream<QuerySnapshot> getNotes() {
    return _noteCollectionRef.snapshots();
  }

  void addNotes(Note note) async {
    _noteCollectionRef.add(note);
    log(_noteCollectionRef.path);
  }

  void updateNotes(String noteId, Note note) async {
    _noteCollectionRef.doc(noteId).update(note.toJson());
  }

  void deleteNotes(String noteId, Note note) async {
    _noteCollectionRef.doc(noteId).delete();
  }
}
