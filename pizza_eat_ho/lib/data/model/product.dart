class ProductDto {
  final int productId;
  final String name;
  final String description;
  final int price;
  final String image;

  ProductDto({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.image
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      productId: (json['productId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
      image: json['image'] as String,
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
  final int price;

  DoughDto({
    required this.doughId,
    required this.name,
    required this.price,
  });

  factory DoughDto.fromJson(Map<String, dynamic> json) {
    return DoughDto(
      doughId: (json['doughId'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
    );
  }
}

class CrustDto {
  final int crustId;
  final String name;
  final int price;

  CrustDto({
    required this.crustId,
    required this.name,
    required this.price,
  });

  factory CrustDto.fromJson(Map<String, dynamic> json) {
    return CrustDto(
      crustId: (json['crustId'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
    );
  }
}
