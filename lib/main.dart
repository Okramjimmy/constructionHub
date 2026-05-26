import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode for mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: ConstructionHubApp(),
    ),
  );
}

class ConstructionHubApp extends ConsumerWidget {
  const ConstructionHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // routerProvider is now a Riverpod provider so auth state can drive redirects.
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'ConstructionHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
