import 'package:basketball_records/presentation/view/main_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_pages.dart';


// final authProvider = StateProvider<bool>((ref) => false);

final routerProvider = Provider<GoRouter>((ref) {
  // final isLoggedIn = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppPage.main.path,
    redirect: (context, state) {
      if (state.uri.path == AppPage.main.path) {
        return AppPage.main.path;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppPage.main.path,
        name: AppPage.main.name,
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: AppPage.playerDetail.path,
        name: AppPage.playerDetail.name,
        builder: (context, state) {
          return const MainPage();
        },
      ),
    ],
  );
});