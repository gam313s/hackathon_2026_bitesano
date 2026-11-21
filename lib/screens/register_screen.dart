import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/brand_components.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _ocultarPass = true;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _correoCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _msg(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  void _crearCuenta() {
    final nombre = _nombreCtrl.text.trim();
    final correo = _correoCtrl.text.trim();
    final pass = _passCtrl.text;

    if (nombre.isEmpty || correo.isEmpty || pass.isEmpty) return _msg('Llena todos los campos');
    if (BarraSeguridad.nivel(pass) < 4) return _msg('La contraseña no cumple los requisitos');

    final ok = UsuarioService.registrar(Usuario(nombre: nombre, correo: correo, password: pass));
    if (!ok) return _msg('Ese correo ya está registrado');

    _msg('Cuenta creada correctamente');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: BiteSanoColors.deepForest),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const BrandMark(size: 72),
                  const SizedBox(height: 12),
                  const Text('Crea tu cuenta', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF202C2A))),
                  const SizedBox(height: 6),
                  const Text('Protege tu salud al comer fuera con BiteSano.', style: TextStyle(color: BiteSanoColors.mutedText, fontSize: 15)),
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
                        const Text('Nombre completo', style: TextStyle(fontSize: 15, color: Color(0xFF283331))),
                        const SizedBox(height: 8),
                        TextField(controller: _nombreCtrl, decoration: _deco('Tu nombre', Icons.person_outline_rounded)),
                        const SizedBox(height: 18),
                        const Text('Correo electrónico', style: TextStyle(fontSize: 15, color: Color(0xFF283331))),
                        const SizedBox(height: 8),
                        TextField(controller: _correoCtrl, keyboardType: TextInputType.emailAddress, decoration: _deco('ejemplo@correo.com', Icons.mail_outline_rounded)),
                        const SizedBox(height: 18),
                        const Text('Contraseña', style: TextStyle(fontSize: 15, color: Color(0xFF283331))),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passCtrl,
                          obscureText: _ocultarPass,
                          onChanged: (_) => setState(() {}),
                          decoration: _deco(
                            'Crea una contraseña segura',
                            Icons.lock_outline_rounded,
                            IconButton(
                              icon: Icon(_ocultarPass ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                              onPressed: () => setState(() => _ocultarPass = !_ocultarPass),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        BarraSeguridad(password: _passCtrl.text),
                        const SizedBox(height: 22),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _crearCuenta,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BiteSanoColors.forest,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            child: const Text('Crear cuenta', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
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

  InputDecoration _deco(String hint, IconData icon, [Widget? suffix]) => InputDecoration(
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