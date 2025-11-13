import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_fe/providers/auth_provider.dart';
import 'package:gym_fe/screens/login_screen.dart';
import 'package:gym_fe/screens/calculate_nutrition_screen.dart';
import 'package:gym_fe/screens/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const GYM_FE(),
    ),
  );
}

class GYM_FE extends StatelessWidget {
  const GYM_FE({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // The root screen will decide whether to show login or home
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // Show ProfileScreen (or HomeScreen) if logged in, else show LoginScreen
    if (auth.isLoggedIn) {
      return const ProfileScreen();
    } else {
      return const LoginScreen();
    }
  }
}
