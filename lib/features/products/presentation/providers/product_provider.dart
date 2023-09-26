

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

class ProductState {
  
  final String id;
  final Product? product;
  final bool isSaving;
  final bool isLoading;

  ProductState({
    required this.id, 
    this.product, 
    this.isSaving = false, 
    this.isLoading = true,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isSaving,
    bool? isLoading,

  }) => ProductState(
    id: id ?? this.id,
    product: product ?? this.product,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
  );


}

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productsRepository;

  ProductNotifier({
    required this.productsRepository,
    required String productId,
  }): super(ProductState(id: productId));


  Future<void> loadProduct() async {

  }
  
}

final productProvider = StateNotifierProvider.autoDispose.family<ProductNotifier, ProductState, String>((ref, productId) {

  final productsRepository = ref.watch(productsRepositoryProvider);


  return ProductNotifier(productsRepository: productsRepository, productId: productId);
});