import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmacaoScreen extends StatefulWidget {
  const ConfirmacaoScreen({super.key});

  @override
  State<ConfirmacaoScreen> createState() => _ConfirmacaoScreenState();
}

class _ConfirmacaoScreenState extends State<ConfirmacaoScreen> {
  final TextEditingController _precoController = TextEditingController();
  bool mostrarConfirmacao = false;
  bool sucesso = false;

  late String nome;
  late String codigo;
  late String mercado;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    nome = args['nome'];
    codigo = args['codigo'];
    mercado = args['mercado'];
  }

  void _salvar() {
    if (_precoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o preço')),
      );
      return;
    }

    setState(() {
      mostrarConfirmacao = true;
    });
  }

  void _confirmarSim() async {
    setState(() {
      sucesso = true;
    });

    final bool enviado = await enviarProduto(
      nome: nome,
      preco: double.parse(_precoController.text),
      codigoBarras: codigo,
      mercado: mercado,
    );

    if (!mounted) return;

    if (enviado) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.popUntil(context, ModalRoute.withName('/scanner'));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar produto')),
      );
    }
  }

  void _confirmarNao() {
    setState(() {
      mostrarConfirmacao = false;
    });
  }

  Future<bool> enviarProduto({
    required String nome,
    required double preco,
    required String codigoBarras,
    required String mercado,
  }) async {
    const url = 'https://test-render-dp80.onrender.com'; // Atualize com seu endpoint real

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'preco': preco,
        'codigo_barras': codigoBarras,
        'mercado': mercado,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar Produto')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mercado: $mercado', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Produto: $nome', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Código de barras: $codigo', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            TextField(
              controller: _precoController,
              decoration: const InputDecoration(
                labelText: 'Preço',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            if (!mostrarConfirmacao && !sucesso)
              ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            if (mostrarConfirmacao)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Deseja registrar esse preço?'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _confirmarSim,
                        child: const Text('Sim'),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: _confirmarNao,
                        child: const Text('Não'),
                      ),
                    ],
                  ),
                ],
              ),
            if (sucesso)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Sucesso!',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
