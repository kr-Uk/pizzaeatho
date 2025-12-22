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
}
