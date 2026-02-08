import 'package:flutter/material.dart';

class SelectedWordView extends StatelessWidget {
  final List<String> selectedLetters;
  final int totalLength;
  final Function(int) onRemoveTap;

  const SelectedWordView({
    super.key,
    required this.selectedLetters,
    required this.totalLength,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(totalLength, (index) {
        bool hasLetter = index < selectedLetters.length;
        return GestureDetector(
          onTap: hasLetter ? () => onRemoveTap(index) : null,
          child: Container(
            width: 45,
            height: 55,
            decoration: BoxDecoration(
              color: hasLetter
                  ? Theme.of(context).primaryColor
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasLetter
                    ? Theme.of(context).primaryColor
                    : Colors.white24,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                hasLetter ? selectedLetters[index] : '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: hasLetter ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
