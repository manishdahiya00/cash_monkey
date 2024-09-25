import 'package:cash_monkey/screens/history_screen.dart';
import 'package:cash_monkey/screens/home_screen.dart';
import 'package:cash_monkey/screens/login_screen.dart';
import 'package:cash_monkey/screens/offers_screen.dart';
import 'package:cash_monkey/screens/profile_screen.dart';
import 'package:cash_monkey/screens/quiz_screen.dart';
import 'package:cash_monkey/screens/refer_earn_screen.dart';
import 'package:cash_monkey/screens/social_media_screen.dart';
import 'package:cash_monkey/screens/splash_screen.dart';
import 'package:cash_monkey/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        "/home": (context) => const HomeScreen(),
        "/refer": (context) => const ReferEarnScreen(),
        "/profile": (context) => const ProfileScreen(),
        "/history": (context) => const HistoryScreen(),
        "/wallet": (context) => const WalletScreen(),
        "/login": (context) => const LoginScreen(),
        "/quizes": (context) => const QuizScreen(),
        "/offers": (context) => const OffersScreen(),
        "/social_media": (context) => const SocialMediaScreen(),
      },
    );
  }
}
