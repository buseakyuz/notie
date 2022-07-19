import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:notie/product/models/note.dart';
import 'package:provider/provider.dart';

import '../../product/providers/note_provider.dart';

class CreateNoteView extends StatefulWidget {
  const CreateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateNoteView> createState() => CreateNoteViewState();
}

class CreateNoteViewState extends State<CreateNoteView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Ionicons.checkmark_circle),
            onPressed: saveNote,
          )
        ],
        title: Text("Not Oluştur"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Başlık",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24.0,
                    color: Colors.black.withOpacity(0.2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(
                thickness: 2.0,
                height: 2.0,
              ),
            ),
            TextField(
              controller: noteController,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.black.withOpacity(0.7),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Not",
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.black.withOpacity(0.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveNote() {
    if (titleController.text.isNotEmpty || noteController.text.isNotEmpty) {
      var random = Random();
      var newNote = Note(titleController.text, noteController.text,
          DateTime.now(), random.nextInt(9));
      // print("${titleController.text} ${noteController.text} ");
      context.read<NoteProvider>().addNote(newNote);
      Navigator.pop(context);
    }
  }
}
