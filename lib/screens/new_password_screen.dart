import 'package:flutter/material.dart';
import '../services/usuario_service.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/brand_components.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.correo});
  final String correo;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _ocultar1 = true;
  bool _ocultar2 = true;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _msg(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  void _restablecer() {
    final pass = _passCtrl.text;
    final confirm = _confirmCtrl.text;

    if (pass.isEmpty || confirm.isEmpty) return _msg('Llena todos los campos');
    if (BarraSeguridad.nivel(pass) < 4) return _msg('La contraseña no cumple los requisitos');
    if (pass != confirm) return _msg('Las contraseñas no coinciden');
    if (!UsuarioService.cambiarPassword(widget.correo, pass)) {
      return _msg('Debe ser diferente a tu contraseña anterior');
    }

    _msg('Contraseña actualizada correctamente');
    Navigator.popUntil(context, (route) => route.isFirst);
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
                  const Text('Crear nueva contraseña', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF202C2A))),
                  const SizedBox(height: 6),
                  const Text('Tu nueva contraseña debe ser diferente a las anteriores.', textAlign: TextAlign.center, style: TextStyle(color: BiteSanoColors.mutedText, fontSize: 15)),
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
                        const Text('Nueva contraseña', style: TextStyle(fontSize: 15, color: Color(0xFF283331))),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passCtrl,
                          obscureText: _ocultar1,
                          onChanged: (_) => setState(() {}),
                          decoration: _deco(
                            'Ingresa tu nueva contraseña',
                            Icons.lock_outline_rounded,
                            IconButton(
                              icon: Icon(_ocultar1 ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              onPressed: () => setState(() => _ocultar1 = !_ocultar1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        BarraSeguridad(password: _passCtrl.text),
                        const SizedBox(height: 18),
                        const Text('Confirmar contraseña', style: TextStyle(fontSize: 15, color: Color(0xFF283331))),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _confirmCtrl,
                          obscureText: _ocultar2,
                          decoration: _deco(
                            'Repite tu nueva contraseña',
                            Icons.lock_reset_outlined,
                            IconButton(
                              icon: Icon(_ocultar2 ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              onPressed: () => setState(() => _ocultar2 = !_ocultar2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _restablecer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BiteSanoColors.forest,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            child: const Text('Restablecer contraseña', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
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

  InputDecoration _deco(String hint, IconData icon, Widget suffix) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: BiteSanoColors.mutedText, fontSize: 15),
        filled: true,
        fillColor: BiteSanoColors.fieldBackground,
        prefixIcon: Icon(icon, color: BiteSanoColors.mutedText),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: BiteSanoColors.forest, width: 1.4)),
      );
}