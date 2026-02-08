import 'package:flutter/material.dart';

class ScrambledWordView extends StatelessWidget {
  final List<String> availableLetters;
  final Function(int) onLetterTap;

  const ScrambledWordView({
    super.key,
    required this.availableLetters,
    required this.onLetterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: List.generate(availableLetters.length, (index) {
        return GestureDetector(
          onTap: () => onLetterTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).primaryColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                availableLetters[index],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
