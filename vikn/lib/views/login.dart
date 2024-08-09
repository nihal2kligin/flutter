import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vikn/api/api.dart';
import 'package:vikn/utils/constants.dart';
import 'package:vikn/utils/MyAppUtils.dart';
import 'package:vikn/views/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool isLoading = false;
  final GetStorage storage = GetStorage();

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      toast_warning("Please enter username and password");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response =
          await login_api(usernameController.text, passwordController.text);

      // Check if response is a map
      if (response is Map<String, dynamic>) {
        var data = response['data'];

        // Ensure data is a map
        if (data is Map<String, dynamic>) {
          // Use the data as a map
          var refreshToken = data['refresh'];
          var authToken = data['access'];
          String userId = await parseJwt(authToken);
          print("User ID: $userId");

          storage.write("user_id", userId.toString());
          storage.write("auth_token", authToken.toString());
          storage.write("login_status", "true");
          toast_success("Login Successfully");
          Get.offAll(()=>const DashboardScreen());
          // Navigate to the dashboard
        } else {
          toast_error(response['error']);
        }
      } else {
        // print('Expected a map but got ${response.runtimeType}');
        toast_error(response['error']);
      }
    } catch (e) {
      toast_error("Login failed. Please try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
      print('Login completed.');
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    if(storage.read("login_status") == "true"){
      Get.offAll(const DashboardScreen());
    }
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          // Close the keyboard when clicking outside text fields
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg/bg.png"), fit: BoxFit.cover),
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Color(0xFF1B1C3A),
            //     Color(0xFF181818),
            //   ],
            // ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Login to your vikn account',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          color: const Color(0xFF08131E),
                          border: Border.all(width: 1, color: const Color(0xFF1C3347)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/user-2.png',
                                    color: primaryColor,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: usernameController,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        labelStyle: const TextStyle(color: Colors.white70),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide:
                                          const BorderSide(color: Colors.transparent),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide:
                                          const BorderSide(color: Colors.transparent),
                                        ),
                                        filled: true,
                                        fillColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: Color(0xff1C3347),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/key-round.png',
                                    color: primaryColor,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: passwordController,
                                      obscureText: !_isPasswordVisible,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: const TextStyle(color: Colors.white70),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide:
                                          const BorderSide(color: Colors.transparent),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide:
                                          const BorderSide(color: Colors.transparent),
                                        ),
                                        filled: true,
                                        fillColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: primaryColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextButton(
                          onPressed: () {
                            // Handle forgotten password action
                          },
                          child: const Text(
                            'Forgotten Password?',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A3FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize:
                          Size(MediaQuery.of(context).size.width / 2.5, 50),
                          maximumSize:
                          Size(MediaQuery.of(context).size.width / 2.5, 50),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign in',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an Account?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle sign up action
                    },
                    child: const Text(
                      'Sign up now!',
                      style: TextStyle(color: Color(0xFF00A3FF)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> parseJwt(String token) async{
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid payload');
    }

    return payloadMap['user_id'].toString();
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
