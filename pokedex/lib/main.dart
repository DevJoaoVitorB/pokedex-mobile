import 'package:flutter/material.dart';
import 'package:pokedex/core/network/graphql_client.dart';
import 'package:pokedex/core/routes/app_routes.dart';
import 'package:pokedex/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GraphqlClientProvider.instance.initialize();
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRoutes.router,
    );
  }
}
