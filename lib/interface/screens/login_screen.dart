import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:myapp/interface/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isPhoneValid = false;

  void _validatePhoneNumber(String value) {
    if (RegExp(r'^\d{10}$').hasMatch(value)) {
      setState(() {
        _isPhoneValid = true;
      });
    } else {
      setState(() {
        _isPhoneValid = false;
      });
    }
  }

  void _verifyOTP() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Verifying phone number"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Please wait..."),
            ],
          ),
        );
      },
    );

    // Simulate verification delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the dialog
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Legal Advisor"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedTextKit(
                pause: const Duration(seconds: 1),
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText('Legal\nAdvisor', textStyle: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold)),
                  TypewriterAnimatedText('Document\nReview', textStyle: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold)),
                  TypewriterAnimatedText('Upload\nDocuments', textStyle: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold)),
                  TypewriterAnimatedText('Chat with it', textStyle: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold)),
                  TypewriterAnimatedText('and Much More...', textStyle: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "+91",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                      ),
                      onChanged: _validatePhoneNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: "OTP",
                  border: OutlineInputBorder(),
                ),
                enabled: _isPhoneValid,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isPhoneValid ? _verifyOTP : null,
                  child: const Text("Verify"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}