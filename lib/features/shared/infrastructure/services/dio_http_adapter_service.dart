import 'package:dio/dio.dart';

abstract class DioHttpAdapterService {

  Future<Response> get(String url, {Map<String, dynamic>? queryParameters});

  Future<Response> post(String url, {Object? data});

  Future<dynamic> request(String url, {required Map<String, dynamic> data, Options? options});

}



