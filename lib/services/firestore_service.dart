import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  //get collection of notes
  final CollectionReference notes=FirebaseFirestore.instance.collection("notes");

  //create: adding new note
  Future<void> addNote(String note){
    return notes.add({
      "note":note,
      "timestamp":Timestamp.now()
    });
  }

  //read: get notes from database

  Stream<QuerySnapshot> getNotesStream(){
    final notesStream=notes.orderBy("timestamp",descending: true).snapshots();
    return notesStream;
  }

  //update: update notes givin a doc id
  Future<void> updateNote(String docID, String newNote){
    return notes.doc(docID).update({
      "note":newNote,
      "timestamp":Timestamp.now()
    });
  }


  //delete: delete notes
  Future<void> deleteNote(String docID){
    return notes.doc(docID).delete();
  }


}




///collection -> big api(products)
///doc-> single thing in a collection (product1)
///inside doc there is also dictionary for every doc(title, name, catefory, price)