import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myapp/core/constants.dart';
import 'package:myapp/interface/screens/home_screen.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'interface/screens/login_screen.dart';

void main() async {
  await dotenv.load(fileName: 'lib/assets/.env');
  final String apiKey = dotenv.env['API_KEY']!;
  Gemini.init(apiKey: apiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: kGrey,
        systemNavigationBarColor: kGrey,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
