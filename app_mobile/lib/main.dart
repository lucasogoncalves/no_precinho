import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/scanner.dart';
import 'screens/confirmapreco.dart';

void main() {
  runApp(const NoPrecinhoApp());
}

class NoPrecinhoApp extends StatelessWidget {
  const NoPrecinhoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'No Precinho',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/scanner': (context) => const ScannerScreen(),
        '/confirmacao': (context) => const ConfirmacaoScreen(),
      },
    );
  }
}
