

//! 1. State del provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

import '../../infrastructure/repositories/auth_repository.impl.dart';

enum AuthStatus {checking, authenticated, noAuthenticated}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage = '',
  });

  AuthState copyWith({
  AuthStatus? authStatus,
  User? user,
  String? errorMessage,

  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
  
}

//! 2. implementamos el notifier
class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }): super( AuthState() ) {

    // al instanciarse llama de una vez al checkout
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async{

    // Esto lo debemos quitar en produccion, lo hacemos en local para simular que tarda la peticion
    // y nos de chance de ver un loading
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final User user = await authRepository.login(email, password);

      _setLoggedUser(user);

    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }

  }

  void registerUser(String email, String password, String fullName) async{
    
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      final User user = await authRepository.register(email, password, fullName);

      _setLoggedUser(user);

    } catch (e) {
      throw Exception();
    }

  }

  void checkAuthStatus() async{

    // prikmero revisamos si hay un token
    final token = await keyValueStorageService.getValue<String>('token');
    
    if (token == null) return logout();

    try {

      final user = await authRepository.checkAuthStatus(token);

      _setLoggedUser(user);
      
    } catch (e) {
      logout();
    }


    
  }

  void _setLoggedUser(User user) async{

    //guardar el token fisicamente
    await keyValueStorageService.setKeyValue('token', user.token);

    // nuevo estado o cambio de estado como se prefiera ver
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async{
    //Limpiar token al hacer logout
    await keyValueStorageService.removeKey('token');

    // nuevo estado o cambio de estado como se prefiera ver
    state = state.copyWith(
      authStatus: AuthStatus.noAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );


  }


  
}

//! 3. StateNotifierProvider -> que es el que se consume afuera
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final AuthRepositoryImpl authRepositoryImpl = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();
   



  return AuthNotifier(
    authRepository: authRepositoryImpl,
    keyValueStorageService: keyValueStorageService,
  );
});