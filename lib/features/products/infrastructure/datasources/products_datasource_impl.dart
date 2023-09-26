import 'package:dio/dio.dart';
import 'package:teslo_shop/features/products/domain/datasources/products.datasource.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/infrastructure/errors/product_errors.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

import '../../../../config/config.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({
    required this.accessToken
  }) : dio = Dio(
      BaseOptions(
      baseUrl: Environment.apiUrl,
      headers: {
        'Authorization': 'Bearer $accessToken',
      }
    ),
  );

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) async{
    
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);

      return product;

    } on DioException catch(e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();

      throw Exception();

    } catch (e) {
      throw Exception();
    }

  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async{
    final response = await dio.get('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];

    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }

    return products;
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    throw UnimplementedError();
  }
}