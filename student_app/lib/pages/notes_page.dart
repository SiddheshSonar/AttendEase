import 'package:attendease/components/notes_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:attendease/models/notes_model.dart';
import 'package:attendease/db/notes_db.dart';
import 'package:attendease/pages/edit_note_page.dart';
import 'package:attendease/pages/notes_details_page.dart';

GlobalKey<NotesPageState> noteStateKey = GlobalKey<NotesPageState>();

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    // NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddEditNotePage()),
                      );
                    },
                    child: const Icon(Icons.add_rounded)),
              ],
            ),
          ),
          // Padding(padding: const EdgeInsets.only(top: 50.0)),
          Padding(
            padding: const EdgeInsets.only(top: 42.0, left: 8, right: 8),
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : notes.isEmpty
                      ? const Text(
                          'No Notes',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )
                      : buildNotes(),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.black,
      //   child: const Icon(Icons.add),
      //   onPressed: () async {
      //     await Navigator.of(context).push(
      //       MaterialPageRoute(builder: (context) => const AddEditNotePage()),
      //     );

      //     refreshNotes();
      //   },
      // ),
    );
  }

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
