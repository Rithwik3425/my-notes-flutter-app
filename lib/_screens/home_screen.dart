import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mynotes/_screens/sign_in_screen.dart';
import 'package:mynotes/models/note.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/services/database/database_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseServices _databaseServices = DatabaseServices();
  final TextEditingController _noteController = TextEditingController();
  AuthUser? authuser = FirebaseAuthProvider().currentUser;

  Future<void> _signOutwithGoogle() async {
    try {
      FirebaseAuthProvider().logOut();
      setState(() {
        authuser = null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
        );
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black12,
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.black12,
      title: const Text(
        '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            (authuser?.user?.displayName)?.toUpperCase() ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: _signOutwithGoogle,
        ),
      ],
    );
  }

  Widget _buildUI() {
    return Center(
      child: Column(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _messageListView(),
        ],
      ),
    );
  }

  Widget _messageListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.907,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: _databaseServices.getNotes(),
        builder: (context, snapshot) {
          List notes = snapshot.data?.docs ?? [];
          if (notes.isEmpty) {
            return const Center(
              child: Text('Add your first note'),
            );
          }
          return MasonryGridView.builder(
            itemCount: notes.length,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              Note note = notes[index].data();
              String noteId = notes[index].id;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(30, 255, 255, 255),
                    border: Border.all(
                      color: Colors.grey.shade800,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text(
                          note.note,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () {},
                        onLongPress: () {
                          _databaseServices.deleteNotes(noteId, note);
                        },
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'by: ${note.createdBy}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _displayAddNoteDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: 'Enter your note',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                log(_noteController.text);
                Note note = Note(
                  note: _noteController.text,
                  createdOn: Timestamp.now(),
                  updatedOn: Timestamp.now(),
                  createdBy: authuser?.user?.displayName ?? '',
                );
                _databaseServices.addNotes(note);
                Navigator.pop(context);
                _noteController.clear();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
