import 'package:http/http.dart' as http;
import 'package:products_list/data/model/products_model.dart';

class ApiService {
  static const String baseUrl =
      "https://alpha.bytesdelivery.com/api/v3/product/category-products"; // base url

  Future<ProductResponse> fetchProducts(
      {String? categoryId, int? page, int? value}) async {
    try {
      categoryId = categoryId;
      value = null;
      String url = "$baseUrl/$value/$categoryId/$page";
      print(url);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return ProductResponse.fromJson(response.body);
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<ProductResponse> fetchCategories() async {
    try {
      const String baseUrl =
          "https://alpha.bytesdelivery.com/api/v3/product/category-products/:value/null/:page";
      String url = baseUrl;

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return ProductResponse.fromJson(response.body);
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
