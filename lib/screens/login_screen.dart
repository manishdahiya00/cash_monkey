import 'dart:math';

import 'package:cash_monkey/screens/home_screen.dart';
import 'package:cash_monkey/screens/refer_code_screen.dart';
import 'package:cash_monkey/services/auth_service.dart';
import 'package:cash_monkey/utils/color_theme.dart';
import 'package:cash_monkey/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _referCodeController = TextEditingController();
  bool _isSubmitting = false;
  String _errorMessage = '';

  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

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
        Navigator.of(context).pop(); // Close the modal
        _navigateToHomeScreen();
      } else {
        // Handle error
        setState(() {
          _errorMessage = 'Invalid Refer Code';
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
        Navigator.of(context).pop(); // Close the modal
        _navigateToHomeScreen();
      } else {
        // Handle error
        setState(() {
          _errorMessage = response.data["message"];
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

  void showReferCodeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.2,
          maxChildSize: 0.9,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorTheme.backgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                      bottom: max(16.0,
                          MediaQuery.of(context).viewInsets.bottom + 16.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                            backgroundColor:
                                const Color.fromARGB(255, 62, 62, 62),
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> handleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await AuthService.signInWithGoogle();
      if (googleUser == null) {
        return;
      }

      String adId = await _getAdvertisingId();

      Map<String, String> allInfo = await Utils.collectAllInfo();
      var data = _prepareSignupData(googleUser, allInfo, adId);

      Response response = await Dio().post(
        "${allInfo["baseUrl"]}userSignup",
        data: data,
      );

      if (response.statusCode == 201 && response.data["status"] == 200) {
        await _storeUserData(response.data);
        print(response.data);
        // Call app open API after successful login
        await _callAppOpenAPI(allInfo);

        if (response.data["isReferCode"] == true) {
          showReferCodeModal(context);
        } else {
          _navigateToHomeScreen();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error : ${response.data["message"]}')),
        );
        print("Error during sign-up: ${response.data['message']}");
      }
    } catch (error) {
      print("Sign-In error: $error");
    }
  }

  Future<void> _callAppOpenAPI(Map<String, String> allInfo) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? securityToken = prefs.getString('token');

      if (userId == null || securityToken == null) {
        print("User ID or security token is missing");
        return;
      }

      String versionName = allInfo['versionName'] ?? "";
      String versionCode = allInfo['versionCode'] ?? "";

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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error : ${response.data["message"]}')),
        );
        print("Error during app open API call: ${response.data['message']}");
      }
    } catch (error) {
      print("App open API error: $error");
    }
  }

  Future<void> _saveUserData(
      SharedPreferences prefs, Map<String, dynamic> data) async {
    prefs.setString("walletBalance", data['walletBalance'].toString());
    prefs.setString("name", data['name'].toString());
    prefs.setString("image", data['image'].toString());
    prefs.setString("email", data['email'].toString());
    prefs.setString("referCode", data['referCode'].toString());
    prefs.setInt("referCount", data['referCount']);
  }

  Future<String> _getAdvertisingId() async {
    try {
      return await AdvertisingId.id(true) ?? '';
    } catch (error) {
      return '';
    }
  }

  Map<String, String> _prepareSignupData(GoogleSignInAccount googleUser,
      Map<String, String> allInfo, String adId) {
    return {
      "socialName": googleUser.displayName ?? "Unknown",
      "socialEmail": googleUser.email,
      "deviceId": allInfo['deviceId'] ?? "",
      "deviceType": allInfo['deviceType'] ?? "",
      "deviceName": allInfo['deviceName'] ?? "",
      "advertisingId": adId,
      "versionName": allInfo['versionName'] ?? "",
      "versionCode": allInfo['versionCode'] ?? "",
      "socialType": 'Google',
      "socialImgUrl": googleUser.photoUrl ?? '',
      "utmSource": allInfo['utmSource'] ?? '',
      "utmMedium": allInfo['utmMedium'] ?? '',
      "utmCampaign": allInfo['utmCampaign'] ?? '',
      "utmContent": allInfo['utmContent'] ?? '',
      "utmTerm": allInfo['utmTerm'] ?? '',
      "referrerUrl": allInfo['referrerUrl'] ?? ''
    };
  }

  Future<void> _storeUserData(Map<String, dynamic> data) async {
    String userId = data['userId']?.toString() ?? '';
    String token = data['securityToken']?.toString() ?? '';

    if (userId.isNotEmpty && token.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', userId);
      await prefs.setString('token', token);
    } else {
      print("Error: userId or token is null or empty.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/login_screen.png',
                height: size.height * 0.35,
                width: size.width * 0.6,
              ),
              SizedBox(height: size.height * 0.04),
              Text(
                'Welcome to Cash Monkey!',
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                'Get rewards on daily check-ins, spin the wheel, and more by completing offers!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              ElevatedButton.icon(
                onPressed: () async {
                  await handleSignIn(context);
                },
                icon: const Icon(Icons.login, color: Colors.white, size: 24.0),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
