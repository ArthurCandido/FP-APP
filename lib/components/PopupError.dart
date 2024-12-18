import 'package:flutter/material.dart';

class PopupError extends StatelessWidget {
  final String error;

  const PopupError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            error,
            style: const TextStyle(
              color: Colors.red,
            ),
          )
        ),
      ),
    );
  }
}