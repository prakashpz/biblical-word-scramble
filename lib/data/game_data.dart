import '../models/word_model.dart';

class GameData {
  static final List<WordModel> words = [
    WordModel(
      id: '1',
      word: 'ABRAHAM',
      category: 'Character',
      clues: [
        'Called the Father of many nations.',
        'His wife was named Sarah.',
        'He was asked to sacrifice his son Isaac.'
      ],
    ),
    WordModel(
      id: '2',
      word: 'GENESIS',
      category: 'Bible Book',
      clues: [
        'The first book of the Bible.',
        'Means "beginning" or "origin".',
        'Contains the story of creation and Adam and Eve.'
      ],
    ),
    WordModel(
      id: '3',
      word: 'GOLIATH',
      category: 'Character',
      clues: [
        'A giant Philistine warrior.',
        'Defeated by a young boy with a sling and a stone.',
        'He was from the city of Gath.'
      ],
    ),
    WordModel(
      id: '4',
      word: 'JERICHO',
      category: 'Place',
      clues: [
        'An ancient city whose walls came tumbling down.',
        'Located in the Jordan Valley.',
        'Reached by the Israelites after crossing the Jordan River.'
      ],
    ),
    WordModel(
      id: '5',
      word: 'SAMSON',
      category: 'Character',
      clues: [
        'Known for his extraordinary physical strength.',
        'His strength was tied to his long hair.',
        'Betrayed by Delilah to the Philistines.'
      ],
    ),
    WordModel(
      id: '6',
      word: 'MOSES',
      category: 'Character',
      clues: [
        'Led the Israelites out of Egypt.',
        'Received the Ten Commandments on Mount Sinai.',
        'Parted the Red Sea with his staff.'
      ],
    ),
    WordModel(
      id: '7',
      word: 'BETHLEHEM',
      category: 'Place',
      clues: [
        'The birthplace of Jesus Christ.',
        'Known as the "City of David".',
        'Located a few miles south of Jerusalem.'
      ],
    ),
    WordModel(
      id: '8',
      word: 'REVELATION',
      category: 'Bible Book',
      clues: [
        'The final book of the New Testament.',
        'Written by the Apostle John on the island of Patmos.',
        'Contains visions of the end times and the New Jerusalem.'
      ],
    ),
  ];
}
