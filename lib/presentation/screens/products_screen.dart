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
  String? currentId;
  int? totalPages;
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchProducts();
    // Fetch initial products
  }

  Future<void> fetchCategories() async {
    try {
      final response = await api.fetchCategories();
      var cat = response.data.categories;
      setState(() {
        for (var element in cat) {
          categories.add(element);
        }
        debugPrint(categories.toString());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> fetchProducts(
      {bool isLoadMore = false, String? categoryid}) async {
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
      debugPrint("Current page: $currentPage");
      final response =
          await api.fetchProducts(page: currentPage, categoryId: categoryid);
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
      debugPrint("Error: ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  void resetFields() {
    setState(() {
      currentPage = 1;
    });
    print("Page reset to $currentPage");
  }

  void loadMore() {
    if (currentPage < totalPages!) {
      setState(() {
        currentPage++;
      });
      fetchProducts(isLoadMore: true, categoryid: currentId);
    }
  }

  int? selectedCategoryId;

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
        body: Row(
          children: [
            SizedBox(
              width: 100,
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategoryId = index;
                                      currentId = categories[index].id;
                                      currentPage = 1; // Reset page number to 1
                                      products
                                          .clear(); // Clear existing products before loading new ones
                                    });

                                    fetchProducts(categoryid: currentId);
                                    resetFields();
                                  },
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100))),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.network(
                                      categories[index].image,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                Text(categories[index].title)
                              ],
                            ),
                            selectedCategoryId == index
                                ? Container(
                                    height: 100,
                                    width: 10,
                                    decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20))),
                                  )
                                : Container(
                                    color: Colors.transparent,
                                  )
                          ],
                        );
                      },
                      itemCount: categories.length,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                  childAspectRatio: 9 / 14),
                        ),
                      ),
                    ),
                  if (isLoadingMore) const CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ));
  }
}
