import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cash_monkey/utils/color_theme.dart';
import 'package:cash_monkey/utils/utils.dart';
import 'package:cash_monkey/screens/home_screen.dart';

class ReferCodeScreen extends StatefulWidget {
  const ReferCodeScreen({super.key});

  @override
  _ReferCodeScreenState createState() => _ReferCodeScreenState();
}

class _ReferCodeScreenState extends State<ReferCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.backgroundColor,
    );
  }
}
