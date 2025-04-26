import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:google_fonts/google_fonts.dart';
import 'package:reto_app/views/screens/main_screen.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String name;

  PhoneVerificationScreen({required this.phoneNumber, required this.name});

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance
  String? _verificationId;
  bool _isCodeSent = false;
  bool _isVerifying = false;
  String _smsCode = '';

  @override
  void initState() {
    super.initState();
    _sendOTP();
  }

  Future<void> _sendOTP() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          _saveUserDataToFirestore(); // Save user data after auto-verification
          _navigateToMainScreen();
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isCodeSent = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP sent to ${widget.phoneNumber}')),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _verifyOTP() async {
    if (_verificationId == null || _smsCode.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter the OTP')));
      return;
    }

    try {
      setState(() {
        _isVerifying = true;
      });

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsCode,
      );

      await _auth.signInWithCredential(credential);
      await _saveUserDataToFirestore(); // Save user data after manual verification
      _navigateToMainScreen();
    } catch (e) {
      setState(() {
        _isVerifying = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid OTP: $e')));
    }
  }

  Future<void> _saveUserDataToFirestore() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final uid = user.uid;

      try {
        await _firestore.collection('customers').doc(uid).set({
          'uid': uid,
          'phoneNumber': widget.phoneNumber,
          'name': widget.name, // Default name (can be updated later)
          'profileImage': '',
          'email': user.email ?? '',
          'pinCode': '',
          'locality': '',
          'city': '',
          'state': '',
          'isAdmin': false,
        }, SetOptions(merge: true)); // Merge to avoid overwriting existing data
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving user data: $e')));
      }
    }
  }

  void _navigateToMainScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(index: 1)),
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Phone number verified successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFDABE),
      appBar: AppBar(
        title: Text(
          'Phone Verification',
          style: GoogleFonts.getFont(
            'Lexend',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xFFFFDABE),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Verify Your Phone Number',
                  style: GoogleFonts.getFont(
                    'Lexend',
                    color: Color(0xFF0d120E),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'An OTP has been sent to ${widget.phoneNumber}. Please enter the OTP below to verify your phone number.',
                  style: GoogleFonts.getFont(
                    'Roboto',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                if (_isCodeSent)
                  TextFormField(
                    onChanged: (value) {
                      _smsCode = value.trim();
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter OTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      labelStyle: GoogleFonts.getFont(
                        'Nunito Sans',
                        fontSize: 14,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                if (_isVerifying)
                  CircularProgressIndicator(color: Color(0xFFf58634))
                else
                  ElevatedButton(
                    onPressed: _verifyOTP,
                    child: Text(
                      'Verify OTP',
                      style: GoogleFonts.getFont(
                        'Lexend',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFf58634),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _sendOTP,
                  child: Text(
                    'Resend OTP',
                    style: GoogleFonts.getFont(
                      'Roboto',
                      fontSize: 16,
                      color: Color(0xFFf58634),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
