import 'package:go_router/go_router.dart';
import 'package:pokedex/features/home/presentation/pages/home_page.dart';

class AppRoutes {
  AppRoutes._();

  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
    ],
  );
}
