import 'package:flutter/cupertino.dart';
import 'package:pizzaeatho/data/model/shoppingcart.dart';

class ShoppingcartViewModel with ChangeNotifier {
  final List<ShoppingcartDto> _items = [];

  List<ShoppingcartDto> get items => _items;

  void addItem(ShoppingcartDto item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);
}
