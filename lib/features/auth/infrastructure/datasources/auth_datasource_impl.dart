import 'package:dio/dio.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infrastructure/mappers/user_mapper.dart';

import '../../../shared/infrastructure/services/dio_http_adapter_service_impl.dart';

class AuthDataSourceImpl implements AuthDataSource {

  final DioHttpAdapterServiceImpl _dio;

  AuthDataSourceImpl() 
  : _dio = DioHttpAdapterServiceImpl('');
 
  // final dio = Dio(
  //   BaseOptions(
  //     baseUrl: Environment.apiUrl,
  //   ),
  // );



  @override
  Future<User> checkAuthStatus(String token) async{
    
    try {

      final response = await _dio.get('/auth/check-status',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          }
        ),
      );

      final user = UserMapper.userJsonToEntity(response.data);

      return user;

    } on DioException catch(e) {
      if (e.response?.statusCode == 401) throw CustomError('Token incorrecto');

      if (e.type == DioExceptionType.connectionTimeout) throw CustomError('Revisar conexión a internet');

      throw Exception();

    } catch (e) {
      throw Exception();
    }

  }

  @override
  Future<User> login(String email, String password) async{

    try {

      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final user = UserMapper.userJsonToEntity(response.data);

      return user;
      
    } on DioException catch(e) {
      // if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.response?.statusCode == 401) throw CustomError(e.response?.data['message'] ?? 'Credenciales incorrectas');

      //if (e.type == DioExceptionType.connectionTimeout) throw ConnectionTimeOut();
      if (e.type == DioExceptionType.connectionTimeout) throw CustomError('Revisar conexión a internet');

      throw Exception();

    } catch (e) {
      throw Exception();
    }

  }

  @override
  Future<User> register(String email, String password, String fullName) async{
    try {
      final response = await _dio.post('/auth/register', data: {
        'fullName': fullName,
        'email': email,
        'password': password,
      });

      final user = UserMapper.userJsonToEntity(response.data);

      return user;

    } catch (e) {
      throw Exception();
    }
  }

}