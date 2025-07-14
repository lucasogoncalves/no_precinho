import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _mercadoController = TextEditingController();

  void _comecarPesquisa() {
    final nomeMercado = _mercadoController.text.trim();
    if (nomeMercado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome do mercado')),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/scanner',
      arguments: nomeMercado,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('No Precinho')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Digite o nome do mercado',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _mercadoController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome do mercado',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _comecarPesquisa,
              child: const Text('Começar'),
            ),
          ],
        ),
      ),
    );
  }
}
