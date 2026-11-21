import 'package:flutter/material.dart';
import '../services/codigo_service.dart';
import '../services/usuario_service.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/brand_components.dart';
import 'new_password_screen.dart';

class RecoveryPasswordScreen extends StatefulWidget {
  const RecoveryPasswordScreen({super.key});

  @override
  State<RecoveryPasswordScreen> createState() => _RecoveryPasswordScreenState();
}

class _RecoveryPasswordScreenState extends State<RecoveryPasswordScreen> {
  final _correoCtrl = TextEditingController();
  final _codigoCtrl = TextEditingController();
  bool _enviado = false;

  @override
  void dispose() {
    _correoCtrl.dispose();
    _codigoCtrl.dispose();
    super.dispose();
  }

  void _msg(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  void _enviarCodigo() {
    final correo = _correoCtrl.text.trim();
    if (correo.isEmpty) return _msg('Escribe tu correo primero');
    if (!UsuarioService.existeCorreo(correo)) return _msg('Ese correo no está registrado');

    final codigo = CodigoService.generar();
    setState(() => _enviado = true);
    CodigoFlotante.mostrar(context, codigo);
  }

  void _continuar() {
    final codigo = _codigoCtrl.text.trim();
    if (!_enviado) return _msg('Primero solicita tu código');
    if (codigo.isEmpty) return _msg('Escribe el código');
    if (!CodigoService.validar(codigo)) return _msg('Código incorrecto');

    final correo = _correoCtrl.text.trim();
    CodigoService.limpiar();
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => NewPasswordScreen(correo: correo)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: BiteSanoColors.deepForest),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const BrandMark(size: 72),
                  const SizedBox(height: 12),
                  const Text('Recuperar contraseña', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF202C2A))),
                  const SizedBox(height: 6),
                  const Text('Ingresa tu correo para recibir un código de verificación.', textAlign: TextAlign.center, style: TextStyle(color: BiteSanoColors.mutedText, fontSize: 15)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [BoxShadow(color: const Color(0xFF263B49).withValues(alpha: 0.07), blurRadius: 28, offset: const Offset(0, 14))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Correo electrónico', style: TextStyle(fontSize: 15, color: Color(0xFF283331))),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _correoCtrl,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) {
                            CodigoService.limpiar();
                            setState(() => _enviado = false);
                          },
                          decoration: _deco('ejemplo@correo.com', Icons.mail_outline_rounded),
                        ),
                        const SizedBox(height: 18),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Código de verificación', style: TextStyle(fontSize: 15, color: Color(0xFF283331))),
                            Text('4 dígitos', style: TextStyle(fontSize: 13, color: BiteSanoColors.mutedText)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _codigoCtrl,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          decoration: _deco('Ingresa tu código', Icons.key_outlined).copyWith(counterText: ''),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _enviarCodigo,
                            child: Text(_enviado ? 'Reenviar código' : 'Enviar código', style: const TextStyle(color: BiteSanoColors.deepForest, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: _continuar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BiteSanoColors.forest,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            icon: const Text('Continuar', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                            label: const Icon(Icons.arrow_forward_rounded, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _deco(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: BiteSanoColors.mutedText, fontSize: 15),
        filled: true,
        fillColor: BiteSanoColors.fieldBackground,
        prefixIcon: Icon(icon, color: BiteSanoColors.mutedText),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: BiteSanoColors.forest, width: 1.4)),
      );
}