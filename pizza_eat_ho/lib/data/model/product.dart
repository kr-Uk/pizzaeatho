class ProductDto {
  final int productId;
  final String name;
  final int basePrice;

  ProductDto({
    required this.productId,
    required this.name,
    required this.basePrice,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      productId: (json['productId'] as num).toInt(),
      name: json['name'] as String,
      basePrice: (json['basePrice'] as num).toInt(),
    );
  }
}

class ToppingDto {
  final int toppingId;
  final String name;
  final int price;

  ToppingDto({
    required this.toppingId,
    required this.name,
    required this.price,
  });

  factory ToppingDto.fromJson(Map<String, dynamic> json) {
    return ToppingDto(
      toppingId: (json['toppingId'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
    );
  }
}

class DoughDto {
  final int doughId;
  final String name;
  final int extraPrice;

  DoughDto({
    required this.doughId,
    required this.name,
    required this.extraPrice,
  });

  factory DoughDto.fromJson(Map<String, dynamic> json) {
    return DoughDto(
      doughId: (json['doughId'] as num).toInt(),
      name: json['name'] as String,
      extraPrice: (json['extraPrice'] as num).toInt(),
    );
  }
}

class CrustDto {
  final int crustId;
  final String name;
  final int extraPrice;

  CrustDto({
    required this.crustId,
    required this.name,
    required this.extraPrice,
  });

  factory CrustDto.fromJson(Map<String, dynamic> json) {
    return CrustDto(
      crustId: (json['crustId'] as num).toInt(),
      name: json['name'] as String,
      extraPrice: (json['extraPrice'] as num).toInt(),
    );
  }
}
