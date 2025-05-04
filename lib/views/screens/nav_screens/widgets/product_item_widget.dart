// // //This page will create the product design which will appear in tiles in Home Screen.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reto_app/models/product_model.dart';
import 'package:reto_app/provider/cart_provider.dart';
import 'package:reto_app/provider/favorite_provider.dart';
import 'package:reto_app/views/screens/inner_screens/product_detail_screen.dart';

class ProductItemWidget extends ConsumerStatefulWidget {
  final ProductModel productData;

  const ProductItemWidget({super.key, required this.productData});

  @override
  _ProductItemWidgetState createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends ConsumerState<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider.notifier);
    final favoriteProviderData = ref.read(favoriteProvider.notifier);

    ref.watch(favoriteProvider);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductDetailScreen(productData: widget.productData);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ), // Increased padding for better spacing
        child: Container(
          width: 160, // Increased width
          height: 270, // Increased height
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 254, 245, 245),
            borderRadius: BorderRadius.circular(8), // Slightly rounded corners
            boxShadow: const [
              BoxShadow(
                color: Color(0x0f040828),
                spreadRadius: 0,
                offset: Offset(0, 10),
                blurRadius: 20,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Product Image
              Positioned(
                left: 16,
                top: 10,
                child: Container(
                  width: 128,
                  height: 128,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.productData.productImage[0],
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Product Name
              Positioned(
                left: 10,
                top: 150,
                child: Text(
                  widget.productData.productName,
                  style: GoogleFonts.alegreyaSansSc(
                    color: const Color(0xFF1E3354),
                    fontSize: 18, // Increased font size
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // Product Category
              Positioned(
                left: 10,
                top: 180,
                child: Text(
                  widget.productData.category,
                  style: GoogleFonts.happyMonkey(
                    color: const Color(0xFF7F8E9D),
                    fontSize: 14, // Increased font size
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              // Discounted Price
              Positioned(
                left: 10,
                top: 210,
                child: Text(
                  '₹${widget.productData.discount}',
                  style: GoogleFonts.wixMadeforDisplay(
                    color: const Color(0xFF1E3354),
                    fontSize: 20, // Increased font size
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // Original Price
              Positioned(
                left: 90,
                top: 215,
                child: Text(
                  '₹${widget.productData.productPrice}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    letterSpacing: 0.3,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),

              // Sold Count
              Positioned(
                left: 100,
                top: 160,
                child: Text(
                  widget.productData.totalReviews == 0
                      ? ''
                      : 'SOLD: ${widget.productData.totalReviews}',
                  style: GoogleFonts.lato(
                    color: const Color(0xFF7F8E9D),
                    fontSize: 12,
                  ),
                ),
              ),

              // Rating
              Positioned(
                left: 20,
                top: 160,
                child: Row(
                  children: [
                    if (widget.productData.rating != 0)
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                    if (widget.productData.rating != 0)
                      const SizedBox(width: 4),
                    Text(
                      widget.productData.rating == 0
                          ? ''
                          : widget.productData.rating.toString(),
                      style: GoogleFonts.lato(
                        color: const Color(0xFF7F8E9D),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Wishlist Button
              Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                  onPressed: () {
                    if (favoriteProviderData.getFavoriteItem.containsKey(
                      widget.productData.productId,
                    )) {
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
                  icon:
                      favoriteProviderData.getFavoriteItem.containsKey(
                            widget.productData.productId,
                          )
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
