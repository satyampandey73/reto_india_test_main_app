import 'package:flutter/material.dart';
import 'package:reto_app/views/screens/nav_screens/widgets/marqueetext.dart';

class Scrollintextwidget extends StatelessWidget {
  const Scrollintextwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.circular(0),
        ),
        child: const Center(
          child: MarqueeText(
            text:
                '🔥 Special Offer: 30% off on all premium features until the end of the month! Limited time offer, grab it now! 🔥',
            textStyle: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            speed: 50,
          ),
        ),
      ),
    );
  }
}
