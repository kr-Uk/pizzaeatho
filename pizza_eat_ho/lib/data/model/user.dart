/******** 회원가입 요청 ********/
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

/******** 로그인 요청 ********/
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

/******** 로그인 응답 ********/
class UserLoginResponseDto {
  final int userId;
  final String name;
  final int stamp;

  UserLoginResponseDto({
    required this.userId,
    required this.name,
    required this.stamp,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'stamp': stamp,
  };

  factory UserLoginResponseDto.fromJson(Map<String, dynamic> json) {
    return UserLoginResponseDto(
      userId: (json['userId'] as num).toInt(),
      name: json['name'] as String,
      stamp: (json['stamp'] as num?)?.toInt() ??
          (json['payment'] as num?)?.toInt() ??
          0,
    );
  }
}

/******** 사용자 정보 조회 응답 ********/
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
      stamp: (json['stamp'] as num?)?.toInt() ??
          (json['payment'] as num?)?.toInt() ??
          0,
    );
  }
}

