import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<WordModel>> getWords() async {
    try {
      debugPrint("DatabaseService: Attempting to fetch words from Firestore...");
      debugPrint("DatabaseService: Project ID: ${_db.app.options.projectId}");
      
      QuerySnapshot snapshot = await _db.collection('words').get();
      
      if (snapshot.docs.isEmpty) {
        debugPrint("DatabaseService: 'words' collection is empty. (Source: ${snapshot.metadata.isFromCache ? 'Cache' : 'Server'})");
        return [];
      }
      
      debugPrint("DatabaseService: Successfully fetched ${snapshot.docs.length} documents from Firestore. (Source: ${snapshot.metadata.isFromCache ? 'Cache' : 'Server'})");
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        // Ensure clues always has exactly 3 elements to avoid UI issues
        List<String> rawClues = List<String>.from(data['clues'] ?? []);
        List<String> normalizedClues = List.generate(3, (i) => i < rawClues.length ? rawClues[i] : "");

        return WordModel(
          id: doc.id,
          word: data['word'] ?? '',
          category: data['category'] ?? 'General',
          clues: normalizedClues,
        );
      }).toList();
    } catch (e) {
      debugPrint("DatabaseService: Error fetching words: $e");
      return [];
    }
  }

  // Save user data (score and progress)
  Future<void> saveUserData(String uid, int score, int lastWordIndex) async {
    try {
      await _db.collection('users').doc(uid).set({
        'totalScore': score,
        'lastWordIndex': lastWordIndex,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }
}
