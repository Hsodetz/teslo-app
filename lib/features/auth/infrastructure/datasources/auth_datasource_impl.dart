

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infrastructure/mappers/user_mapper.dart';

class AuthDataSourceImpl implements AuthDataSource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
    ),
  );

  @override
  Future<User> checkAuthStatus(String token) {
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async{

    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final user = UserMapper.userJsonToEntity(response.data);

      return user;
      
    } on DioException catch(e) {
      if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.type == DioExceptionType.connectionTimeout) throw ConnectionTimeOut();

      throw CustomError('Algo ha ocurrido!', 1);

    } catch (e) {
       throw CustomError('Algo ha ocurrido!', 1);
    }

  }

  @override
  Future<User> register(String email, String password, String fullName) {
    throw UnimplementedError();
  }

}