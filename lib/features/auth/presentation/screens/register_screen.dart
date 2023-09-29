import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../providers/register_form_provider.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground( 
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox( height: 80 ),
                // Icon Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        if ( !context.canPop() ) return;
                        context.pop();
                      }, 
                      icon: const Icon( Icons.arrow_back_rounded, size: 40, color: Colors.white )
                    ),
                    const Spacer(flex: 1),
                    Text('Crear cuenta', style: textStyles.titleLarge?.copyWith(color: Colors.white )),
                    const Spacer(flex: 2),
                  ],
                ),

                const SizedBox( height: 50 ),
    
                Container(
                  height: size.height - 260, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _RegisterForm(),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final  size = MediaQuery.of(context).size.width;
    //print(size);

    final RegisterFormState registerFormState = ref.watch(registerFormProvider);

    //print(registerFormState.name);

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size * 0.1),
      child: Column(
        children: [
          // const SizedBox( height: 50 ),
          const Spacer(),
          Text('Nueva cuenta', style: textStyles.titleMedium ),

          // const SizedBox( height: 50 ),
          const Spacer(),

          CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.text,
            onChanged: ref.read(registerFormProvider.notifier).onNameChange,
            errorMessage: registerFormState.isFormPosted ? registerFormState.name.errorMessage : null,
          ),
          const SizedBox( height: 10 ),

          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
            errorMessage: registerFormState.isFormPosted ? registerFormState.email.errorMessage : null,

          ),
          const SizedBox( height: 10 ),

          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onPasswordChange,
            errorMessage: registerFormState.isFormPosted ? registerFormState.password.errorMessage : null,
          ),
    
          const SizedBox( height: 10 ),

          CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onConfirmPasswordChange,
            errorMessage: registerFormState.isFormPosted ? registerFormState.confirmPassword.errorMessage : null,
          ),
    
          const SizedBox( height: 20 ),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Crear',
              buttonColor: Colors.black,
              onPressed: (){
                
                registerFormState.isPosting ? null : ref.read(registerFormProvider.notifier).onFormRegisterSubmit();
                
              },
            )
          ),

          const Spacer( flex: 2 ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                onPressed: (){
                  if ( context.canPop()){
                    return context.pop();
                  }
                  context.go('/login');
                  
                }, 
                child: const Text('Ingresa aquí')
              )
            ],
          ),

          const Spacer( flex: 1),
        ],
      ),
    );
  }
}