import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:notie/feature/global/create_note_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../product/models/note.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  bool isClosedTitle = false;
  bool lastClosedTitle = false;
  double lastOffset = 0;

  List<Color> notePageColors = [
    Colors.black.withOpacity(0.5),
    Colors.pink,
    Colors.purple,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.teal,
    Colors.red,
    Colors.cyan,
    Colors.brown,
  ];

  List<Note> allNotes = [];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _fetchNotes();
    _scrollController.addListener(() {
      if (_scrollController.offset <= 0) {
        isClosedTitle = false;
      } else if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        isClosedTitle = true;
      } else {
        isClosedTitle = _scrollController.offset > lastOffset ? true : false;
      }

      if (lastClosedTitle != isClosedTitle) {
        setState(() {});
      }
      lastOffset = _scrollController.offset;

      lastClosedTitle = isClosedTitle;
      if (_scrollController.offset <= 0) {
        isClosedTitle = false;
      } else if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        isClosedTitle = true;
      } else {
        isClosedTitle = _scrollController.offset > lastOffset ? true : false;
      }

      if (lastClosedTitle != isClosedTitle) {
        setState(() {});
      }
      lastOffset = _scrollController.offset;

      lastClosedTitle = isClosedTitle;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      bottomNavigationBar: _bottomAppBar,
      floatingActionButton: _fabButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Color.fromARGB(255, 240, 230, 239),
      body: rootPage(),
    );
  }

  Column rootPage() {
    return Column(
      children: [
        SizedBox(height: 16.0),
        _tabBarContainer(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              notesPage(),
              foldersPage(),
            ],
          ),
        ),
      ],
    );
  }

  Container foldersPage() {
    return Container();
  }

  Expanded notesPage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: allNotes.length,
          itemBuilder: (context, index) {
            var currentNote = allNotes[index];
            return singleNote(
                date:
                    "${currentNote.date.day}/${currentNote.date.month}/${currentNote.date.year}",
                title: currentNote.title,
                content: currentNote.content,
                colorIndex: currentNote.colorIndex);
          },
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.8,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8),
        ),
      ),
    );
  }

  Card singleNote(
      {required String date,
      required String title,
      required String content,
      required int colorIndex}) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(45))),
      child: Container(
        decoration: BoxDecoration(
          color: notePageColors[colorIndex],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                content,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer _tabBarContainer() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isClosedTitle ? 0 : null,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 156, 137, 184),
          borderRadius: BorderRadius.circular(40)),
      child: DefaultTabController(
        length: 2,
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(horizontal: 32),
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.pinkAccent.withOpacity(0.8)),
          tabs: [
            Tab(
                child: Text("All Notes",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600))),
            Tab(
                child: Text("Folders",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)))
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
        elevation: 4.0,
        leading: Icon(Icons.note),
        backgroundColor: Color.fromARGB(255, 156, 137, 184),
        title: Text("Notie"));
  }

  Widget get _fabButton => FloatingActionButton(
      mini: false,
      backgroundColor: Color.fromARGB(255, 156, 137, 184),
      onPressed: () async {
        var result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreateNoteView()));
        if (result != null) {
          setState(() {
            allNotes.add(result);
          });
          var sharedPreferences = await SharedPreferences.getInstance();
          var newData = allNotes.map((e) => e.toJson()).toList();
          sharedPreferences.setString("notes", newData.toString());
        }
      },
      child: Icon(Icons.add));

  Widget get _bottomAppBar => BottomAppBar(
        notchMargin: 5.0,
        shape: CircularNotchedRectangle(),
        color: Color.fromARGB(255, 156, 137, 184),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.home), color: Colors.white),
          IconButton(
              onPressed: () {}, icon: Icon(Icons.search), color: Colors.white)
        ]),
      );

  void _fetchNotes() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var comingNotes = sharedPreferences.getString("notes");
    // await sharedPreferences.clear();
    if (comingNotes != null) {
      var currentList = json.decode(comingNotes) as List;
      var newList = currentList.map((e) => Note.fromMap(e)).toList();

      setState(() {
        allNotes.addAll(newList);
      });
    }
  }
}
