import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fruits_ecommerce_app/Data_Storage/auth_data.dart';
import 'package:fruits_ecommerce_app/Provider/User_provider.dart';
import 'package:fruits_ecommerce_app/Screens/FoodDetails.dart';
import 'package:fruits_ecommerce_app/Screens/My_Basket.dart';
import 'package:fruits_ecommerce_app/Screens/favorite_screen.dart';
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

  // প্রোডাক্ট রিমুভ করার ফাংশন
  void _removeProduct(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure you want to remove this item?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                products.removeWhere((p) => p.id == id);
                filteredProducts = getRecommended();
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = getRecommended()
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // ইমেজ এরর ফিক্স করতে Uri.decodeFull ব্যবহার করা হয়েছে
  Future<void> _pickImage(StateSetter setDialogState) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setDialogState(() {
        _webImagePath =
            kIsWeb ? Uri.decodeFull(pickedFile.path) : pickedFile.path;
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
                      id: DateTime.now().millisecondsSinceEpoch,
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
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: _showAddProductDialog,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        drawer: _buildDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 20),
                  Text(
                    "Hello ${userProvider.username},\nWhat fruit salad combo do you want today?",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 30),
                  const Text("Recommended Combo",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // Recommended Combo (Horizontal Scroll)
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 15),
                          child: GestureDetector(
                            onLongPress: () => _removeProduct(product.id),
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
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 25),
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
                  const SizedBox(height: 15),

                  // Tab কন্টেন্ট সেকশন (হাইট কমানো হয়েছে)
                  SizedBox(
                    height: 260, // আপনার ছবির মতো ছোট কন্টেইনার
                    child: TabBarView(
                      children: [
                        _buildTabGrid(getNonRecommended()),
                        _buildTabGrid(getRecommended()),
                        _buildTabGrid(getNonRecommended()),
                        _buildTabGrid(getNonRecommended()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ট্যাব এর ভেতর গ্রিড এবং ক্লিক ইভেন্ট হ্যান্ডল করার ফাংশন
  Widget _buildTabGrid(List<Product> tabProducts) {
  final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
  
  return ListView.builder(
    scrollDirection: Axis.horizontal, // পাশাপাশি স্ক্রল করার জন্য
    itemCount: tabProducts.length,
    itemBuilder: (context, index) {
      final product = tabProducts[index];
      return Container(
        width: 160, // প্রতিটি কার্ডের প্রস্থ
        margin: const EdgeInsets.only(right: 15),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => FoodDetails(product: product))
          ),
          onLongPress: () => _removeProduct(product.id),
          child: ProductCard(
            product: product,
            isFavorite: favoriteProvider.isFavorite(product),
            onFavoritePressed: () => favoriteProvider.toggleFavorite(product),
          ),
        ),
      );
    },
  );
}

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.sort, size: 40)),
        Row(
          children: [
            _topIcon(
                Icons.favorite,
                "Fav",
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavoriteScreen()))),
            const SizedBox(width: 15),
            _topIcon(
                Icons.shopping_basket,
                "My basket",
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BasketScreen()))),
          ],
        ),
      ],
    );
  }

  Widget _topIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(children: [
        Icon(icon, color: Colors.orange, size: 30),
        Text(label, style: const TextStyle(fontSize: 12))
      ]),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            onChanged: filterProducts,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF3F4F9),
              hintText: "Search for fruit salad combos",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: const Color(0xFFF3F4F9),
              borderRadius: BorderRadius.circular(15)),
          child: const Icon(Icons.tune, color: Colors.black54),
        )
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFFFA451)),
            accountName: Text(AuthData.firstName ?? "User",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(AuthData.email ?? ""),
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
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoriteScreen()))),
          const Spacer(),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
