import 'dart:convert';

class ProductResponse {
  final bool success;
  final ProductData data;
  final String msg;

  ProductResponse({
    required this.success,
    required this.data,
    required this.msg,
  });

  factory ProductResponse.fromJson(String str) =>
      ProductResponse.fromMap(json.decode(str));

  factory ProductResponse.fromMap(Map<String, dynamic> json) => ProductResponse(
        success: json["success"] ?? false,
        data: ProductData.fromMap(json["data"]),
        msg: json["msg"] ?? "",
      );
}

class ProductData {
  final String title;
  final String status;
  final List<Product> products;
  final Pagination pagination;
  final List<Category> categories;

  ProductData({
    required this.title,
    required this.status,
    required this.products,
    required this.pagination,
    required this.categories,
  });

  factory ProductData.fromMap(Map<String, dynamic> json) => ProductData(
        title: json["title"] ?? "",
        status: json["status"] ?? "",
        products:
            List<Product>.from(json["products"].map((x) => Product.fromMap(x))),
        pagination: Pagination.fromMap(json["pagination"]),
        categories: json["categories"] != null
            ? List<Category>.from(
                json["categories"].map((x) => Category.fromMap(x)))
            : [], // Handle if null
      );
}

class Category {
  final String id;
  final String title;
  final String image;
  final bool isSelected;

  Category({
    required this.id,
    required this.title,
    required this.image,
    required this.isSelected,
  });

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        image: json["image"] ?? "",
        isSelected: json["isSelected"] ?? false,
      );
}

class Product {
  final String id;
  final String title;
  final int price;
  final int discountPrice;
  final int quantity;
  final int maxQuantity;
  final String type;
  final bool status;
  final String statusText;
  final List<ProductImage> images;
  final List<Choice>? choices;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.discountPrice,
    required this.quantity,
    required this.maxQuantity,
    required this.type,
    required this.status,
    required this.statusText,
    required this.images,
    this.choices,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        price: json["price"] ?? 0,
        discountPrice: json["discountPrice"] ?? 0,
        quantity: json["quantity"] ?? 0,
        maxQuantity: json["maxQuantity"] ?? 0,
        type: json["type"] ?? "",
        status: json["status"] ?? false,
        statusText: json["statusText"] ?? "",
        images: List<ProductImage>.from(
            json["image"].map((x) => ProductImage.fromMap(x))),
        choices: json["choice"] != null
            ? List<Choice>.from(json["choice"].map((x) => Choice.fromMap(x)))
            : null,
      );
}

class ProductImage {
  final String url;

  ProductImage({required this.url});

  factory ProductImage.fromMap(Map<String, dynamic> json) =>
      ProductImage(url: json["url"] ?? "");
}

class Choice {
  final String id;
  final String type;
  final String description;
  final List<ChoiceItem> list;

  Choice({
    required this.id,
    required this.type,
    required this.description,
    required this.list,
  });

  factory Choice.fromMap(Map<String, dynamic> json) => Choice(
        id: json["id"] ?? "",
        type: json["type"] ?? "",
        description: json["des"] ?? "",
        list: List<ChoiceItem>.from(
            json["list"].map((x) => ChoiceItem.fromMap(x))),
      );
}

class ChoiceItem {
  final String id;
  final String title;
  final String description;
  final int price;
  final bool isActive;
  final bool isSelected;

  ChoiceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.isActive,
    required this.isSelected,
  });

  factory ChoiceItem.fromMap(Map<String, dynamic> json) => ChoiceItem(
        id: json["id"] ?? "",
        title: json["title"] ?? "",
        description: json["des"] ?? "",
        price: json["price"] ?? 0,
        isActive: json["isActive"] ?? false,
        isSelected: json["isSelected"] ?? false,
      );
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory Pagination.fromMap(Map<String, dynamic> json) => Pagination(
        currentPage: json["currentPage"] ?? 1,
        totalPages: json["totalPages"] ?? 1,
        totalItems: json["totalItems"] ?? 0,
        itemsPerPage: json["itemsPerPage"] ?? 10,
      );
}
