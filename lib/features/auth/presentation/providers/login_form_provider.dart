

//! 1. State del provider

import 'package:teslo_shop/features/shared/shared.dart';

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

  


}

//! 2. Como implementamos un notifier

//! 3. StateNotifierProvider -> que es el que se consume afuera



