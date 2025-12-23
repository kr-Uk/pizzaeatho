import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';
import '../model/user.dart';


class AuthRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();


  /// 앱 시작 시 호출
  Future<UserLoginResponseDto?> getCurrentUser() async {
    return await _localDataSource.loadUser();
  }

  Future<UserLoginResponseDto> login(UserLoginRequestDto dto) async {
    final user = await _remoteDataSource.login(dto);

    await _localDataSource.saveUser(user);

    return user;
  }

  Future<void> logout() async {
    await _localDataSource.clear();
  }

  Future<void> signup(UserSignupRequestDto dto) async{
    await _remoteDataSource.signup(dto);
  }

}
