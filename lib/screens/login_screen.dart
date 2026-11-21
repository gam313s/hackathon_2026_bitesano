import 'package:flutter/material.dart';
import '../services/usuario_service.dart';
import '../widgets/brand_components.dart';
import 'main_shell_screen.dart';
import 'recovery_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _ocultarPass = true;
  bool _recordar = true;

  @override
  void dispose() {
    _correoCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _msg(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  void _iniciarSesion() {
    final correo = _correoCtrl.text.trim();
    final pass = _passCtrl.text;
    if (correo.isEmpty || pass.isEmpty) return _msg('Llena todos los campos');

    final user = UsuarioService.iniciarSesion(correo, pass);
    if (user == null) return _msg('Correo o contraseña incorrectos');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const MainShellScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const AiBadge(),
                  const SizedBox(height: 22),
                  const BrandMark(size: 84),
                  const SizedBox(height: 10),
                  const BiteSanoWordmark(fontSize: 25),
                  const SizedBox(height: 10),
                  Text(
                    'Come fuera con total seguridad y sin\nriesgos de alergias alimentarias.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: BiteSanoColors.deepForest.withValues(alpha: 0.82),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 26),
                  _formCard(),
                  const SizedBox(height: 22),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      const Text('¿No tienes una cuenta?',
                          style: TextStyle(fontSize: 15.5)),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (_) => const RegisterScreen()),
                        ),
                        child: const Text(
                          'Regístrate gratis',
                          style: TextStyle(
                            color: BiteSanoColors.deepForest,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _privacyNote(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formCard() => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF263B49).withValues(alpha: 0.07),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Correo electrónico',
                    style: TextStyle(fontSize: 15, color: Color(0xFF283331))),
                Text('Requerido',
                    style: TextStyle(
                        fontSize: 14, color: BiteSanoColors.deepForest)),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _correoCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDeco(
                  hint: 'ejemplo@correo.com', icon: Icons.mail_outline_rounded),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Contraseña',
                    style: TextStyle(fontSize: 15, color: Color(0xFF283331))),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (_) => const RecoveryPasswordScreen()),
                  ),
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: BiteSanoColors.deepForest,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passCtrl,
              obscureText: _ocultarPass,
              decoration: _inputDeco(
                hint: '••••••••••••',
                icon: Icons.lock_outline_rounded,
                suffix: IconButton(
                  icon: Icon(_ocultarPass
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _ocultarPass = !_ocultarPass),
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => setState(() => _recordar = !_recordar),
              child: Row(
                children: [
                  Icon(
                    _recordar
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: BiteSanoColors.forest,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Mantener mi sesión activa en este dispositivo',
                      style: TextStyle(fontSize: 14.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _iniciarSesion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BiteSanoColors.forest,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                icon: const Text('Iniciar Sesión',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                label: const Icon(Icons.arrow_forward_rounded, size: 22),
              ),
            ),
          ],
        ),
      );

  Widget _privacyNote() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: BiteSanoColors.fieldBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          children: [
            Icon(Icons.enhanced_encryption_outlined,
                color: BiteSanoColors.deepForest, size: 23),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tus datos médicos y de alergias están protegidos con encriptación hospitalaria.',
                style: TextStyle(fontSize: 14, height: 1.35),
              ),
            ),
          ],
        ),
      );
}

InputDecoration _inputDeco({
  required String hint,
  required IconData icon,
  Widget? suffix,
}) =>
    InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: BiteSanoColors.mutedText, fontSize: 15),
      filled: true,
      fillColor: BiteSanoColors.fieldBackground,
      prefixIcon: Icon(icon, color: BiteSanoColors.mutedText),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: BiteSanoColors.forest, width: 1.4),
      ),
    );