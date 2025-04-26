// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:reto_app/views/screens/main_screen.dart';

// class VerificationScreen extends StatefulWidget {
//   @override
//   _VerificationScreenState createState() => _VerificationScreenState();
// }

// class _VerificationScreenState extends State<VerificationScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? _user;
//   bool _isEmailVerified = false;
//   bool _isSendingVerification = false;

//   @override
//   void initState() {
//     super.initState();
//     _user = _auth.currentUser;
//     _isEmailVerified = _user?.emailVerified ?? false;

//     if (!_isEmailVerified) {
//       _sendVerificationEmail();
//     }
//   }

//   Future<void> _sendVerificationEmail() async {
//     try {
//       setState(() {
//         _isSendingVerification = true;
//       });
//       await _user?.sendEmailVerification();
//       setState(() {
//         _isSendingVerification = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isSendingVerification = false;
//       });
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(content: Text(e.toString())),
//       // );
//     }
//   }

//   Future<void> _checkEmailVerified() async {
//     await _user?.reload();
//     setState(() {
//       _isEmailVerified = _auth.currentUser?.emailVerified ?? false;
//     });
//     if (_isEmailVerified) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Email verified successfully')));
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MainScreen(index: 1,),
//         ), // Replace with your main screen
//         (route) => false,
//       );
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Email not verified yet')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 255, 255, 255),
//       appBar: AppBar(
//         title: Text('Email Verification'),
//         backgroundColor: Color.fromARGB(255, 255, 255, 255),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Text(
//                   'Verify Your Email',
//                   style: GoogleFonts.getFont(
//                     'Lexend',
//                     color: Color(0xFF0d120E),
//                     fontWeight: FontWeight.bold,
//                     fontSize: 24,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 Text(
//                   'A verification email has been sent to ${_user?.email}. Please check your inbox and verify your email.',
//                   style: GoogleFonts.getFont(
//                     'Roboto',
//                     fontSize: 16,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 40),
//                 if (_isSendingVerification)
//                   CircularProgressIndicator()
//                 else
//                   ElevatedButton(
//                     onPressed: _sendVerificationEmail,
//                     child: Text('Resend Verification Email'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color.fromARGB(255, 255, 255, 255),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                 const SizedBox(height: 40),
//                 Text(
//                   'After verifying your email, click the button below. I have verified my email',
//                   style: GoogleFonts.getFont(
//                     'Roboto',
//                     fontSize: 16,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 40),
//                 ElevatedButton(
//                   onPressed: _checkEmailVerified,
//                   child: Text('I have verified my email'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color.fromARGB(255, 255, 255, 255),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reto_app/views/screens/authentication_screens/PhoneVerificationScreen.dart';
import 'package:reto_app/views/screens/main_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String contactNumber;
  final String name;

  const VerificationScreen({required this.contactNumber, required this.name});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isEmailVerified = false;
  bool _isSendingVerification = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _isEmailVerified = _user?.emailVerified ?? false;

    if (!_isEmailVerified) {
      _sendVerificationEmail();
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      setState(() {
        _isSendingVerification = true;
      });
      await _user?.sendEmailVerification();
      setState(() {
        _isSendingVerification = false;
      });
    } catch (e) {
      setState(() {
        _isSendingVerification = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _checkEmailVerified() async {
    await _user?.reload();
    setState(() {
      _isEmailVerified = _auth.currentUser?.emailVerified ?? false;
    });
    if (_isEmailVerified) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email verified successfully')));
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => MainScreen(index: 1)),
      //   (route) => false,
      // );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => PhoneVerificationScreen(
                phoneNumber: '+91${widget.contactNumber}',
                name: widget.name,
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email not verified yet')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFDABE),
      appBar: AppBar(
        title: Text(
          'Email Verification',
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
                  'Verify Your Email',
                  style: GoogleFonts.getFont(
                    'Lexend',
                    color: Color(0xFF0d120E),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'A verification email has been sent to ${_user?.email}. Please check your inbox and verify your email.',
                  style: GoogleFonts.getFont(
                    'Roboto',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                if (_isSendingVerification)
                  CircularProgressIndicator(color: Color(0xFFf58634))
                else
                  ElevatedButton(
                    onPressed: _sendVerificationEmail,
                    child: Text(
                      'Resend Verification Email',
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
                const SizedBox(height: 30),
                Text(
                  'After verifying your email, click the button below.',
                  style: GoogleFonts.getFont(
                    'Roboto',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _checkEmailVerified,
                  child: Text(
                    'I have verified my email',
                    style: GoogleFonts.getFont(
                      'Lexend',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFf58634),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
