

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
  }): super(ProductState(id: productId)){
    loadProduct();
  }

  // creamos un producto nuevo vacio para realizar el nuevo producto
  Product newEmptyProduct() {
    return Product(
      id: 'new', 
      title: '', 
      price: 0, 
      description: '', 
      slug: '', 
      stock: 0, 
      sizes: [], 
      gender: 'men', 
      tags: [], 
      images: [],
    );
  }


  Future<void> loadProduct() async {

    try {

      // verificamos si por la ruta el state.id viene con la palabra new 
      if ( state.id == 'new' ) {
        state = state.copyWith(
          isLoading: false,
          product: newEmptyProduct(),
        );  
        return;
      }
      
      final product = await productsRepository.getProductById(state.id);

      state = state.copyWith(
        isLoading: false,
        product: product,
      );
      
    } catch (e) {
      //print(e);
    }

    
  }
  
}

final productProvider = StateNotifierProvider.autoDispose.family<ProductNotifier, ProductState, String>((ref, productId) {

  final productsRepository = ref.watch(productsRepositoryProvider);


  return ProductNotifier(productsRepository: productsRepository, productId: productId);
});