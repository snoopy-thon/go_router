import 'package:go_router/go_router.dart';
import 'package:go_router_/ui/personal_info.dart';
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
        path: '/:tab',
        name: rootRouteName,
        builder: (context, state) {
          final tab = state.pathParameters['tab'];
          return HomeScreen(
            tab: tab ?? '',
          );
        },
        routes: [
          GoRoute(
            name: profilePersonalRouteName,
            path: 'profile-personal',
            builder: (context, state) {
              return const PersonalInfo();
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // 조건 설정
      final loggedIn = loginState.loggedIn;
      final inAuthPages = state.matchedLocation.contains(loginRouteName) ||
          state.matchedLocation.contains(createAccountRouteName);

      // inAuth && true => go to home
      if (inAuthPages && loggedIn) return '/shop';

      // not inAuth && false => go to loginPage
      if (!inAuthPages && !loggedIn) return '/login';
      return null;
    },
    refreshListenable: loginState,
    debugLogDiagnostics: true,
  );
}
