

import 'package:teslo_shop/features/products/domain/datasources/products.datasource.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl extends ProductsRepository {

  final ProductsDatasource productsDatasource;

  ProductsRepositoryImpl({required this.productsDatasource});


  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    return productsDatasource.createUpdateProduct(productLike);
  }

  @override
  Future<Product> getProductById(String id) {
    return productsDatasource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) {
    return productsDatasource.getProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    return productsDatasource.searchProductsByTerm(term);
  }

}