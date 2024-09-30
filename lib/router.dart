import 'package:go_router/go_router.dart';
import 'ui/error_page.dart';
import 'constants.dart';
import 'login_state.dart';
import 'ui/create_account.dart';
import 'ui/home_screen.dart';
import 'ui/login.dart';

class MyRouter {
  final LoginState loginState;
  MyRouter({required this.loginState});

  late final router = GoRouter(
    initialLocation: '/login',
    errorBuilder: (context, state) {
      return ErrorPage(
        error: state.error,
      );
    },
    routes: [
      GoRoute(
        path: '/login',
        name: loginRouteName,
        builder: (context, state) {
          return const Login();
        },
      ),
      GoRoute(
        path: '/create-account',
        name: createAccountRouteName,
        builder: (context, state) {
          return const CreateAccount();
        },
      ),
      GoRoute(
        path: '/',
        name: rootRouteName,
        builder: (context, state) {
          return HomeScreen(
            tab: 'shopping',
          );
        },
      ),
    ],
    redirect: (context, state) {
      // 조건에 맞게
      final loggedIn = loginState.loggedIn;
      final inAuthPages = state.matchedLocation.contains(loginRouteName) ||
          state.matchedLocation.contains(createAccountRouteName);

      // inAuth && true => go to home
      if (inAuthPages && loggedIn) return '/';

      // not inAuth && false => go to loginPage
      if (!inAuthPages && !loggedIn) return '/login';
      return null;
    },
    refreshListenable: loginState,
    debugLogDiagnostics: true,
  );
}
