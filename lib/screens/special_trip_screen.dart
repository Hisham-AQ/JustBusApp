import 'package:flutter/material.dart';

class SpecialTripScreen extends StatelessWidget {
  const SpecialTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Special Trip')),
      body: const Center(child: Text('Special Trip Screen')),
    );
  }
}
