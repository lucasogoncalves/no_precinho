import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/scanner.dart';
import 'screens/confirmapreco.dart';
//import 'screens/testconnection.dart';

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
        scaffoldBackgroundColor: const Color(0xFFF9F3FB), // tom rosado claro como nas suas capturas
      ),
      initialRoute: '/',
      routes: {
        //'/': (context) => const TesteConexaoScreen(),
        '/': (context) => const HomeScreen(),
        '/scanner': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ScannerScreen(mercado: args['mercado'] ?? '');
        },

        '/confirmacao': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ConfirmacaoScreen(
            nome: args['nome'] ?? '',
            codigo: args['codigo'] ?? '',
            mercado: args['mercado'] ?? '',
          );
        },

      },
    );
  }
}
