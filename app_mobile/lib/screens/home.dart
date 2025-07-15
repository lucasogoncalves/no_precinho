import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController mercadoController = TextEditingController();

  void _comecarPesquisa() {
    final mercado = mercadoController.text.trim();

    if (mercado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome do mercado')),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/scanner',
      arguments: {
        'mercado': mercadoController.text.trim(),
      },
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
              controller: mercadoController,
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
