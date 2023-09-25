
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';


//! 1. State del provider
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isFormPosted = false, 
    this.isPosting = false, 
    this.isValid = false, 
    this.email = const Email.pure(),
    this.password = const Password.pure()
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) => LoginFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password
  );

  @override
  String toString() {
    return '''
      isPosting: $isPosting
      isFormPosted: $isFormPosted
      isValid: $isValid
      email: $email
      password: $password

    ''';
  }

}

//! 2. Como implementamos un notifier

class LoginFormNotifier extends StateNotifier<LoginFormState> {

  final Function(String, String) loginUserCallback;

  LoginFormNotifier({
    required this.loginUserCallback,
  }): super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail, 
      isValid: Formz.validate([newEmail, state.password]),

    );
  }

  onPasswordCahnge(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword, 
      isValid: Formz.validate([newPassword, state.email]),

    );
  }

  onFormSubmit() async{
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await loginUserCallback(state.email.value, state.password.value);

    state = state.copyWith(isPosting: false);

  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    // se hace el cambio de estado para notificar a todos sus listeners
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
      
    );
  }
  
}

//! 3. StateNotifierProvider -> que es el que se consume afuera

// El autodispose se usa para destruir lo que esta almacenado en los camppos del login, por si ya se ha logueado y vuelve no le aparezca sus credenciales
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {

  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;


  
  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});



