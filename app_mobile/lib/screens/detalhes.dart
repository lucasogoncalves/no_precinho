import 'package:flutter/material.dart';
import 'confirmapreco.dart';


class DetalhesProdutoScreen extends StatefulWidget {
  final String codigo;
  final String mercado;

  const DetalhesProdutoScreen({
    super.key,
    required this.codigo,
    required this.mercado,
  });

  @override
  State<DetalhesProdutoScreen> createState() => _DetalhesProdutoScreenState();
}


final TextEditingController nomeMercadoController = TextEditingController();


class _DetalhesProdutoScreenState extends State<DetalhesProdutoScreen> {
  
  final TextEditingController _nomeController = TextEditingController();
  late final TextEditingController _codigoController;

  @override
  void initState() {
    super.initState();
    _codigoController = TextEditingController(text: widget.codigo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Produto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do produto'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codigoController,
              decoration: const InputDecoration(labelText: 'Código de barras'),
              readOnly: true,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final nome = _nomeController.text.trim();
                final codigo = _codigoController.text.trim();
                final mercado = widget.mercado;





                if (nome.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Digite o nome do produto')),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmacaoScreen(
                      nome: nome,
                      codigo: codigo,
                      mercado: mercado,
                    ),
                  ),
                );

              },
              child: const Text('Anotar Preço'),
            )
          ],
        ),
      ),
    );
  }
}
