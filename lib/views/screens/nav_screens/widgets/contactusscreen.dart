import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 199, 169),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 251, 224, 199),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE67E22), width: 2),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE67E22),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Image.asset('assets/images/RetoCircular.png'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Greeting
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(text: 'Dear '),
                      TextSpan(
                        text: 'Retizen,',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Facing any issues?',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 16),

                // Help message
                const Text(
                  'We\'re here to help!',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 16),

                // Contact info
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'For any concerns related to delivery, account updates, or technical issues, feel free to reach out to us through:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),

                // WhatsApp
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('💬', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    Text(
                      'WhatsApp:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '+91 87777 60377',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Email
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('📧', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'retoindia.customerservice@gmail.com',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Closing message
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Your satisfaction is our priority, and we\'ll do our best to assist you promptly.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(Icons.favorite, color: Color(0xFF3498DB), size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RetoLogo extends StatelessWidget {
  const RetoLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(size: const Size(60, 60), painter: LogoPainter()),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Reto',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'INDIA',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = const Color(0xFFE67E22)
          ..style = PaintingStyle.fill;

    final Path path = Path();

    // Simplified flower-like shape as seen in the logo
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.3,
      size.width,
      size.height / 2,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.7,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.7,
      0,
      size.height / 2,
    );
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.3,
      size.width / 2,
      0,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
