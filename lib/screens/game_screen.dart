import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/clue_card.dart';
import '../widgets/scrambled_word_view.dart';
import '../widgets/selected_word_view.dart';
import '../services/auth_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  void _showWinDialog(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 CORRECT!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('The word was: ${provider.currentWord.word}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Score: +${_calculatePoints(provider)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                provider.nextWord();
                Navigator.of(ctx).pop();
              },
              child: const Text('NEXT WORD'),
            ),
          ),
        ],
      ),
    );
  }

  int _calculatePoints(GameProvider provider) {
    if (provider.revealedCluesCount == 0) return 100;
    if (provider.revealedCluesCount == 1) return 80;
    if (provider.revealedCluesCount == 2) return 50;
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          }

          if (provider.isGameWon) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showWinDialog(context, provider);
            });
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).primaryColor.withOpacity(0.05),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('SCORE',
                                style:
                                    TextStyle(color: Colors.white54, letterSpacing: 2)),
                            Text('${provider.score}',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.amber),
                              ),
                              child: Text(
                                provider.currentWord.category.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (provider.isGuestMode)
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(
                                  'GUEST',
                                  style: TextStyle(
                                    color: Colors.white24,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            IconButton(
                              onPressed: () => provider.logout(),
                              icon: const Icon(Icons.logout, color: Colors.white54),
                              tooltip: 'Logout',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'YOUR ANSWER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white30,
                          letterSpacing: 2,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SelectedWordView(
                      selectedLetters: provider.selectedLetters,
                      totalLength: provider.currentWord.word.length,
                      onRemoveTap: (idx) => provider.deselectLetter(idx),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'TAP LETTERS TO ARRANGE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white30,
                          letterSpacing: 2,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ScrambledWordView(
                      availableLetters: provider.availableLetters,
                      onLetterTap: (idx) => provider.selectLetter(idx),
                    ),
                    if (provider.revealedCluesCount == 3 && !provider.isGameWon && !provider.isAnswerRevealed) ...[
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () => provider.revealAnswer(),
                        icon: const Icon(Icons.visibility, color: Colors.amber),
                        label: const Text('SHOW ANSWER', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.amber.withOpacity(0.1),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                    if (provider.isAnswerRevealed) ...[
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => provider.nextWord(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white10,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('NEXT WORD', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
                      ),
                    ],
                    const SizedBox(height: 30),
                    const Text('CLUES',
                        style: TextStyle(
                            color: Colors.white54,
                            letterSpacing: 2,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return ClueCard(
                            index: index,
                            content: provider.currentWord.clues[index],
                            isRevealed: provider.revealedCluesCount > index,
                            onReveal: () => provider.revealClue(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
