import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TesteConexaoScreen extends StatefulWidget {
  const TesteConexaoScreen({super.key});

  @override
  State<TesteConexaoScreen> createState() => _TesteConexaoScreenState();
}

class _TesteConexaoScreenState extends State<TesteConexaoScreen> {
  String resultado = 'Testando conexão...';

  @override
  void initState() {
    super.initState();
    testarConexao();
  }

  void testarConexao() async {
    final url = Uri.parse('https://test-render-dp80.onrender.com/produtos');

    final body = jsonEncode({
      'nome': 'Teste',
      'preco': 2.99,
      'codigo_barras': '123456',
      'mercado': 'Teste Market',
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Mozilla/5.0',
        },
        body: body,
      );

      setState(() {
        resultado = 'STATUS: ${response.statusCode}\n${response.body}';
      });
    } catch (e) {
      setState(() {
        resultado = 'Erro de conexão:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste de Conexão')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(resultado),
        ),
      ),
    );
  }
}
