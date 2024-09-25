import 'package:cash_monkey/screens/home_screen.dart'; // Import the HomeScreen
import 'package:cash_monkey/utils/color_theme.dart';
import 'package:cash_monkey/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferCodeScreen extends StatefulWidget {
  const ReferCodeScreen({super.key});

  @override
  _ReferCodeScreenState createState() => _ReferCodeScreenState();
}

class _ReferCodeScreenState extends State<ReferCodeScreen> {
  final TextEditingController _referCodeController = TextEditingController();
  bool _isSubmitting = false;
  String _errorMessage = '';

  Future<void> _submitReferCode() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
    });

    try {
      final dio = Dio();
      Map<String, String> allInfo = await Utils.collectAllInfo();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? securityToken = prefs.getString('token');
      String versionName = allInfo['versionName'] ?? "";
      String versionCode = allInfo['versionCode'] ?? "";

      final response = await dio.post(
        "${allInfo["baseUrl"]}addReferCode",
        data: {
          "userId": userId,
          "securityToken": securityToken,
          "referCode": _referCodeController.text,
          "versionName": versionName,
          "versionCode": versionCode,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 201 && response.data["status"] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Referral code submitted successfully!')),
        );
        _navigateToHomeScreen();
      } else {
        // Handle error
        setState(() {
          _errorMessage =
              response.data["message"] ?? 'Failed to submit referral code';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = 'Failed to submit referral code: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _skipReferCode() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
    });

    try {
      final dio = Dio();
      Map<String, String> allInfo = await Utils.collectAllInfo();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? securityToken = prefs.getString('token');
      String versionName = allInfo['versionName'] ?? "";
      String versionCode = allInfo['versionCode'] ?? "";

      final response = await dio.post(
        "${allInfo["baseUrl"]}addReferCode",
        data: {
          "userId": userId,
          "securityToken": securityToken,
          "referCode": "",
          "versionName": versionName,
          "versionCode": versionCode,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 201 && response.data["status"] == 200) {
        _navigateToHomeScreen();
      } else {
        // Handle error
        setState(() {
          _errorMessage =
              response.data["message"] ?? 'Failed to submit referral code';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _errorMessage = 'Failed to submit referral code: $e';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter Referral Code',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ColorTheme.appBarColor,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: ColorTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _referCodeController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Referral Code',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReferCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 62, 62, 62),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: const RoundedRectangleBorder(),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: _isSubmitting ? null : _skipReferCode,
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
