import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reto_app/vendor/controllers/vendor_controller.dart';
import 'package:reto_app/vendor/views/auth/vendor_register_screen.dart';
import 'package:reto_app/vendor/views/screens/main_vendor_screen.dart';
import 'package:reto_app/views/screens/authentication_screens/login_screen.dart';

class VendorLoginScreen extends StatefulWidget {
  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VendorAuthController _authController = VendorAuthController();

  bool _isLoading = false;
  bool _isObscure = true;

  late String email;
  late String password;

  // Function to check if the user is an admin in either 'customers' or 'vendors' collection
  Future<bool> _checkIfAdmin(String email) async {
    try {
      // Check in 'customers' collection
      QuerySnapshot customersSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .where('email', isEqualTo: email)
          .get();

      if (customersSnapshot.docs.isNotEmpty) {
        DocumentSnapshot customerDoc = customersSnapshot.docs.first;
        bool isAdmin = customerDoc['isAdmin'] ?? false;
        if (isAdmin) {
          return true; // User is an admin in 'customers' collection
        }
      }

      // Check in 'vendors' collection
      QuerySnapshot vendorsSnapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .where('email', isEqualTo: email)
          .get();

      if (vendorsSnapshot.docs.isNotEmpty) {
        DocumentSnapshot vendorDoc = vendorsSnapshot.docs.first;
        bool isAdmin = vendorDoc['isAdmin'] ?? false;
        if (isAdmin) {
          return true; // User is an admin in 'vendors' collection
        }
      }

      // User is not an admin in either collection
      return false;
    } catch (e) {
      print("Error checking admin status: $e");
      return false;
    }
  }

  // Login User Function
  loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await _authController.loginUser(email, password);

    if (res == 'Success') {
      // Check if the user is an admin in either collection
      bool isAdmin = await _checkIfAdmin(email);

      if (isAdmin) {
        // Navigate to the Main Vendor Screen
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const MainVendorScreen();
        }));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged IN Successfully')),
        );
      } else {
        // User is not an admin
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access Denied: You are not an admin')),
        );
      }
    } else {
      // Login failed
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "RetoADMIN Login",
                    style: GoogleFonts.getFont(
                      'Lato',
                      color: Color(0xFF0d120E),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 23,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Handcrafted with Love,  Delivered with Purpose",
                    style: GoogleFonts.getFont(
                      'Lato',
                      color: Color(0xFF0d120E),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/RetoCircular.png',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Email",
                      style: GoogleFonts.getFont(
                        'Nunito Sans',
                        color: Color(0xFF0d120E),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      labelText: 'Enter Your Email',
                      labelStyle: GoogleFonts.getFont(
                        "Nunito Sans",
                        fontSize: 14,
                        letterSpacing: 0.2,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/icons/email.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Password",
                      style: GoogleFonts.getFont(
                        'Nunito Sans',
                        color: Color(0xFF0d120E),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextFormField(
                    obscureText: _isObscure,
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Your Password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      labelText: 'Enter Your Password',
                      labelStyle: GoogleFonts.getFont(
                        "Nunito Sans",
                        fontSize: 14,
                        letterSpacing: 0.2,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/icons/password.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        loginUser();
                      }
                    },
                    child: Container(
                      width: 319,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF102DE1), Color(0xCC0D6EFF)],
                        ),
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'LOGIN',
                          style: GoogleFonts.getFont(
                            'Lato',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login to Customer Account? ',
                        style: GoogleFonts.getFont(
                          'Roboto',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }));
                        },
                        child: Text(
                          'SIGN IN',
                          style: GoogleFonts.getFont(
                            'Roboto',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF103DE5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Need an Admin Account? ',
                        style: GoogleFonts.getFont(
                          'Roboto',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return VendorRegisterScreen();
                          }));
                        },
                        child: Text(
                          'SIGN UP',
                          style: GoogleFonts.getFont(
                            'Roboto',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF103DE5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

