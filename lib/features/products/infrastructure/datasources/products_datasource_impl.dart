import 'package:dio/dio.dart';
import 'package:teslo_shop/features/products/domain/datasources/products.datasource.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';

import '../../../../config/config.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
    ),
  );

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) {
    // TODO: implement getProductsByPage
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    // TODO: implement searchProductsByTerm
    throw UnimplementedError();
  }
}
