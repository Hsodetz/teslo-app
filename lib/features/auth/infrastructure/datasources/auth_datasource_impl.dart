

import 'package:teslo_shop/features/auth/domain/domain.dart';

class AuthDataSourceImpl implements AuthDataSource {
  @override
  Future<User> checkAuthStatus(String token) {
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    throw UnimplementedError();
  }

}