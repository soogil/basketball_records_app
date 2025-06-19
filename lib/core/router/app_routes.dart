import 'package:basketball_records/presentation/view/main_page.dart';
import 'package:basketball_records/presentation/view/player_detail_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_pages.dart';


// final authProvider = StateProvider<bool>((ref) => false);

final routerProvider = Provider<GoRouter>((ref) {
  // final isLoggedIn = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppPage.main.path,
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
          final Map data = state.extra as Map;

          final String playerId = data['playerId'];
          final String playerName = data['playerName'];

          return PlayerDetailPage(playerId: playerId, playerName: playerName);
        },
      ),
    ],
  );
});