import 'package:flutter/cupertino.dart';
import 'package:pizzaeatho/data/model/product.dart';
import '../../data/repository/product_repository.dart';

class OrderDetailViewModel with ChangeNotifier {
  late final ProductRepository _productRepository;

  // 목록들
  List<ToppingDto> _toppings = [];
  List<DoughDto> _doughs = [];
  List<CrustDto> _crusts = [];

  // Getter
  List<ToppingDto> get toppings => _toppings;
  List<DoughDto> get doughs => _doughs;
  List<CrustDto> get crusts => _crusts;

  // 선택된 목록들
  DoughDto? selectedDough;
  CrustDto? selectedCrust;
  Set<int> selectedToppingIds = {};

  OrderDetailViewModel() {
    _productRepository = ProductRepository();
    _loadToppings();
    _loadDoughs();
    _loadCrusts();
  }

  // 데이터 갖고오기
  Future<void> _loadToppings() async {
    _toppings = await _productRepository.getToppings();
    notifyListeners();
  }

  Future<void> _loadDoughs() async {
    _doughs = await _productRepository.getDoughs();
    notifyListeners();
  }

  Future<void> _loadCrusts() async {
    _crusts = await _productRepository.getCrusts();
    notifyListeners();
  }

  // 누르면 선택 바꾸기
  void selectDough(DoughDto dough) {
    selectedDough = dough;
    notifyListeners();
  }

  void selectCrust(CrustDto crust) {
    selectedCrust = crust;
    notifyListeners();
  }

  // 토핑 -> 중복 ,, 있으면 삭제 없으면 추가
  void toggleTopping(int toppingId) {
    if (selectedToppingIds.contains(toppingId)) {
      selectedToppingIds.remove(toppingId);
    } else {
      selectedToppingIds.add(toppingId);
    }
    notifyListeners();
  }

  // 총 가격 계산
  int totalPrice(int basePrice) {
    final doughPrice = selectedDough?.price ?? 0;
    final crustPrice = selectedCrust?.price ?? 0;

    final toppingsPrice = _toppings
        .where((t) => selectedToppingIds.contains(t.toppingId))
        .fold(0, (sum, t) => sum + t.price);

    return basePrice + doughPrice + crustPrice + toppingsPrice;
  }

  // 도우랑 크러스트 둘 다 선택해 !!
  bool get isOptionValid => selectedDough != null && selectedCrust != null;

  // 나갈 때 리셋 해야겟지?
  // void reset() {
  //   selectedDough = null;
  //   selectedCrust = null;
  //   selectedToppingIds.clear();
  //   notifyListeners();
  // }
}
