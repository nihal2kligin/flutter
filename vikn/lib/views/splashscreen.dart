import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vikn/views/dashboard.dart';
import 'package:vikn/views/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GetStorage storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading time

    // Check login status
    String loginStatus = storage.read("login_status") ?? "false";

    if (loginStatus == "true") {
      // Navigate to Dashboard if logged in
      Get.offAll(const DashboardScreen());
    } else {
      // Navigate to Login if not logged in
      Get.offAll(const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset("assets/icons/logo.png"),
      ),
    );
  }
}