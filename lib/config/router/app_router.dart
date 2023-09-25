import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/products.dart';


// creamos un provider para manejar la proteccion de rutas 
final goRouterProvider = Provider((ref) {

  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
  initialLocation: '/splashAuthScreen',
  refreshListenable: goRouterNotifier,
  routes: [
    GoRoute(
      path: '/splashAuthScreen',
      builder: (context, state) => const CheckAuthStatusScreen(),
    ),

    ///* Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    ///* Product Routes
    GoRoute(
      path: '/',
      builder: (context, state) => const ProductsScreen(),
    ),
  ],

  // Bloquear si no se está autenticado de alguna manera

  redirect: (context, state) {

    final isGoingTo = state.subloc;
    final authStatus = goRouterNotifier.authStatus;

    print('$isGoingTo');

    if (isGoingTo == '/splashAuthScreen' && authStatus == AuthStatus.checking) return null;

    if (authStatus == AuthStatus.noAuthenticated) {
      if (isGoingTo == '/login' || isGoingTo == '/register') return null;

      return '/login';
    }

    if (authStatus == AuthStatus.authenticated) {
      if (isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/splashAuthScreen') {
        return '/';
      }
    }

    
    return null;
  },

  );
});

