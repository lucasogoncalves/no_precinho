import 'package:flutter/material.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  late String nomeMercado;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    nomeMercado = ModalRoute.of(context)!.settings.arguments as String;
  }

  void _anotarPreco() {
    final nome = _nomeController.text.trim();
    final codigo = _codigoController.text.trim();

    if (nome.isEmpty || codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/confirmacao',
      arguments: {
        'mercado': nomeMercado,
        'nome': nome,
        'codigo': codigo,
      },
    );
  }

  void _encerrar() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear Produto')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Mercado: $nomeMercado', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do produto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codigoController,
              decoration: const InputDecoration(
                labelText: 'Código de barras',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _anotarPreco,
              child: const Text('Anotar Preço'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _encerrar,
              child: const Text('Encerrar'),
            ),
          ],
        ),
      ),
    );
  }
}
