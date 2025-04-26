//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ShippingAddressScreen extends StatefulWidget {
//   const ShippingAddressScreen({super.key});
//
//   @override
//   State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
// }
//
// class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   late String state;
//
//   late String city;
//
//   late String locality;
//
//   late String pinCode;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white.withOpacity(0.96),
//
//
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white.withOpacity(0.96),
//         title: Text('Delivery Address',
//           style: GoogleFonts.lato(
//             fontSize: 18,
//             // letterSpacing: 1,
//             // color: Colors.pink,
//             fontWeight: FontWeight.w600,
//             // height: 1.4,
//           ),
//         ),
//       ),
//
//
//
//       body: Padding(
//         // padding: const EdgeInsets.only(top: 20), //Padding only at Top
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), //Padding only at Top
//         child: Center(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Text('Where will Your ORDER \n be SHIPPED?',
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.lato(
//                     fontSize: 18,
//                     letterSpacing: 1,
//                     // color: Colors.pink,
//                     // fontWeight: FontWeight.w600,
//                     // height: 1.4,
//                   ),
//                 ),
//
//                 TextFormField(
//                   onChanged: (value) {
//                     state = value;  //Storing the form field input text in this variable.
//                   },
//
//                   validator: (value) {
//                     if(value!.isEmpty)
//                     {
//                       return 'Enter Your State';
//                     }
//                     else
//                     {
//                       return null;
//                     }
//                   },
//
//                   decoration: InputDecoration(
//                     labelText: 'State',
//                     // border: OutlineInputBorder(), //This will give border to our entire text field
//                   ),
//                 ),
//
//                 SizedBox(height: 30,),
//
//                 TextFormField(
//                   onChanged: (value) {
//                     city = value;  //Storing the form field input text in this variable.
//                   },
//
//                   validator: (value) {
//                     if(value!.isEmpty)
//                     {
//                       return 'Enter Your City';
//                     }
//                     else
//                     {
//                       return null;
//                     }
//                   },
//
//                   decoration: InputDecoration(
//                     labelText: 'City',
//                     // border: OutlineInputBorder(), //This will give border to our entire text field
//                   ),
//                 ),
//
//                 SizedBox(height: 30,),
//
//                 TextFormField(
//                   onChanged: (value) {
//                     locality = value;  //Storing the form field input text in this variable.
//                   },
//
//                   validator: (value) {
//                     if(value!.isEmpty)
//                     {
//                       return 'Enter Your House Number, Road and Locality';
//                     }
//                     else
//                     {
//                       return null;
//                     }
//                   },
//
//                   decoration: InputDecoration(
//                     labelText: 'House Number, Road and Locality',
//                     // border: OutlineInputBorder(), //This will give border to our entire text field
//                   ),
//                 ),
//
//                 SizedBox(height: 30,),
//
//                 TextFormField(
//                   onChanged: (value) {
//                     pinCode = value;  //Storing the form field input text in this variable.
//                   },
//
//                   validator: (value) {
//                     if(value!.isEmpty)
//                     {
//                       return 'Enter Your Pincode';
//                     }
//                     else
//                     {
//                       return null;
//                     }
//                   },
//
//                   decoration: InputDecoration(
//                     labelText: 'Pincode',
//                     // border: OutlineInputBorder(), //This will give border to our entire text field
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//
//
//       //ADD ADDRESS BUTTON SECTION
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(25.0),
//         child: InkWell(
//           onTap: () async{
//             if(_formKey.currentState!.validate())
//             {
//               //We want to update the User Locality, City, State and Pincode in Firebase.
//               _showDialog(context);
//               await _firestore.collection('customers').doc(_auth.currentUser!.uid).update({  //THIS IS HOW WE UPDATE FIELDS IN OUR FIREBASE.
//                 'state' : state,
//                 'city' : city,
//                 'locality' : locality,
//                 'pinCode' : pinCode
//                 },
//               ).whenComplete(() { //After our above function of updating address is complete, then this will happen.
//                 Navigator.of(context).pop(); //This line will take us back to the Cart Screen.
//                 setState(() {
//                   _formKey.currentState!.validate();
//                 });
//               });
//             }
//             else
//             {
//               //Show a SnackBar
//             }
//           },
//
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: 50,
//
//             decoration: BoxDecoration(
//               color: const Color(0xFF1532E7),
//               borderRadius: BorderRadius.circular(10),
//             ),
//
//             child: Center(
//               child: Text('Add ADDRESS',
//                 style: GoogleFonts.lato(
//                   fontSize: 18,
//                   letterSpacing: 1,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   // height: 1.4,
//                 ),
//               ),
//             ),
//
//           ),
//         ),
//       ),
//
//     );
//   }
//
//   //Creating Dialog Function to show the user that his/her address has been updated.
//   void _showDialog(BuildContext context) {
//     showDialog(context: context,
//         barrierDismissible: false, //This will not allow the user to dismiss the Dialog by clicking somewhere else on the Screen.
//         builder: (BuildContext context) {
//       return const AlertDialog(
//         title: Text('Updating Address'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 10,),
//             Text('Please Wait...')
//           ],
//         ),
//       );
//     });
//
//     Future.delayed(const Duration(seconds: 3), (){ //This will remove the dialog above after 3 seconds.
//       Navigator.of(context).pop();
//     });
//
//   }
// }
// right now update

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ShippingAddressScreen extends StatefulWidget {
//   const ShippingAddressScreen({super.key});

//   @override
//   State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
// }

// class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   late String state;

//   late String city;

//   late String locality;

//   late String pinCode;

//   late String name;

//   late String number;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white.withOpacity(0.96),

//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white.withOpacity(0.96),
//         title: Text(
//           'Delivery Address',
//           style: GoogleFonts.lato(
//             fontSize: 18,
//             // letterSpacing: 1,
//             // color: Colors.pink,
//             fontWeight: FontWeight.w600,
//             // height: 1.4,
//           ),
//         ),
//       ),

//       body: SingleChildScrollView(
//         child: Padding(
//           // padding: const EdgeInsets.only(top: 20), //Padding only at Top
//           padding: const EdgeInsets.symmetric(
//             vertical: 20,
//             horizontal: 20,
//           ), //Padding only at Top
//           child: Center(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   Text(
//                     'Where will Your ORDER \n be SHIPPED?',
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.lato(
//                       fontSize: 18,
//                       letterSpacing: 1,
//                       // color: Colors.pink,
//                       // fontWeight: FontWeight.w600,
//                       // height: 1.4,
//                     ),
//                   ),

//                   TextFormField(
//                     onChanged: (value) {
//                       name =
//                           value; //Storing the form field input text in this variable.
//                     },

//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Enter Your Name';
//                       } else {
//                         return null;
//                       }
//                     },

//                     decoration: InputDecoration(
//                       labelText: 'Name',
//                       // border: OutlineInputBorder(), //This will give border to our entire text field
//                     ),
//                   ),

//                   SizedBox(height: 30),

//                   TextFormField(
//                     onChanged: (value) {
//                       number =
//                           value; //Storing the form field input text in this variable.
//                     },

//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Enter Your Number';
//                       } else {
//                         return null;
//                       }
//                     },

//                     decoration: InputDecoration(
//                       labelText: 'Number',
//                       // border: OutlineInputBorder(), //This will give border to our entire text field
//                     ),
//                   ),

//                   SizedBox(height: 30),

//                   TextFormField(
//                     onChanged: (value) {
//                       state =
//                           value; //Storing the form field input text in this variable.
//                     },

//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Enter Your State';
//                       } else {
//                         return null;
//                       }
//                     },

//                     decoration: InputDecoration(
//                       labelText: 'State',
//                       // border: OutlineInputBorder(), //This will give border to our entire text field
//                     ),
//                   ),

//                   SizedBox(height: 30),

//                   TextFormField(
//                     onChanged: (value) {
//                       city =
//                           value; //Storing the form field input text in this variable.
//                     },

//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Enter Your City';
//                       } else {
//                         return null;
//                       }
//                     },

//                     decoration: InputDecoration(
//                       labelText: 'City',
//                       // border: OutlineInputBorder(), //This will give border to our entire text field
//                     ),
//                   ),

//                   SizedBox(height: 30),

//                   TextFormField(
//                     onChanged: (value) {
//                       locality =
//                           value; //Storing the form field input text in this variable.
//                     },

//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Enter Your House Number, Road and Locality';
//                       } else {
//                         return null;
//                       }
//                     },

//                     decoration: InputDecoration(
//                       labelText: 'House Number, Road and Locality',
//                       // border: OutlineInputBorder(), //This will give border to our entire text field
//                     ),
//                   ),

//                   SizedBox(height: 30),

//                   TextFormField(
//                     onChanged: (value) {
//                       pinCode =
//                           value; //Storing the form field input text in this variable.
//                     },

//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Enter Your Pincode';
//                       } else {
//                         return null;
//                       }
//                     },

//                     decoration: InputDecoration(
//                       labelText: 'Pincode',
//                       // border: OutlineInputBorder(), //This will give border to our entire text field
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),

//       //ADD ADDRESS BUTTON SECTION
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(25.0),
//         child: InkWell(
//           onTap: () async {
//             if (_formKey.currentState!.validate()) {
//               //We want to update the User Locality, City, State and Pincode in Firebase.
//               _showDialog(context);
//               await _firestore
//                   .collection('customers')
//                   .doc(_auth.currentUser!.uid)
//                   .update({
//                 //THIS IS HOW WE UPDATE FIELDS IN OUR FIREBASE.
//                 'name': name,
//                 'number': number,
//                 'state': state,
//                 'city': city,
//                 'locality': locality,
//                 'pinCode': pinCode,
//               })
//                   .whenComplete(() {
//                 //After our above function of updating address is complete, then this will happen.
//                 Navigator.of(
//                   context,
//                 ).pop(); //This line will take us back to the Cart Screen.
//                 setState(() {
//                   _formKey.currentState!.validate();
//                 });
//               });
//             } else {
//               //Show a SnackBar
//             }
//           },

//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: 50,

//             decoration: BoxDecoration(
//               color: const Color(0xFF1532E7),
//               borderRadius: BorderRadius.circular(10),
//             ),

//             child: Center(
//               child: Text(
//                 'Add/Update ADDRESS',
//                 style: GoogleFonts.lato(
//                   fontSize: 18,
//                   letterSpacing: 1,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   // height: 1.4,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   //Creating Dialog Function to show the user that his/her address has been updated.
//   void _showDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible:
//       false, //This will not allow the user to dismiss the Dialog by clicking somewhere else on the Screen.
//       builder: (BuildContext context) {
//         return const AlertDialog(
//           title: Text('Updating Address'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 10),
//               Text('Please Wait...'),
//             ],
//           ),
//         );
//       },
//     );

//     Future.delayed(const Duration(seconds: 3), () {
//       //This will remove the dialog above after 3 seconds.
//       Navigator.of(context).pop();
//     });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String state;

  late String city;

  late String locality;

  late String pinCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 219, 193),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 219, 193),
        title: Text(
          'Delivery Address',
          style: GoogleFonts.lato(
            fontSize: 25,
            // letterSpacing: 1,
            // color: Colors.pink,
            fontWeight: FontWeight.w600,
            // height: 1.4,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          // padding: const EdgeInsets.only(top: 20), //Padding only at Top
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20,
          ), //Padding only at Top
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    //LOGIN BRAND Image
                    'assets/images/BcglessLogo.png',
                    width: 150,
                    height: 150,
                  ),

                  Text(
                    'Where will Your ORDER \n be SHIPPED?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexend(
                      fontSize: 20,
                      letterSpacing: 1,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      // height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    onChanged: (value) {
                      state =
                          value; //Storing the form field input text in this variable.
                    },

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your State';
                      } else {
                        return null;
                      }
                    },

                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        //borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      labelText: 'State',
                      labelStyle: GoogleFonts.getFont(
                        "Nunito Sans",
                        fontSize: 18,
                        letterSpacing: 0.2,
                      ),
                      // border: OutlineInputBorder(), //This will give border to our entire text field
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    onChanged: (value) {
                      city =
                          value; //Storing the form field input text in this variable.
                    },

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your City';
                      } else {
                        return null;
                      }
                    },

                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        //borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      labelText: 'City',
                      labelStyle: GoogleFonts.getFont(
                        "Nunito Sans",
                        fontSize: 18,
                        letterSpacing: 0.2,
                      ),
                      // border: OutlineInputBorder(), //This will give border to our entire text field
                    ),
                  ),

                  SizedBox(height: 30),

                  TextFormField(
                    onChanged: (value) {
                      locality =
                          value; //Storing the form field input text in this variable.
                    },

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your House Number, Road and Locality';
                      } else {
                        return null;
                      }
                    },

                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        //borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      labelText: 'House Number, Road and Locality',
                      labelStyle: GoogleFonts.getFont(
                        "Nunito Sans",
                        fontSize: 18,
                        letterSpacing: 0.2,
                      ),
                      // border: OutlineInputBorder(), //This will give border to our entire text field
                    ),
                  ),

                  SizedBox(height: 30),

                  TextFormField(
                    onChanged: (value) {
                      pinCode =
                          value; //Storing the form field input text in this variable.
                    },

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Pincode';
                      } else {
                        return null;
                      }
                    },

                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        //borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      labelText: 'Pincode',
                      labelStyle: GoogleFonts.getFont(
                        "Nunito Sans",
                        fontSize: 18,
                        letterSpacing: 0.2,
                      ),
                      // border: OutlineInputBorder(), //This will give border to our entire text field
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),

      //ADD ADDRESS BUTTON SECTION
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25.0),
        child: InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              //We want to update the User Locality, City, State and Pincode in Firebase.
              _showDialog(context);
              await _firestore
                  .collection('customers')
                  .doc(_auth.currentUser!.uid)
                  .update({
                    //THIS IS HOW WE UPDATE FIELDS IN OUR FIREBASE.
                    'state': state,
                    'city': city,
                    'locality': locality,
                    'pinCode': pinCode,
                  })
                  .whenComplete(() {
                    //After our above function of updating address is complete, then this will happen.
                    Navigator.of(
                      context,
                    ).pop(); //This line will take us back to the Cart Screen.
                    setState(() {
                      _formKey.currentState!.validate();
                    });
                  });
            } else {
              //Show a SnackBar
            }
          },

          // child: Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: 50,

          //   decoration: BoxDecoration(
          //     border: Border.all(color: Colors.black),
          //     color: const Color(0xFFf58634),
          //     borderRadius: BorderRadius.circular(40),
          //   ),

          // child: Center(
          //   child: Text(
          //     'Add / Update ADDRESS',
          //     style: GoogleFonts.lexend(
          //       fontSize: 18,
          //       letterSpacing: 1,
          //       color: Colors.black,
          //       fontWeight: FontWeight.bold,
          //       // height: 1.4,
          //     ),
          //   ),
          // ),
          // ),
          child: Container(
            width: 386, //Width and Height of our Button
            height: 48,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: const Color(0xFFf58634),
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                'Add / Update ADDRESS',
                style: GoogleFonts.lexend(
                  fontSize: 18,
                  letterSpacing: 1,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  // height: 1.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Creating Dialog Function to show the user that his/her address has been updated.
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, //This will not allow the user to dismiss the Dialog by clicking somewhere else on the Screen.
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Updating Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Please Wait...'),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      //This will remove the dialog above after 3 seconds.
      Navigator.of(context).pop();
    });
  }
}
