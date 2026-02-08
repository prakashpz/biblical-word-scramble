class WordModel {
  final String id;
  final String word;
  final List<String> clues;
  final String category; // e.g., 'Character', 'Book', 'Place'

  WordModel({
    required this.id,
    required this.word,
    required this.clues,
    required this.category,
  });

  String get scrambledWord {
    List<String> chars = word.toUpperCase().split('');
    if (chars.length <= 1) return word.toUpperCase();
    
    String scrambled;
    int attempts = 0;
    do {
      chars.shuffle();
      scrambled = chars.join('');
      attempts++;
    } while (scrambled == word.toUpperCase() && attempts < 10);
    
    return scrambled;
  }
}
