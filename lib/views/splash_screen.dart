import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reto_app/controllers/auth_controller.dart';
import 'package:reto_app/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isDisposed = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _goHome();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  _goHome() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {});
    await _auth.currentUser?.reload();
    User? user = _auth.currentUser;

    if (mounted && !_isDisposed) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(index: 1)),
        (route) => false,
      );
    }
  }

  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset('assets/images/gif4.gif')));
  }
}
// import 'package:flutter/material.dart';
