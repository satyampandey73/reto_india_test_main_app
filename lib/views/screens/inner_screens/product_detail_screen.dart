// // //This is our Product Detail Page

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reto_app/models/product_model.dart';
import 'package:reto_app/provider/cart_provider.dart';
import 'package:reto_app/provider/favorite_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final ProductModel productData;

  const ProductDetailScreen({super.key, required this.productData});
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(
      cartProvider.notifier,
    ); //Accessing details and state from 'cart_provider' page and for that only we converted to ConsumerStatefulWidget which is only available in Flutter Riverpod.

    final favoriteProviderData = ref.read(favoriteProvider.notifier);

    ref.watch(
      favoriteProvider,
    ); //When we were previously adding an item to favorite it was instant not showing the filled heart icon and only when we refreshed it, it showed but because of this line we can see the change instantly.

    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        255,
        219,
        193,
      ), //Background Color of our Product Detail Screen
      //App Bar of Product Detail Screen
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 219, 193),
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 0, 0, 0)),
        centerTitle: true,
        title: Text(
          widget.productData.productName,
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            color: const Color(0xFF363330),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start, //This will place the widgets from left like start from left end horizontally like starting from there.
          children: [
            //MAIN IMAGE DISPLAY SECTION
            Center(
              child: Container(
                width: 360,
                height: 374,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(), //This will prevent an Error
                //SECTION TO DISPLAY IMAGES OF THE PRODUCT
                child: Stack(
                  clipBehavior: Clip.none,

                  children: [
                    Positioned(
                      //Background Circular Box of Product Images
                      left: 0,
                      top: 20,
                      child: Container(
                        //'clipBehavior' is not accessible within 'SizedBox' and const cannot be used when we have 'Container' inside.
                        width: 360,
                        height: 340,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            246,
                            206,
                            136,
                          ), //color of the circular box
                          borderRadius: BorderRadius.circular(130),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 22,
                      top: 0,
                      child: Container(
                        width: 316,
                        height: 374,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 225, 156),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        //Here we will display all the images of a particular product uploaded.
                        child: SizedBox(
                          height: 300,
                          child: PageView.builder(
                            scrollDirection:
                                Axis.horizontal, //We have to scroll horizontally to see all the images of the product.
                            itemCount: widget.productData.productImage.length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                //Later try to use 'CachedNetworkImage' here like we did before in 'product_item_widget' page.
                                widget
                                    .productData
                                    .productImage[index], //Accessing every image of the product by their index value by which they are saved in our Firebase. (Index for every image is also shown in our Firebase).
                                width:
                                    198, //Width and height of every image that will be displayed. Applicable for all images of all products available.
                                height: 225,
                                fit:
                                    BoxFit
                                        .cover, //For image to cover the entire Box
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(
                10.0,
              ), //This Padding value should be same as padding in Product Category Section for perfect alignment.
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .center, //This will place the 2 widgets inside 'children' at 2 ends of the screen horizontally.
                  children: [
                    Text(
                      widget.productData.productName, //Displaying Product Name
                      style: GoogleFonts.roboto(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: const Color.fromARGB(255, 63, 63, 63),
                      ),
                    ),

                    Text(
                      widget.productData.category, //Displaying Product Name
                      style: TextStyle(
                        fontSize: 22,
                        // fontWeight: FontWeight.bold,
                        // letterSpacing: 1,
                        color: const Color.fromARGB(255, 65, 62, 62),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 4,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 138, 82),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //SECTION TO DISPLAY PRODUCT NAME AND PRICE
            Padding(
              padding: const EdgeInsets.all(
                10.0,
              ), //This Padding value should be same as padding in Product Category Section for perfect alignment.
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween, //This will place the 2 widgets inside 'children' at 2 ends of the screen horizontally.
                children: [
                  Text(
                    '₹${widget.productData.productPrice}', //Displaying the original product price of our Recommended Product. The second '$' is for concatenating 2 strings.
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                      letterSpacing: 0.3,
                      fontWeight: FontWeight.bold,
                      decoration:
                          TextDecoration
                              .lineThrough, //This will make a struck or cut (by drawing a line in middle) in our Text, because we want to highlight our discounted price and want our customers to notice that and cut our original price like we normally do in our marketing.
                    ),
                  ),

                  widget.productData.rating == 0
                      ? const Text(
                        '',
                      ) //If product rating is 0 then show nothing else show the Row Widget down
                      : Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                        ), //Only giving padding from the left side.
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star, //Star Icon
                              color: Color.fromARGB(255, 234, 141, 3),
                            ),

                            Text(
                              widget.productData.rating
                                  .toString(), //Showing Rating
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                                // color: const Color(0xFF3C55EF),
                              ),
                            ),

                            Text(
                              ' (${widget.productData.totalReviews})', //Showing Total Reviews
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                // letterSpacing: 1,
                                // color: const Color(0xFF3C55EF),
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),

            //SECTION TO DISPLAY PRODUCT CATEGORY
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ), //This Padding value should be same as padding in Product Name and Price Section for perfect alignment.
              child: Text(
                //SUGGESTION: Add Discounted Price as Well in Top beside Original Price or just below it somewhere. //SOLUTION: Added Discounted Price as it will be shown as Customer will pay the Discounted Price Only. SUGGESTION: Add Original Price as well and put a cut like we did in Home Screen Product Tile.
                '₹${widget.productData.discount.toStringAsFixed(2)}', //Displaying Product Price. We are converting to String because 'Text' widget displays String but our price is Integer. 'AsFixed' will create '.00' after the Original Price
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),

            //SECTION TO DISPLAY PRODUCT RATING
            // widget.productData['rating'] == 0
            //     ? const Text(
            //       '',
            //     ) //If product rating is 0 then show nothing else show the Row Widget down
            //     : Padding(
            //       padding: const EdgeInsets.only(
            //         left: 8,
            //       ), //Only giving padding from the left side.
            //       child: Row(
            //         children: [
            //           const Icon(
            //             Icons.star, //Star Icon
            //             color: Color.fromARGB(255, 234, 141, 3),
            //           ),

            //           Text(
            //             widget.productData['rating'].toString(), //Showing Rating
            //             style: const TextStyle(
            //               fontSize: 18,
            //               fontWeight: FontWeight.w500,
            //               letterSpacing: 2,
            //               // color: const Color(0xFF3C55EF),
            //             ),
            //           ),

            //           Text(
            //             ' (${widget.productData['totalReviews']})', //Showing Total Reviews
            //             style: const TextStyle(
            //               fontSize: 17,
            //               fontWeight: FontWeight.w400,
            //               // letterSpacing: 1,
            //               // color: const Color(0xFF3C55EF),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),

            //SECTION TO DISPLAY PRODUCT SIZE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween, //CrossAxisAlignment is for vertical, MainAxisAlignment is for horizontal.
                children: [
                  Text(
                    'Size:',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.6,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),

                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      shrinkWrap:
                          true, //This is VERY IMPORTANT else we will get ERROR.
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          widget
                              .productData
                              .productSize
                              .length, //PROBLEM: In admin panel we can give as many sizes as possible and it will be displayed here but if we want we can remove all the sizes and just put 1 size for each but that will be difficult if we have multiple sizes for a single product.
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(
                            8.0,
                          ), //Padding of each size box, will make the boxes look better shape wise.
                          child: InkWell(
                            //Making it 'InkWell' because the customer should be able to choose the size he/she wants.
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF126881),
                                borderRadius: BorderRadius.circular(5),
                              ),

                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  widget.productData.productSize[index],
                                  style: GoogleFonts.lato(
                                    // fontSize: 16,
                                    // fontWeight: FontWeight.bold,
                                    // letterSpacing: 1.6,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            //SECTION TO DISPLAY PRODUCT DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start, //If this is not there then our About will start moving towards right automatically as our Description Text Increases in length.
                children: [
                  Text(
                    'About:',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Color(0xFF363330),
                    ),
                  ),

                  Text(
                    widget.productData.description,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Color(0xFF363330),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 150),
          ],
        ),
      ),

      //ADD TO CART BUTTON
      //ADD TO CART BUTTON
      bottomSheet: Padding(
        padding: EdgeInsets.all(25), //Padding for the entire button
        child: Row(
          children: [
            // ADD TO CART BUTTON (takes most of the space)
            Expanded(
              flex: 4, // Takes 4/5 of the available space
              child: InkWell(
                onTap: () {
                  //When we click on this button our product will get added to cart
                  cartProviderData.addProductToCart(
                    //Accessing and passing out real time product details to addProductToCart function present in 'cart_provider' page and will add the product accordingly as per our logic mentioned there in if else block there within this function.
                    product: ProductModel(
                      productId: widget.productData.productId,
                      productName: widget.productData.productName,
                      category: widget.productData.category,
                      description: widget.productData.description,
                      productImage: widget.productData.productImage,
                      productSize: widget.productData.productSize,
                      productPrice: widget.productData.productPrice,
                      discount: widget.productData.discount,
                      quantity: widget.productData.quantity,
                      rating: widget.productData.rating,
                      totalReviews: widget.productData.totalReviews,
                      isPopular: widget.productData.isPopular,
                      isRecommended: widget.productData.isRecommended,
                      isSoldOut: widget.productData.isSoldOut,
                      vendorId: widget.productData.vendorId,
                      vendorName: widget.productData.vendorName,
                    ),
                    context: context,
                  );
                },

                child: Container(
                  height: 48,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 252, 187, 84),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'ADD TO CART',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            // letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(width: 10), // Space between buttons
            // FAVORITE BUTTON (takes less space)
            Expanded(
              flex: 1, // Takes 1/5 of the available space
              child: InkWell(
                onTap: () {
                  if (favoriteProviderData.getFavoriteItem.containsKey(
                    widget.productData.productId,
                  )) {
                    // If product is already in favorites, remove it
                    favoriteProviderData.removeProductFromFavorite(
                      widget.productData.productId,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        margin: const EdgeInsets.all(15),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.grey,
                        content: Text(
                          'Removed ${widget.productData.productName} from Wishlist!',
                        ),
                      ),
                    );
                  } else {
                    // If not in favorites, add it
                    favoriteProviderData.addProductToFavorite(
                      productId: widget.productData.productId,
                      productName: widget.productData.productName,
                      category: widget.productData.category,
                      description: widget.productData.description,
                      productImage: widget.productData.productImage,
                      productSize: widget.productData.productSize,
                      productPrice: widget.productData.productPrice,
                      discount: widget.productData.discount,
                      quantity: widget.productData.quantity,
                      rating: widget.productData.rating,
                      totalReviews: widget.productData.totalReviews,
                      isPopular: widget.productData.isPopular,
                      isRecommended: widget.productData.isRecommended,
                      isSoldOut: widget.productData.isSoldOut,
                      vendorId: widget.productData.vendorId,
                      vendorName: widget.productData.vendorName,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        margin: const EdgeInsets.all(15),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.grey,
                        content: Text(
                          'Added ${widget.productData.productName} to Wishlist!',
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 48,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color.fromARGB(255, 252, 187, 84),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Icon(
                      favoriteProviderData.getFavoriteItem.containsKey(
                            widget.productData.productId,
                          )
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
