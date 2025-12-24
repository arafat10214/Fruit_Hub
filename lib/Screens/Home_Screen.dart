import 'package:flutter/material.dart';
import 'package:fruits_ecommerce_app/Data_Storage/auth_data.dart';
import 'package:fruits_ecommerce_app/Provider/User_provider.dart';
import 'package:fruits_ecommerce_app/Screens/FoodDetails.dart';
import 'package:fruits_ecommerce_app/Screens/Login_screen.dart';
import 'package:fruits_ecommerce_app/Screens/basket_screen.dart';
import 'package:fruits_ecommerce_app/Screens/favorite_screen.dart';
import 'package:fruits_ecommerce_app/Wigets/NonRecommended.dart';
import 'package:fruits_ecommerce_app/Wigets/productcard.dart';
import 'package:fruits_ecommerce_app/Provider/provider.dart';
import 'package:provider/provider.dart';
import '../Model_class/product.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); 
  
  TextEditingController searchController = TextEditingController();
  List<Product> filteredProducts = [];

  final List<Product> products = [
    Product(
      id: 1,
      title: "Cappuccino",
      imageUrl: "assets/images/f4.png",
      price: 4.99,
      catagoryId: 1,
      isRecommendet: true,
    ),
    Product(
      id: 2,
      title: "Fruit Salad",
      imageUrl: "assets/images/f5.png",
      price: 6.99,
      catagoryId: 1,
      isRecommendet: false,
    ),
    Product(
      id: 3,
      title: "Green Salad",
      imageUrl: "assets/images/f6.png",
      price: 10.99,
      catagoryId: 2,
      isRecommendet: true,
    ),
    Product(
      id: 4,
      title: "Italian Salad",
      imageUrl: "assets/images/f8.png",
      price: 6.99,
      catagoryId: 3,
      isRecommendet: false,
    ),
    Product(
      id: 5,
      title: "Caesar Salad",
      imageUrl: "assets/images/f5.png",
      price: 2.99,
      catagoryId: 1,
      isRecommendet: false,
    ),
    Product(
      id: 6,
      title: "Caesar Salad",
      imageUrl: "assets/images/f7.png",
      price: 2.99,
      catagoryId: 1,
      isRecommendet: false,
    ),
  ];

  List<Product> getRecommended() {
    return products.where((f) => f.isRecommendet).toList();
  }

  List<Product> getNonRecommended() {
    return products.where((f) => !f.isRecommendet).toList();
  }

  @override
  void initState() {
    super.initState();
    filteredProducts = getRecommended(); // initially show recommended
  }

  void filterProducts(String query) {
    final recommended = getRecommended();
    final results = recommended
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final recomendetProducts = getRecommended();
    final nonRecomendetProducts = getNonRecommended();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
      /// ☰ Side Menu Drawer
      drawer: Drawer(
        child: Column(
          children: [
            /// Top Header (Name + Email)
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFFFA451),
              ),
              accountName: Text(
                AuthData.firstName ?? "Guest User",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                AuthData.email ?? "No email",
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  (AuthData.firstName != null &&
                          AuthData.firstName!.isNotEmpty)
                      ? AuthData.firstName![0].toUpperCase()
                      : "U",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFA451),
                  ),
                ),
              ),
            ),

            /// Menu Items
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("My Orders"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> BasketScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> FavoriteScreen()));
              },
            ),
            const Spacer(),

            /// Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen())); // back to login
              },
            ),
          ],
        ),
      ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      icon: Icon(Icons.sort, size: 40),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FavoriteScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.favorite,
                                  color: Colors.orange, size: 30),
                            ),
                            const Text("Fav"),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BasketScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.shopping_basket,
                                  color: Colors.orange, size: 30),
                            ),
                            const Text("My basket"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Hello ${userProvider.username}, What fruit salad \ncombo do you want today?",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: filterProducts,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Color.fromARGB(255, 230, 229, 229),
                          hintText: "Search for fruit salad combos",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 100, 99, 99),
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.tune, size: 40),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recommended Combo?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 26),
                // Filtered recommended products with clickable card
                Flexible(
                  child: GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3 / 4,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      final isFav = favoriteProvider.isFavorite(product);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FoodDetails(product: product),
                            ),
                          );
                        },
                        child: ProductCard(
                          product: product,
                          isFavorite: isFav,
                          onFavoritePressed: () {
                            favoriteProvider.toggleFavorite(product);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TabBar(
                  isScrollable: true,
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.orange,
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: "Hottest"),
                    Tab(text: "Popular"),
                    Tab(text: "New combo"),
                    Tab(text: "Top"),
                  ],
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 4.0,
                      color: Colors.deepOrange,
                    ),
                    insets: EdgeInsets.only(left: 0, right: 20),
                  ),
                ),
                const SizedBox(height: 6),
                // Non-recommended products tabs
                Expanded(
                  child: TabBarView(
                    children: [
                      NonRecommendedGrid(products: getNonRecommended()),
                      NonRecommendedGrid(products: recomendetProducts),
                      NonRecommendedGrid(products: getNonRecommended()),
                      NonRecommendedGrid(products: getNonRecommended()),
                    ],
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
