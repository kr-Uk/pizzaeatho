// 피자 메뉴
class ProductDto {
  final int productId;
  final String image;
  final String name;
  final String description;
  final int price;

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

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'description': description,
    'price': price,
    'image': image,
  };
}

// 기본 토핑
class DefaultTopping {
  final List<int> defaultTopping;

  DefaultTopping({
    required this.defaultTopping,
  });

  factory DefaultTopping.fromJson(Map<String, dynamic> json) {
    return DefaultTopping(
      defaultTopping:
      List<int>.from(json['toppingId'] as List),
    );
  }
}


// 토핑
class ToppingDto {
  final int toppingId;
  final String image;
  final String name;
  final int price;

  ToppingDto({
    required this.toppingId,
    required this.name,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
    'toppingId': toppingId,
    'name': name,
    'price': price,
    'image' : image
  };

  factory ToppingDto.fromJson(Map<String, dynamic> json) {
    return ToppingDto(
      toppingId: (json['toppingId'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      image: json['image'] as String,
    );
  }
}

// 도우
class DoughDto {
  final int doughId;
  final String name;
  final int price;
  final String image;


  DoughDto({
    required this.doughId,
    required this.name,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
    'doughId': doughId,
    'name': name,
    'price': price,
    'image' : image
  };

  factory DoughDto.fromJson(Map<String, dynamic> json) {
    return DoughDto(
      doughId: (json['doughId'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      image: json['image'] as String,
    );
  }
}

// 크러스트
class CrustDto {
  final int crustId;
  final String name;
  final int price;
  final String image;

  CrustDto({
    required this.crustId,
    required this.name,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
    'crustId': crustId,
    'name': name,
    'price': price,
    'image' : image
  };

  factory CrustDto.fromJson(Map<String, dynamic> json) {
    return CrustDto(
      crustId: (json['crustId'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      image: json['image'] as String,
    );
  }
}
