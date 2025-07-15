import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class ConfirmacaoScreen extends StatefulWidget {
  final String codigo;
  final String mercado;
  final String nome;

  const ConfirmacaoScreen({
    super.key,
    required this.nome,
    required this.codigo,
    required this.mercado,
  });

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
  void initState() {
    super.initState();
    nome = widget.nome;
    codigo = widget.codigo;
    mercado = widget.mercado;
  }


  void _salvar() {
    final precoTexto = _precoController.text.replaceAll(',', '.').trim();
    final preco = double.tryParse(precoTexto);

    if (nome.isEmpty || codigo.isEmpty || preco == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    setState(() {
      mostrarConfirmacao = true;
    });
  }

  void _confirmarSim() async {
    final precoTexto = _precoController.text.replaceAll(',', '.').trim();
    final preco = double.tryParse(precoTexto);

    if (nome.isEmpty || codigo.isEmpty || preco == null || preco <= 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    setState(() => sucesso = true);

    final url = Uri.parse('https://test-render-dp80.onrender.com/produtos');

    final Map<String, dynamic> body = {
      'nome': nome,
      'preco': preco,
      'codigo_barras': codigo,
    };

    if (mercado.isNotEmpty) {
      body['mercado'] = mercado;
    }

    log('📦 JSON final enviado: ${jsonEncode(body)}');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Mozilla/5.0',
        },
        body: jsonEncode(body),
      );

      log('📬 Status: ${response.statusCode}');
      log('📦 Resposta: ${response.body}');

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/scanner', arguments: {
              'mercado': mercado,
            });
          }
        });
      } else {
        setState(() => sucesso = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro do servidor: ${response.statusCode}\n📦 JSON enviado: ${jsonEncode(body)}',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => sucesso = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $e')),
      );
      log('❌ Exceção: $e');
    }
  }

  void _confirmarNao() {
    setState(() {
      mostrarConfirmacao = false;
    });
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
            Text('Mercado: ${widget.mercado}', style: const TextStyle(fontSize: 16)),
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
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
