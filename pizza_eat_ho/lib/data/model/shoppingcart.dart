import 'package:pizzaeatho/data/model/product.dart';

class ShoppingcartDto {
  final ProductDto product;
  final DoughDto dough;
  final CrustDto crust;
  final List<ToppingDto> toppings;
  final int quantity;
  final int totalPrice;

  ShoppingcartDto({
    required this.product,
    required this.dough,
    required this.crust,
    required this.toppings,
    required this.quantity,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'dough': dough.toJson(),
    'crust': crust.toJson(),
    'toppings': toppings.map((e) => e.toJson()).toList(),
    'quantity': quantity,
    'totalPrice': totalPrice,
  };

  factory ShoppingcartDto.fromJson(Map<String, dynamic> json) {
    return ShoppingcartDto(
      product: ProductDto.fromJson(json['product']),
      dough: DoughDto.fromJson(json['dough']),
      crust: CrustDto.fromJson(json['crust']),
      toppings: (json['toppings'] as List)
          .map((e) => ToppingDto.fromJson(e))
          .toList(),
      quantity: json['quantity'],
      totalPrice: json['totalPrice'],
    );
  }
}
