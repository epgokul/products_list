import 'package:flutter/material.dart';
import 'package:products_list/data/model/products_model.dart';

class ProductCard extends StatelessWidget {
  final Product prod;
  const ProductCard({super.key, required this.prod});

  @override
  Widget build(BuildContext context) {
    int discount = prod.discountPrice;

    int price = prod.price;
    int originalprice = price - discount;
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Image.network(
                    prod.images[0].url,
                    width: MediaQuery.sizeOf(context).width,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2, color: Colors.green),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Text(
                      "ADD",
                      style: TextStyle(color: Colors.green),
                    )))
          ]),
          const SizedBox(
            height: 10,
          ),
          Text(
            prod.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FittedBox(
              child: Row(
            children: [
              Text(
                '₹$originalprice',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                width: 5,
              ),
              const Text('MRP '),
              Text(
                '₹$price',
                style: const TextStyle(decoration: TextDecoration.lineThrough),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
