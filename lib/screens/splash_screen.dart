import 'package:cash_monkey/screens/home_screen.dart';
import 'package:cash_monkey/screens/login_screen.dart';
import 'package:cash_monkey/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import "package:cash_monkey/utils/color_theme.dart";
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleAppOpen();
  }

  Future<void> _handleAppOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? securityToken = prefs.getString('token');

    if (userId == null || securityToken == null) {
      _navigateToHomeOrLogin(isLoggedIn: false);
      return;
    }

    Map<String, String> allInfo = await Utils.collectAllInfo();
    String versionName = allInfo['versionName'] ?? "";
    String versionCode = allInfo['versionCode'] ?? "";

    try {
      final Dio dio = Dio();
      final response = await dio.post(
        "${allInfo["baseUrl"]}appOpen",
        data: {
          "userId": userId,
          "securityToken": securityToken,
          "versionName": versionName,
          "versionCode": versionCode,
        },
      );

      if (response.statusCode == 201 && response.data["status"] == 200) {
        await _saveUserData(prefs, response.data);
        _navigateToHomeOrLogin(isLoggedIn: true);
      } else {
        prefs.setBool('isLoggedIn', false);
        _showErrorSnackBar("Something Went Wrong");
        _navigateToHomeOrLogin(isLoggedIn: false);
      }
    } catch (e) {
      _showErrorSnackBar("Something Went Wrong");
      _navigateToHomeOrLogin(isLoggedIn: false);
    }
  }

  Future<void> _saveUserData(
      SharedPreferences prefs, Map<String, dynamic> data) async {
    prefs.setString("walletBalance", data['walletBalance'].toString());
    prefs.setString("name", data['name'].toString());
    prefs.setString("image", data['image'].toString());
    prefs.setString("email", data['email'].toString());
    prefs.setString("referCode", data['referCode']);
    prefs.setInt("referCount", data['referCount']);
  }

  void _navigateToHomeOrLogin({required bool isLoggedIn}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorTheme.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    width: MediaQuery.sizeOf(context).width * 0.5,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Made with  ♥️  by Cash Monkey",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
