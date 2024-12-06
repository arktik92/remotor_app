import 'package:flutter/material.dart';

class ScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Scanner Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
