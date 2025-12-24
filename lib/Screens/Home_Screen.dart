import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fruits_ecommerce_app/Data_Storage/auth_data.dart';
import 'package:fruits_ecommerce_app/Provider/User_provider.dart';
import 'package:fruits_ecommerce_app/Screens/FoodDetails.dart';
import 'package:fruits_ecommerce_app/Screens/My_Basket.dart';
import 'package:fruits_ecommerce_app/Screens/favorite_screen.dart';
import 'package:fruits_ecommerce_app/Wigets/NonRecommended.dart';
import 'package:fruits_ecommerce_app/Wigets/productcard.dart';
import 'package:fruits_ecommerce_app/Provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
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

  File? _selectedImage;
  String? _webImagePath;
  bool _isRecommendedEntry = true;

  final List<Product> products = [
    Product(
        id: 1,
        title: "Cappuccino",
        imageUrl: "assets/images/f4.png",
        price: 4.99,
        catagoryId: 1,
        isRecommendet: true),
    Product(
        id: 2,
        title: "Fruit Salad",
        imageUrl: "assets/images/f5.png",
        price: 6.99,
        catagoryId: 1,
        isRecommendet: false),
    Product(
        id: 3,
        title: "Green Salad",
        imageUrl: "assets/images/f6.png",
        price: 10.99,
        catagoryId: 2,
        isRecommendet: true),
    Product(
        id: 4,
        title: "Italian Salad",
        imageUrl: "assets/images/f8.png",
        price: 6.99,
        catagoryId: 3,
        isRecommendet: false),
    Product(
        id: 5,
        title: "Caesar Salad",
        imageUrl: "assets/images/f5.png",
        price: 2.99,
        catagoryId: 1,
        isRecommendet: false),
    Product(
        id: 6,
        title: "Caesar Salad",
        imageUrl: "assets/images/f7.png",
        price: 2.99,
        catagoryId: 1,
        isRecommendet: false),
  ];

  List<Product> getRecommended() =>
      products.where((f) => f.isRecommendet).toList();
  List<Product> getNonRecommended() =>
      products.where((f) => !f.isRecommendet).toList();

  @override
  void initState() {
    super.initState();
    filteredProducts = getRecommended();
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = getRecommended()
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _pickImage(StateSetter setDialogState) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setDialogState(() {
        _webImagePath = pickedFile.path;
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    _selectedImage = null;
    _webImagePath = null;
    _isRecommendedEntry = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Add New Fruit Salad"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: "Product Name")),
                TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: "Price"),
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text("Is Recommended?",
                      style: TextStyle(fontSize: 14)),
                  value: _isRecommendedEntry,
                  activeColor: Colors.orange,
                  onChanged: (val) =>
                      setDialogState(() => _isRecommendedEntry = val),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _pickImage(setDialogState),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: (_webImagePath != null || _selectedImage != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: kIsWeb
                                ? Image.network(_webImagePath!,
                                    fit: BoxFit.cover)
                                : Image.file(_selectedImage!,
                                    fit: BoxFit.cover),
                          )
                        : const Icon(Icons.add_a_photo,
                            size: 40, color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    (_webImagePath != null || _selectedImage != null)) {
                  setState(() {
                    products.add(Product(
                      id: products.length + 1,
                      title: nameController.text,
                      imageUrl: kIsWeb ? _webImagePath! : _selectedImage!.path,
                      price: double.tryParse(priceController.text) ?? 0.0,
                      catagoryId: 1,
                      isRecommendet: _isRecommendedEntry,
                    ));
                    filteredProducts = getRecommended();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: _showAddProductDialog,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFFFA451)),
                accountName: Text(AuthData.firstName ?? "Guest User",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                accountEmail: Text(AuthData.email ?? "No email"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                      AuthData.firstName != null
                          ? AuthData.firstName![0].toUpperCase()
                          : "U",
                      style: const TextStyle(
                          color: Color(0xFFFFA451),
                          fontWeight: FontWeight.bold,
                          fontSize: 24)),
                ),
              ),
              ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: () => Navigator.pop(context)),
              ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text("My Orders"),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BasketScreen()))),
              ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text("Favorites"),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavoriteScreen()))),
              const Spacer(),
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                        icon: const Icon(Icons.sort, size: 40)),
                    Row(
                      children: [
                        Column(children: [
                          IconButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FavoriteScreen())),
                              icon: const Icon(Icons.favorite,
                                  color: Colors.orange, size: 30)),
                          const Text("Fav")
                        ]),
                        const SizedBox(width: 10),
                        Column(children: [
                          IconButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BasketScreen())),
                              icon: const Icon(Icons.shopping_basket,
                                  color: Colors.orange, size: 30)),
                          const Text("My basket")
                        ]),
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
                            fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: filterProducts,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 230, 229, 229),
                          hintText: "Search for fruit salad combos",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.tune, size: 40)),
                  ],
                ),
                const SizedBox(height: 26),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Recommended Combo?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                const SizedBox(height: 20),
                Flexible(
                  child: GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3 / 4),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FoodDetails(product: product))),
                        child: ProductCard(
                          product: product,
                          isFavorite: favoriteProvider.isFavorite(product),
                          onFavoritePressed: () =>
                              favoriteProvider.toggleFavorite(product),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const TabBar(
                  isScrollable: true,
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.orange,
                  tabs: [
                    Tab(text: "Hottest"),
                    Tab(text: "Popular"),
                    Tab(text: "New combo"),
                    Tab(text: "Top")
                  ],
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: TabBarView(
                    children: [
                      NonRecommendedGrid(products: getNonRecommended()),
                      NonRecommendedGrid(products: getRecommended()),
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
