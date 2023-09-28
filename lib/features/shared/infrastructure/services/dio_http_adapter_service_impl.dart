import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/dio_http_adapter_service.dart';

class DioHttpAdapterServiceImpl implements DioHttpAdapterService {

  late final Dio _dio;
  final String accessToken;

  DioHttpAdapterServiceImpl(this.accessToken)
  : _dio = Dio(
      BaseOptions(
        baseUrl: Environment.apiUrl,
        headers: {
          'Authorization': 'Bearer $accessToken',
        }
      ),
    );

  @override
  Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) async{
    
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return response;
    } catch (error) {

      throw Exception();
    
    }

  }

  @override
  Future<Response> post(String url, {Object? data}) async{
    try {
      final response = await _dio.post(url, data: data);
      return response;
    } catch (error) {

      throw Exception();
    
    }
  }
  
  @override
  Future request(String url, {required Map<String, dynamic> data, Options? options}) async{
   
     try {
      final response = await _dio.request(url, data: data, options: options);
      return response;

    } catch (error) {

      throw Exception();
    
    }

  }
  
 
  

  


  



}