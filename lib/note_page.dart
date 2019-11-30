import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'data.dart';

class NoteEditing extends StatefulWidget {
  final bool trueForAdd;
  final int id;

  NoteEditing({Key key, this.id, this.trueForAdd});

  @override
  _NoteEditingState createState() => _NoteEditingState();
}

class _NoteEditingState extends State<NoteEditing> {
  Data d = Data.getInstance();
  bool editing = false;

  String title;
  Color color = Colors.white;
  DateTime created;
  DateTime modified;
  String text;

  @override
  Widget build(BuildContext context) {
    created = created ?? DateTime.now();

    if (!widget.trueForAdd && !editing) {
      this.title = d.getNote(widget.id).title;
      this.color = d.getNote(widget.id).color;
      this.created = d.getNote(widget.id).created;
      this.modified = d.getNote(widget.id).modified;
      this.text = d.getNote(widget.id).text;
    }

    editing = true;

    return WillPopScope(
      onWillPop: () async {
        modified = DateTime.now();

        if ((title != "" && title != null) || (text != "" && text != null)) {
          await d.addOrModifyNote(
            add: widget.trueForAdd,
            id: widget.id,
            title: title,
            color: color,
            created: created,
            modified: modified,
            text: text,
          );
        }

        Navigator.pop(context, true);
        return Future.value(false);
      },

      child: Scaffold(
        appBar: NoteAppBar(),
        backgroundColor: this.color,
        body: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NoteTitle(),
              NoteContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget NoteTitle() => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.75),
    child: TextField(
      controller: TextEditingController(text: this.title),
      decoration: InputDecoration(
        hintText: "Title",
        border: InputBorder.none,
        isDense: true,
        counter: SizedBox(height: 0,),
      ),
      maxLength: 64,
      onChanged: (String s) {this.title = s;},
    ),
  );

  Widget NoteContent() => Expanded(
    child: TextField(
      controller: TextEditingController(text: this.text),
      decoration: InputDecoration(
        hintText: "Note",
        border: InputBorder.none,
        isDense: true,
      ),
      maxLines: null,
      autofocus: true,
      expands: true,
      onChanged: (String s) {this.text = s;},
    ),
  );

  Widget NoteAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black54),

      actions: <Widget>[
        Center(
          child: widget.trueForAdd
          ? null
          : Tooltip(
            message: "Created ${DateFormat('dd MMM yy kk:mm').format(this.created)}\nModified ${DateFormat('dd MMM yy kk:mm').format(this.modified)}",
            child: Text("Modified ${DateFormat('dd MMM yy kk:mm').format(this.modified)}"),
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          tooltip: 'Delete note',
          onPressed: () {
            d.deleteNotes(widget.id);
            Navigator.pop(context, true);
          },
        ),
        IconButton(
          icon: Icon(Icons.settings_backup_restore),
          tooltip: 'Revert changes',
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        IconButton(
          icon: Icon(Icons.color_lens),
          onPressed: () {
            showModalBottomSheet(
              context: this.context,
              builder: (context) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      for (List<Color> colors in colorsList)
                        Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 16, left: 16),
                                child: Text("${colorsName[colorsList.indexOf(colors)]}"),
                              ),
                              Container(
                                height: 80,

                                child: ListView.builder(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: colors.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(left: 8,),
                                      child: FloatingActionButton(
                                        backgroundColor: colors[index],
                                        onPressed: () {
                                          setState(() {
                                            this.color = colors[index];
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }
            );
          },
        ),
      ],
    );
  }

  List<String> colorsName = [
    "Calming Stones",
    "Pinkish Pink",
    "Autumn Grassland",
    "Lush Greenlife",
    "Fine Fine Sand",
    "Deep Ocean",
    "Default"
  ];

  List<List<Color>> colorsList = [
    [
      Color(int.parse("e3e4e6", radix: 16) + 0xFF000000),
      Color(int.parse("d7dce2", radix: 16) + 0xFF000000),
      Color(int.parse("b4b8c1", radix: 16) + 0xFF000000),
      Color(int.parse("eeebe4", radix: 16) + 0xFF000000),
      Color(int.parse("c2a59d", radix: 16) + 0xFF000000),
      Color(int.parse("e0c6b7", radix: 16) + 0xFF000000),
    ],

    [
      Color(int.parse("fbeee6", radix: 16) + 0xFF000000),
      Color(int.parse("ffe5d8", radix: 16) + 0xFF000000),
      Color(int.parse("ffcad4", radix: 16) + 0xFF000000),
      Color(int.parse("f3abb6", radix: 16) + 0xFF000000),
      Color(int.parse("9f8189", radix: 16) + 0xFF000000),
    ],

    [
      Color(int.parse("efe6e1", radix: 16) + 0xFF000000),
      Color(int.parse("eadbd4", radix: 16) + 0xFF000000),
      Color(int.parse("d4c2b8", radix: 16) + 0xFF000000),
      Color(int.parse("e5e5e7", radix: 16) + 0xFF000000),
      Color(int.parse("b4abae", radix: 16) + 0xFF000000),
      Color(int.parse("9f9490", radix: 16) + 0xFF000000),
    ],

    [
      Color(int.parse("f1f1f1", radix: 16) + 0xFF000000),
      Color(int.parse("e0eacf", radix: 16) + 0xFF000000),
      Color(int.parse("ccd9ad", radix: 16) + 0xFF000000),
      Color(int.parse("a9c3aa", radix: 16) + 0xFF000000),
      Color(int.parse("87a986", radix: 16) + 0xFF000000),
    ],

    [
      Color(int.parse("fbf7ec", radix: 16) + 0xFF000000),
      Color(int.parse("efe6dd", radix: 16) + 0xFF000000),
      Color(int.parse("ded0cd", radix: 16) + 0xFF000000),
      Color(int.parse("d7d1d1", radix: 16) + 0xFF000000),
      Color(int.parse("adacba", radix: 16) + 0xFF000000),
    ],

    [
      Color(int.parse("dee8f1", radix: 16) + 0xFF000000),
      Color(int.parse("97cadb", radix: 16) + 0xFF000000),
      Color(int.parse("018abe", radix: 16) + 0xFF000000),
      Color(int.parse("024481", radix: 16) + 0xFF000000),
    ],

    [
      Colors.white,
      Colors.tealAccent,
      Colors.lightBlueAccent,
      Colors.yellowAccent,
      Colors.lightGreenAccent,
      Colors.greenAccent,
      Colors.cyanAccent,
      Colors.blueAccent,
      Colors.redAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
    ],
  ];
}
