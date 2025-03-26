import 'package:flutter/material.dart';
import 'package:new_tab_app/widgets/notes/notes_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DraggableNotesWindow extends StatefulWidget {
  final VoidCallback onClose;

  const DraggableNotesWindow({super.key, required this.onClose});

  @override
  _DraggableNotesWindowState createState() => _DraggableNotesWindowState();
}

class _DraggableNotesWindowState extends State<DraggableNotesWindow> {
  Future<void> saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String notesJson = jsonEncode(notes);
    await prefs.setString('notes', notesJson);
  }

  Future<void> loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notesJson = prefs.getString('notes');
    if (notesJson != null) {
      List<dynamic> notesList = jsonDecode(notesJson);
      setState(() {
        notes = notesList
            .map((note) =>
                {'note': note['note'] ?? '', 'done': note['done'] as bool})
            .toList();
      });
    }

    print("Loaded notes: $notes");
  }

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  double dx = 1200;
  double dy = 2;
  List<Map<String, dynamic>> notes = [];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: dx,
      top: dy,
      child: Draggable(
        feedback: SizedBox.shrink(),
        onDragEnd: (dragDetails) {
          setState(() {
            dx = dragDetails.offset.dx;
            dy = dragDetails.offset.dy;
          });
        },
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      dx += details.delta.dx;
                      dy += details.delta.dy;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF191515),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Notes",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.white),
                              onPressed: () {
                                TextEditingController controller =
                                    TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return NoteAlert(
                                      controller: controller,
                                      onSave: () {
                                        setState(() {
                                          notes.add({
                                            'note': controller.text,
                                            'done': false
                                          });
                                        });
                                        saveNotes();
                                        print(notes);
                                      },
                                      hint: 'Add Note',
                                      title: 'Add Note',
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: widget.onClose,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Notes List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        onDoubleTap: () {
                          TextEditingController controller =
                              TextEditingController(text: notes[index]['note']);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return NoteAlert(
                                controller: controller,
                                onSave: () {
                                  setState(() {
                                    notes[index] = {
                                      'note': controller.text,
                                      'done': notes[index]['done']
                                    };
                                  });
                                },
                                hint: 'Edit Note',
                                title: 'Edit Note',
                              );
                            },
                          );
                        },
                        child: ListTile(
                          leading: Checkbox(
                            value: notes[index]['done'],
                            onChanged: (bool? value) {
                              setState(() {
                                notes[index]['done'] = value!;
                              });
                              saveNotes();
                            },
                            // onChanged: (bool? value) {},
                          ),
                          title: Text(notes[index]['note']),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
