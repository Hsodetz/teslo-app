

import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/datasources/auth_datasource_impl.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthDataSource dataSource;

  AuthRepositoryImpl(
    AuthDataSource? dataSource
  ) : dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return dataSource.register(email, password, fullName);
  }
  
}