import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final UserModel user = await remoteDataSource.login(
      email: email,
      password: password,
    );
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    final UserModel user = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      avatar: avatar,
    );
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await remoteDataSource.resetPassword(email: email);
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final user = await remoteDataSource.signInWithGoogle();
    if (user != null) {
      await localDataSource.cacheUser(user);
    }
    return user;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await localDataSource.getCachedUser();
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearUser();
  }
}
