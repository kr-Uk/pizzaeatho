import '../datasource/auth_remote_datasource.dart';
import '../datasource/local_datasource.dart';
import '../model/user.dart';


class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();


  // 앱 시작 시 호출
  Future<UserLoginResponseDto?> getCurrentUser() async {
    return await _localDataSource.loadUser();
  }

  // 로그인
  Future<UserLoginResponseDto> login(UserLoginRequestDto dto) async {
    final user = await _remoteDataSource.login(dto);
    await _localDataSource.saveUser(user);
    return user;
  }

  // 로그아웃
  Future<void> logout() async {
    await _localDataSource.clear();
  }

  Future<void> saveUser(UserLoginResponseDto user) async {
    await _localDataSource.saveUser(user);
  }

  // 회원가입
  Future<void> signup(UserSignupRequestDto dto) async{
    await _remoteDataSource.signup(dto);
  }

  // 사용자 정보 조회
  Future<UserInfoResponseDto?> getUserInfo(String userId) async{
    return await _remoteDataSource.getUserInfo(userId);
  }

  Future<bool> checkUserId(String userId) async{
    return await _remoteDataSource.checkUserId(userId);
  }

}
