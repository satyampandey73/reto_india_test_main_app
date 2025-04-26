
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reto_app/models/product_model.dart';
import 'package:reto_app/provider/product_provider.dart';
import 'package:reto_app/views/screens/authentication_screens/login_screen.dart';
import 'package:reto_app/views/screens/inner_screens/shipping_address_screen.dart';
import 'package:reto_app/views/screens/nav_screens/reuseable_text_widget.dart';
import 'package:reto_app/views/screens/nav_screens/widgets/animated_text_widget.dart';
import 'package:reto_app/views/screens/nav_screens/widgets/banner_widget.dart';
import 'package:reto_app/views/screens/nav_screens/widgets/category_item.dart';
import 'package:reto_app/views/screens/nav_screens/widgets/icon_widget.dart';
import 'package:reto_app/views/screens/nav_screens/widgets/marqueetext.dart';
import 'package:reto_app/views/screens/nav_screens/widgets/popular_product_widget.dart';
import 'package:reto_app/views/screens/nav_screens/widgets/recommended_product_widget.dart';
import 'package:reto_app/views/screens/nav_screens/widgets/scrollintextwidget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).fetchAllProducts();
    });
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    if (_searchQuery.isEmpty) return products;
    return products
        .where(
          (product) => product.productName.toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(1);
    final productState = ref.watch(productProvider);
    final recommendedProducts = _filterProducts(
      ref.read(productProvider.notifier).getRecommendedProducts(),
    );
    final popularProducts = _filterProducts(
      ref.read(productProvider.notifier).getPopularProducts(),
    );
    // print("Recommended: $recommendedProducts");
    // print("Popular: $popularProducts");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 17),
          child: Container(
            width: 350,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE3C5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _searchQuery = '';
                            _searchFocusNode.unfocus();
                            setState(() {});
                          },
                        )
                        : null,
                border: InputBorder.none,
                hintText: 'Search Products',
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShippingAddressScreen(),
                ),
              );
            },
            child: StreamBuilder<DocumentSnapshot>(
              stream:
                  _auth.currentUser != null
                      ? FirebaseFirestore.instance
                          .collection("customers")
                          .doc(_auth.currentUser!.uid)
                          .snapshots()
                      : null,
              builder: (context, snapshot) {
                if (_auth.currentUser == null) {
                  return SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    LoginScreen(), // Replace with your Sign In screen widget
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // Set background color to white
                        elevation: 0, // Remove shadow
                        minimumSize: Size.zero, // Remove minimum size
                        padding: EdgeInsets.zero, // Remove padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // Optional: Rounded corners
                          side: BorderSide.none, // No border
                        ),
                      ),
                      child: Text(
                        "Sign In & Explore",
                        style: TextStyle(
                          color: Colors.black, // Set text color to black
                          fontSize: 22,
                          fontFamily:
                              GoogleFonts.raleway()
                                  .fontFamily, // Optional: Adjust font size
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    "Loading...",
                    style: TextStyle(
                      color: Colors.black, // Set text color to black
                      fontSize: 22,
                      fontFamily:
                          GoogleFonts.raleway()
                              .fontFamily, // Optional: Adjust font size
                    ),
                  );
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text(
                    "Add Shipping Address",
                    style: TextStyle(
                      color: Colors.black, // Set text color to black
                      fontSize: 22,
                      fontFamily:
                          GoogleFonts.raleway()
                              .fontFamily, // Optional: Adjust font size
                    ),
                  );
                }
                return Text(
                  "${snapshot.data!["name"]} - ${snapshot.data!["city"]} ${snapshot.data!["pinCode"]}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 42, 42, 42),
                    fontFamily: GoogleFonts.notoSansMahajani().fontFamily,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFE3C5),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Column(
            children: [
              const IconWidget(),
              const CategoryItem(),
              const Scrollintextwidget(),
              const BannerWidget(),
              const ReuseableTextWidget(title: 'Recommended For You'),
              RecommendedProductWidget(
                key: ValueKey('recommended-${recommendedProducts.hashCode}'),
                recommendedProducts: recommendedProducts,
              ),
              const ReuseableTextWidget(title: 'Popular Products'),
              PopularProductWidget(
                key: ValueKey('popular-${popularProducts.hashCode}'),
                popularProducts: popularProducts,
              ),
              const SizedBox(height: 20),
              // const AnimatedTextWidget(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
