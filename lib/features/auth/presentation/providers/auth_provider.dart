

//! 1. State del provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';

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

  AuthNotifier({required this.authRepository}): super(AuthState());

  Future<void> loginUser(String email, String password) async{

    // Esto lo debemos quitar en produccion, lo hacemos en local para simular que tarda la peticion
    // y nos de chance de ver un loading
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final User user = await authRepository.login(email, password);

      _setLoggedUser(user);

    } on WrongCredentials {
      logout('Credenciales no son correctas');
    }
    catch (e) {
      logout('Error no controlado');
    }



  }

  void registerUser(String email, String password) async{
    
  }

  void checkAuthStatus() async{
    
  }

  void _setLoggedUser(User user) {

    // TODO: se necesita guardar el token fisicamente

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout([String? errorMessage]) async{
    //TODO: Limpiar token al hacer logout
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



  return AuthNotifier(authRepository: authRepositoryImpl);
});