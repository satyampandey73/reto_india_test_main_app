import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reto_app/views/screens/inner_screens/order_detail_screen.dart';
import 'package:reto_app/views/screens/main_screen.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> ordersStream =
        FirebaseAuth.instance.currentUser != null
            ? FirebaseFirestore.instance
                .collection('orders')
                .where(
                  'customerId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                )
                .snapshots()
            : const Stream.empty(); // Return an empty stream if no user is logged in. //Accessing all the Orders of the Current User.

    return Scaffold(
      backgroundColor: Colors.white,
      //Start of APP BAR
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.07,
        ), //The App Bar will take 20% of the screen size
        child: Container(
          width:
              MediaQuery.of(context)
                  .size
                  .width, //The App Bar will take complete width of the screen size, although it is width of container but it will denote the width of App Bar only.
          height: 118, //Height of the container
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 250, 197, 159),
            // image: DecorationImage(
            //   image: AssetImage('assets/icons/cartb.png',), //Cart Icon
            //   fit: BoxFit.cover, //This will actually make our App Bar cover the entire screen width
            // ),
          ),

          child: Stack(
            children: [
              Positioned(
                left: 300,
                top: 45,
                child: Stack(
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/home.png',
                        width: 28,
                        height: 28,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              //This is the method to go to different screen
                              return MainScreen(index: 1);
                            },
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),

              //TITLE OF OUR NAVBAR
              Positioned(
                left: 61,
                top: 45,
                child: Text(
                  'My Orders',
                  style: GoogleFonts.lato(
                    fontSize: 28,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ), //End of APP BAR

      body: StreamBuilder<QuerySnapshot>(
        stream: ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null ||
              snapshot.data!.docs.isEmpty) // If there are no orders
          {
            return const Center(
              child: Text(
                'You Have Not Ordered Anything',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,

            itemBuilder: (context, index) {
              final orderData = snapshot.data!.docs[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10, //Horizontal Padding
                  vertical: 10, //Vertical Padding
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return OrderDetailScreen(
                            orderData: orderData,
                          ); //Navigating to Order Detail Screen and also passing complete our order data.
                        },
                      ),
                    );
                  },

                  child: Container(
                    width: 335,
                    height: 140,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    child: SizedBox(
                      width: double.infinity,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 336,
                              height: 144,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 253, 238, 224),
                                border: Border.all(
                                  color: const Color(0xFFEFF0F2),
                                ),
                                borderRadius: BorderRadius.circular(9),
                              ),

                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  //IMAGE SECTION
                                  Positioned(
                                    left: 10,
                                    top: 9,
                                    //Box inside which our Image will be shown
                                    child: Container(
                                      width: 78,
                                      height: 78,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          //Image is displayed
                                          Positioned(
                                            left: 10,
                                            top: 5,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  orderData['productImage'], // URL of the product image
                                              width: 58, // Width of the image
                                              height: 67, // Height of the image
                                              fit: BoxFit.cover,
                                              placeholder:
                                                  (context, url) =>
                                                      const CircularProgressIndicator(), // Placeholder while loading
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                        Icons.error,
                                                      ), // Error widget
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    left: 101,
                                    top: 14,
                                    child: SizedBox(
                                      width: 216,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  //Displaying Product Name
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: Text(
                                                      orderData['productName'],
                                                      style: GoogleFonts.lato(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(height: 4),

                                                  //Displaying Product Category Name
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      orderData['category'],
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Color(
                                                          0xFF7F808C,
                                                        ),
                                                        // fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(height: 2),

                                                  //Displaying Product Price but it is actually our Discounted Price because everywhere we have passed it as this is the price which the user has paid for the Product.
                                                  Text(
                                                    '\₹${orderData['price'].toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF0B0C1E),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),

                                                  SizedBox(height: 2),

                                                  Text(
                                                    '\Quantity: ${orderData['quantity']}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(
                                                        255,
                                                        100,
                                                        1,
                                                        87,
                                                      ),

                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  //Container where Delivery Status of the Product will be shown to the Customer.
                                  Positioned(
                                    left: 14,
                                    top: 100,
                                    child: Container(
                                      width:
                                          90, //Width of the Box where status will be shown
                                      height:
                                          25, //Height of the Box where status will be shown
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        //Color depending on the status of Order Delivery
                                        color:
                                            orderData['delivered'] == true
                                                ? Color(
                                                  0xFF3C55EF,
                                                ) //This color will be shown when the order has been delivered.
                                                : orderData['processing'] ==
                                                    true
                                                ? Colors
                                                    .purple //This color will be shown when the order is in processing.
                                                : Colors
                                                    .red, //This color will be shown when the order is cancelled.

                                        borderRadius: BorderRadius.circular(4),
                                      ),

                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            left: 9,
                                            top: 3,
                                            //Text depending on the status of Order Delivery
                                            child: Text(
                                              orderData['delivered'] == true
                                                  ? 'Delivered' //This text will be shown when the order has been delivered.
                                                  : orderData['processing'] ==
                                                      true
                                                  ? 'Processing' //This text will be shown when the order is in processing.
                                                  : 'Cancelled', //This text will be shown when the order is cancelled.

                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // //DELETE BUTTON SECTION
                          // Positioned(
                          //     top: 115,
                          //     left: 298,
                          //
                          //     child: Container(
                          //       width: 20,
                          //       height: 20,
                          //       clipBehavior: Clip.antiAlias,
                          //       decoration: BoxDecoration(), //IMPORTANT: Whenever we are using clipBehaviour, BoxDecoration is compulsory to mention even when we are not using it.
                          //       child: Stack(
                          //         clipBehavior: Clip.none,
                          //         children: [
                          //           //Delete Icon
                          //           Positioned(
                          //               top: 0,
                          //               left: 0,
                          //               child: InkWell(
                          //                 onTap: () async{
                          //                   await _firestore.collection('orders').doc(orderData['orderId']).delete(); //This will Delete this particular order
                          //                 },
                          //
                          //                 child: Image.asset('assets/icons/delete.png',
                          //                   width: 20,
                          //                   height: 20,
                          //                   color: Colors.red,
                          //                 ),
                          //               ),
                          //           ),
                          //         ],
                          //       ),
                          //
                          //     ),
                          // ), //END OF DELETE BUTTON SECTION
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
