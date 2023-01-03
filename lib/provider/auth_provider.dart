import 'package:flutter/material.dart';
import 'package:flutter_go_router/model/user_model.dart';
import 'package:flutter_go_router/screen/1_screen.dart';
import 'package:flutter_go_router/screen/2_screen.dart';
import 'package:flutter_go_router/screen/3_screen.dart';
import 'package:flutter_go_router/screen/error_screen.dart';
import 'package:flutter_go_router/screen/home_screen.dart';
import 'package:flutter_go_router/screen/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final authStateProvider = AuthNotifier(ref: ref);
    return GoRouter(
      initialLocation: '/login',
      errorBuilder: (context, state) {
        return ErrorScreen(
          error: state.error.toString(),
        );
      },
      // redirect : navigation 하는 순간 함수 실행
      redirect: authStateProvider._redirectLogic,
      // refresh : navigation 하지 않아도 화면 전환이 필요한 경우가 있기 때문에.
      refreshListenable: authStateProvider,
      routes: authStateProvider._routes, // List of route
    );
  },
);

class AuthNotifier extends ChangeNotifier {
  final Ref ref;

  AuthNotifier({
    required this.ref,
  }) {
    ref.listen<UserModel?>(
      userProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        } // 바라보고 있는 모든 위젯들 리빌드.
      },
    );
  }

  String? _redirectLogic(BuildContext context, GoRouterState state) {
    // UserModel 의 인스턴스 또는 null
    final user = ref.read(userProvider);

    // 로그인 하려는 상태
    final loggingIn = state.location == '/login';

    // 유저 정보가 없음 - 로그인 상태가 아님.

    // 유저 정보가 없고
    // 로그인 하려는 중이 아니라면
    // 로그인 페이지로 이동.
    if (user == null) {
      return loggingIn ? null : '/login';
    }

    // 유저 정보가 있는데
    // 로그인 페이지라면
    // 홈으로 이동
    if (loggingIn) {
      return '/';
    }

    return null;
  }

  List<GoRoute> get _routes => [
        GoRoute(
          path: '/',
          builder: (_, state) => HomeScreen(),
          routes: [
            // Nesting 으로 path 안에 '/' 생략 가능
            GoRoute(
              path: 'one',
              builder: (_, state) => OneScreen(),
              routes: [
                GoRoute(
                  path: 'two',
                  builder: (_, state) => TwoScreen(),
                  routes: [
                    // http://.../one/two/three
                    GoRoute(
                      path: 'three',
                      name: ThreeScreen.routeName,
                      builder: (_, state) => ThreeScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/login',
          builder: (_, state) => LoginScreen(),
        ),
      ];
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>(
  (ref) => UserStateNotifier(),
);

// 로그인한 상태면 UserModel 인스턴스 상태로 넣어주기.
// 로그아웃 상태면 null 상태로 넣어주기
class UserStateNotifier extends StateNotifier<UserModel?> {
  UserStateNotifier() : super(null);

  void login({
    required String name,
  }) {
    state = UserModel(name: name);
  }

  void logout() {
    state = null;
  }
}
