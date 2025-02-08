import 'package:flutter/material.dart';
import 'package:products_list/data/model/products_model.dart';
import 'package:products_list/data/repositories/api_service.dart';
import 'package:products_list/presentation/widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ApiService api = ApiService();
  List<Product> products = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  int? totalPages;

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch initial products
  }

  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (isLoadMore) {
      setState(() {
        isLoadingMore = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }

    try {
      print("Current page: $currentPage");
      final response = await api.fetchProducts(
        page: currentPage,
      );
      setState(() {
        totalPages = response.data.pagination.totalPages;
        if (isLoadMore) {
          products.addAll(response.data.products); // Append new products
        } else {
          products = response.data.products; // Reset product list
        }
        totalPages = response.data.pagination.totalPages;
      });
    } catch (e) {
      print("Error: ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  void loadMore() {
    if (currentPage < totalPages!) {
      setState(() {
        currentPage++;
      });
      fetchProducts(isLoadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vegetables & Fruits"),
        backgroundColor: const Color.fromARGB(255, 248, 230, 198),
        leading: const Icon(Icons.arrow_back_ios_rounded),
        actions: const [
          Icon(Icons.search),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  if (scrollEnd.metrics.pixels ==
                      scrollEnd.metrics.maxScrollExtent) {
                    loadMore();
                    // Load more when user reaches bottom
                  }
                  return false;
                },
                child: GridView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: ProductCard(prod: product),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 5,
                      childAspectRatio: 9 / 12),
                ),
              ),
            ),
          if (isLoadingMore)
            const CircularProgressIndicator(), // Show loading at bottom
        ],
      ),
    );
  }
}
