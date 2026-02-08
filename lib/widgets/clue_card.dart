import 'package:flutter/material.dart';

class ClueCard extends StatelessWidget {
  final int index;
  final String content;
  final bool isRevealed;
  final VoidCallback onReveal;

  const ClueCard({
    super.key,
    required this.index,
    required this.content,
    required this.isRevealed,
    required this.onReveal,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRevealed ? Theme.of(context).cardColor : Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRevealed ? Theme.of(context).primaryColor : Colors.white24,
          width: 1.5,
        ),
        boxShadow: isRevealed
            ? [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: InkWell(
        onTap: isRevealed ? null : onReveal,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isRevealed ? Theme.of(context).primaryColor : Colors.grey,
              radius: 14,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: isRevealed
                  ? Text(
                      content,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    )
                  : Text(
                      'Tap to reveal clue ${index + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.white38,
                      ),
                    ),
            ),
            if (!isRevealed)
              const Icon(Icons.lock_outline, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}
