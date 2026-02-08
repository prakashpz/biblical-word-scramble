import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/game_screen.dart';
import 'providers/game_provider.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    Provider(
      create: (_) => AuthService(),
      child: const BiblicalWordScrambleApp(),
    ),
  );
}

class BiblicalWordScrambleApp extends StatelessWidget {
  const BiblicalWordScrambleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameProvider>(
      create: (_) => GameProvider(),
      child: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return MaterialApp(
            title: 'Biblical Word Scramble',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: _getHome(gameProvider),
          );
        },
      ),
    );
  }

  Widget _getHome(GameProvider gameProvider) {
    if (gameProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryGold),
        ),
      );
    }
    
    if (gameProvider.showAuthScreen) {
      return const AuthScreen();
    }
    
    return const GameScreen();
  }
}
