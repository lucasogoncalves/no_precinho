import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'detalhes.dart';

class ScannerScreen extends StatefulWidget {
  final String mercado;




  const ScannerScreen({super.key, required this.mercado});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}



class _ScannerScreenState extends State<ScannerScreen> {



  final MobileScannerController _controller = MobileScannerController();
  bool _codigoDetectado = false;
  bool _flashLigado = false;

  @override
    void initState() {
      super.initState();
      _reiniciarCamera();
    }

  void _reiniciarCamera() async {
    await _controller.stop();
    await Future.delayed(const Duration(milliseconds: 300));
    await _controller.start();

    // Garante que o flash esteja desligado
    if (_flashLigado) {
      await _controller.toggleTorch();
      setState(() {
        _flashLigado = false;
      });
    }

    setState(() {
      _codigoDetectado = false;
    });
  }


  late String mercado = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            
              onDetect: (BarcodeCapture capture) async {
                if (_codigoDetectado) return;

                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? codigo = barcodes.first.rawValue;
                  if (codigo != null) {
                    _codigoDetectado = true;
                      // Tenta desligar o flash (caso esteja ligado)
                    _controller.toggleTorch(); // segunda chamada desliga

                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalhesProdutoScreen(
                        codigo: codigo,
                        mercado: widget.mercado, // <- agora enviado direto
                      ),
                    ),
                  );

                  }
                }
              },

          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
          ),
          
          Positioned(
            top: 40,
            right: 20,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _flashLigado ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _controller.toggleTorch();
                    setState(() {
                      _flashLigado = !_flashLigado;
                    });
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () async {
                    await _controller.stop();
                    await Future.delayed(const Duration(milliseconds: 300));
                    await _controller.start();
                    setState(() {
                      _codigoDetectado = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),

    );
    
  }

  @override
  void dispose() {
    _controller.stop();
    if (_flashLigado) {
      _controller.toggleTorch(); // garante que desligue se ainda estiver ligado
    }
    _controller.dispose();
    super.dispose();
  }




}
