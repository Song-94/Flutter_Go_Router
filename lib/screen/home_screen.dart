import 'package:flutter/material.dart';
import 'package:flutter_go_router/layout/default_layout.dart';
import 'package:flutter_go_router/provider/auth_provider.dart';
import 'package:flutter_go_router/screen/3_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return DefaultLayout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              context.go('/one');
            },
            child: const Text(
              'Screen One (Go)',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // context.go('/one/two/three');
              context.goNamed(ThreeScreen.routeName);
            },
            child: const Text(
              'Screen Three (Go)',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/error');
            },
            child: const Text(
              'Error Screen (Go)',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/login');
            },
            child: const Text(
              'Login Screen (Go)',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(userProvider.notifier).logout();
            },
            child: const Text(
              'LogOut (Go)',
            ),
          ),
        ],
      ),
    );
  }
}
