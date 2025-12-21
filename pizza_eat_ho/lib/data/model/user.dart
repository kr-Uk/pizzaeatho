class UserSignupRequestDto {
  final String id;
  final String pw;
  final String name;

  UserSignupRequestDto({
    required this.id,
    required this.pw,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'pw': pw,
    'name': name,
  };
}

class UserSignupResponseDto {
  final int userId;
  final String id;
  final String name;
  final int stamp;

  UserSignupResponseDto({
    required this.userId,
    required this.id,
    required this.name,
    required this.stamp,
  });

  factory UserSignupResponseDto.fromJson(Map<String, dynamic> json) {
    return UserSignupResponseDto(
      userId: (json['userId'] as num).toInt(),
      id: json['id'] as String,
      name: json['name'] as String,
      stamp: (json['stamp'] as num).toInt(),
    );
  }
}

class UserLoginRequestDto {
  final String id;
  final String pw;

  UserLoginRequestDto({
    required this.id,
    required this.pw,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'pw': pw,
  };
}

class UserLoginResponseDto {
  final int userId;
  final String name;
  final int stamp;

  UserLoginResponseDto({
    required this.userId,
    required this.name,
    required this.stamp,
  });

  factory UserLoginResponseDto.fromJson(Map<String, dynamic> json) {
    return UserLoginResponseDto(
      userId: (json['userId'] as num).toInt(),
      name: json['name'] as String,
      stamp: (json['stamp'] as num).toInt(),
    );
  }
}

class UserInfoResponseDto {
  final int userId;
  final String id;
  final String name;
  final int stamp;

  UserInfoResponseDto({
    required this.userId,
    required this.id,
    required this.name,
    required this.stamp,
  });

  factory UserInfoResponseDto.fromJson(Map<String, dynamic> json) {
    return UserInfoResponseDto(
      userId: (json['userId'] as num).toInt(),
      id: json['id'] as String,
      name: json['name'] as String,
      stamp: (json['stamp'] as num).toInt(),
    );
  }
}
