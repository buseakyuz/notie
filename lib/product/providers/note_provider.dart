import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> allNotes = [];

  void addNote(Note note) async {
    allNotes.add(note);
    var sharedPreferences = await SharedPreferences.getInstance();
    var newData = allNotes.map((e) => e.toJson()).toList();
    sharedPreferences.setString("notes", newData.toString());
    notifyListeners();
  }

  void fetchNotes() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var comingNotes = sharedPreferences.getString("notes");
    if (comingNotes != null) {
      var currentList = json.decode(comingNotes) as List;
      var newList = currentList.map((e) => Note.fromMap(e)).toList();
      allNotes.addAll(newList);
      notifyListeners();
      print('Notlar Çekildi');
    }
  }
}
