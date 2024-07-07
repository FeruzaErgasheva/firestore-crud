import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/services/firestore_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textEditingController = TextEditingController();
  FirestoreService firestoreService = FirestoreService();

  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () {
                if (docID == null) {
                  firestoreService.addNote(textEditingController.text);
                } else {
                  firestoreService.updateNote(
                      docID, textEditingController.text);
                }
                textEditingController.clear();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
          content: TextField(
            controller: textEditingController,
            autocorrect: true,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                //get eah individual document
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                ///get note from each document in map form since document rn is not map
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data["note"];
                return ListTile(
                    title: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => openNoteBox(docID: docID),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                            onPressed: () {
                              firestoreService.deleteNote(docID);
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ));
              },
            );
          } else {
            return const Center(
              child: Text("There is not any note available"),
            );
          }
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Notes",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
    );
  }
}
