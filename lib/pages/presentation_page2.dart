import 'package:flutter/material.dart';

class PresentationPage2 extends StatelessWidget {
  const PresentationPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(
      context,
    ).size.width;
    final double subtitleFontSize =
        (screenWidth * 0.045).clamp(16.0, 22.0);
    final double buttonFontSize =
        (screenWidth * 0.045).clamp(16.0, 20.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/logo.webp',
            width: screenWidth * 0.6,
          ),
          const Spacer(flex: 1),
          Icon(
            Icons.photo_library_outlined,
            size: 135,
            color: const Color.fromARGB(
              255,
              85,
              85,
              85,
            ),
          ),
          Text(
            'Acompanhar eventos e posts do Instituto e ficar por dentro das novidades!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: subtitleFontSize * 1.35,
            ),
          ),
          Text(
            '2/2',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: subtitleFontSize * 0.90,
            ),
          ),
          const Spacer(flex: 2),
          SizedBox(
            width: screenWidth * 0.85,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFFEC2C8F,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(
                  context,
                ).pushReplacementNamed('/home');
              },
              child: Text(
                "Começar!",
                style: TextStyle(
                  fontSize: buttonFontSize * 1.2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
