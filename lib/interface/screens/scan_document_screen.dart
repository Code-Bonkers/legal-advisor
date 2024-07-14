import 'package:flutter/material.dart';

class ScanDocumentsScreen extends StatelessWidget {
  const ScanDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.camera_alt, size: 64),
          onPressed: () {},
        ),
      ),
    );
  }
}
