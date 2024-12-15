import 'package:flutter/material.dart';

class PopupProgress extends StatelessWidget {
  const PopupProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const CircularProgressIndicator(
            color: Color(0xFF832f30),
          ),
        ],
      ),
    );
  }
}