import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/shoppingcart.dart';

class ShoppingcartViewModel with ChangeNotifier {
  static const _storageKey = 'shopping_cart';

  final List<ShoppingcartDto> _items = [];

  List<ShoppingcartDto> get items => _items;

  ShoppingcartViewModel() {
    loadCart();
  }

  Future<void> addItem(ShoppingcartDto item) async {
    _items.add(item);
    notifyListeners();
    await saveCart();
  }

  Future<void> removeItem(int index) async {
    _items.removeAt(index);
    notifyListeners();
    await saveCart();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _items.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_storageKey);

    if (jsonList == null) return;

    _items
      ..clear()
      ..addAll(
        jsonList.map(
              (e) => ShoppingcartDto.fromJson(jsonDecode(e)),
        ),
      );

    notifyListeners();
  }

  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);
}
