import 'package:http/http.dart' as http;
import 'package:products_list/data/model/products_model.dart';

class ApiService {
  static const String baseUrl =
      "https://alpha.bytesdelivery.com/api/v3/product/category-products"; // base url

  Future<ProductResponse> fetchProducts(
      {int? categoryId, int? page, int? value}) async {
    try {
      categoryId = 123;

      value = 122;
      String url = "$baseUrl/$value/$categoryId/$page";

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
