import 'package:flutter/cupertino.dart';
import 'package:pizzaeatho/data/model/product.dart';

import '../../data/repository/product_repository.dart';

class OrderViewModel with ChangeNotifier {
  late final ProductRepository _productRepository;

  List<ProductDto> get products => _products;
  List<ProductDto> _products = [];

  OrderViewModel() {
    _productRepository = ProductRepository();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    _products = await _productRepository.getProducts();
    notifyListeners();
  }
  
}