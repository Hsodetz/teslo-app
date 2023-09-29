import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/confirm_password.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/name.dart';
import 'package:teslo_shop/features/shared/shared.dart';

//! 1. State del provider

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;

  RegisterFormState({
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
    this.name = const Name.pure(), 
    this.email = const Email.pure(), 
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? name,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
  }) => RegisterFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
    confirmPassword: confirmPassword ?? this.confirmPassword,
  );
}

//! Implementando el notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {

  final Function(String, String, String) registerUserCallback;
 
 RegisterFormNotifier({required this.registerUserCallback}): super(RegisterFormState());

  onNameChange(String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([newName, state.email, state.password, state.confirmPassword]),
    );
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.name, state.password, state.confirmPassword]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
    password: newPassword, 
    isValid: Formz.validate([newPassword, state.email, state.name, state.confirmPassword]),
    );
  }

  onConfirmPasswordChange(String value) {
    final newConfirmPassword = ConfirmPassword.dirty(value);
    state = state.copyWith(
    confirmPassword: newConfirmPassword, 
    isValid: Formz.validate([newConfirmPassword, state.password, state.email, state.name]),
    );
  }

  onFormRegisterSubmit() async{
    _touchAllFields();

    if(state.password.value  != state.confirmPassword.value) {
      return onConfirmPasswordChange('iguales');
    }

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await registerUserCallback(
      state.email.value,
      state.password.value,
      state.name.value,
    );

    state = state.copyWith(isPosting: false);
  }


  _touchAllFields() {
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = ConfirmPassword.dirty(state.confirmPassword.value);
  
    // ahora aplicamos el nuevo estado
    state = state.copyWith(
      isFormPosted: true,
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      isValid: Formz.validate([name, email, password, confirmPassword]),
    );
  }

}


final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});