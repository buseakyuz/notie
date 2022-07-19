import 'package:flutter/material.dart';
import 'package:notie/feature/global/create_note_view.dart';
import 'package:notie/product/providers/note_provider.dart';
import 'package:provider/provider.dart';

import 'feature/home/home_view.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NoteProvider()),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
