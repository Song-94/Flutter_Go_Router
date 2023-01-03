import 'package:flutter/material.dart';
import 'package:flutter_go_router/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
   const ProviderScope(
      child: _App(),
    ),
  );
}

class _App extends ConsumerWidget {
  const _App({
    Key? key,
  }) : super(key: key);

  // Router 안에 존재하는게 Route.
  // 즉 Router 는 Routing 을 해줌.
  // Route 는 Router 안에서 각각의 route.

// 1. routeInformationProvider
// Router 정보 전달
// 2. routeInformationParser
// URI String 을 상태 및 Go Router 에서 사용 가능한 형태로 변환.
// 3. routerDelegate
// 위에서 변경된 값으로 실제 어떤 라우트를 보여줄지 졍함.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
