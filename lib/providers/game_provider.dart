import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/word_model.dart';
import '../data/game_data.dart';
import '../services/local_storage_service.dart';

class GameProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final AuthService _authService = AuthService();
  final LocalStorageService _localService = LocalStorageService();
  
  List<WordModel> _allWords = [];
  int _currentWordIndex = 0;
  int _score = 0;
  int _revealedCluesCount = 0;
  bool _isGameWon = false;
  bool _isAnswerRevealed = false;
  bool _isLoading = true;
  bool _isGuestMode = false;
  bool _showAuthScreen = true;
  
  List<String> _availableLetters = [];
  List<String> _selectedLetters = [];

  GameProvider() {
    _initializeGame();
  }

  // Getters
  bool get isLoading => _isLoading;
  bool get isGuestMode => _isGuestMode;
  bool get showAuthScreen => _showAuthScreen;
  bool get isAnswerRevealed => _isAnswerRevealed;
  WordModel get currentWord => _allWords.isNotEmpty 
      ? _allWords[_currentWordIndex] 
      : WordModel(id: '0', word: '', clues: ['', '', ''], category: '');
  int get score => _score;
  int get revealedCluesCount => _revealedCluesCount;
  bool get isGameWon => _isGameWon;
  List<String> get availableLetters => _availableLetters;
  List<String> get selectedLetters => _selectedLetters;
  String get userGuess => _selectedLetters.join('');

  Future<void> _initializeGame() async {
    _isLoading = true;
    notifyListeners();
    
    _allWords = await _dbService.getWords();
    if (_allWords.isEmpty) {
      _allWords = GameData.words;
    } else {
      _allWords.shuffle(); 
    }

    // Check Firebase Auth first
    User? user = _authService.currentUser;
    if (user != null) {
      _isGuestMode = false;
      _showAuthScreen = false;
      debugPrint("Logged in as ${user.email}");
      Map<String, dynamic>? userData = await _dbService.getUserData(user.uid);
      if (userData != null) {
        _score = userData['totalScore'] ?? 0;
        _currentWordIndex = userData['lastWordIndex'] ?? 0;
      }
    } else {
      // Not logged in - check if we should show auth screen or if guest mode was active
      // For now, we wait for user choice in AuthScreen
    }

    _isLoading = false;
    _startNewWord();
  }

  void setGuestMode() async {
    _isGuestMode = true;
    _showAuthScreen = false;
    _isLoading = true;
    notifyListeners();

    final progress = await _localService.getGuestProgress();
    _score = progress['score']!;
    _currentWordIndex = progress['lastWordIndex']!;

    if (_currentWordIndex >= _allWords.length) _currentWordIndex = 0;

    _isLoading = false;
    _startNewWord();
  }

  void logout() {
    _authService.signOut();
    _isGuestMode = false;
    _showAuthScreen = true;
    _score = 0;
    _currentWordIndex = 0;
    notifyListeners();
  }

  void _startNewWord() {
    if (_allWords.isEmpty) return;
    _revealedCluesCount = 0;
    _isGameWon = false;
    _isAnswerRevealed = false;
    _selectedLetters = [];
    
    String scrambled = currentWord.scrambledWord;
    _availableLetters = scrambled.split('');
    notifyListeners();
  }

  void revealClue() {
    if (_revealedCluesCount < 3) {
      _revealedCluesCount++;
      notifyListeners();
    }
  }

  void selectLetter(int index) {
    if (_isGameWon) return;
    String letter = _availableLetters.removeAt(index);
    _selectedLetters.add(letter);
    _checkWin();
    notifyListeners();
  }

  void deselectLetter(int index) {
    if (_isGameWon) return;
    String letter = _selectedLetters.removeAt(index);
    _availableLetters.add(letter);
    notifyListeners();
  }

  void _checkWin() {
    if (_isAnswerRevealed) return;
    if (userGuess == currentWord.word.toUpperCase()) {
      _isGameWon = true;
      _calculateScore();
      _saveProgress();
    }
  }

  void revealAnswer() {
    if (_revealedCluesCount < 3) return;
    _isAnswerRevealed = true;
    _selectedLetters = currentWord.word.toUpperCase().split('');
    _availableLetters = [];
    notifyListeners();
  }

  void _calculateScore() {
    int points = 100;
    if (_revealedCluesCount == 1) points = 80;
    if (_revealedCluesCount == 2) points = 50;
    if (_revealedCluesCount == 3) points = 10;
    _score += points;
  }

  void nextWord() {
    _currentWordIndex = (_currentWordIndex + 1) % _allWords.length;
    _startNewWord();
    _saveProgress();
  }

  Future<void> _saveProgress() async {
    if (_isGuestMode) {
      await _localService.saveGuestProgress(_score, _currentWordIndex);
    } else {
      User? user = _authService.currentUser;
      if (user != null) {
        await _dbService.saveUserData(user.uid, _score, _currentWordIndex);
      }
    }
  }

  void resetGame() {
    _currentWordIndex = 0;
    _score = 0;
    _saveProgress();
    _startNewWord();
  }
}
