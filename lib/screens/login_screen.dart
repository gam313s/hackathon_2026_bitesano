import 'package:flutter/material.dart';

import '../widgets/brand_components.dart';
import 'main_shell_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  const AiBadge(),
                  const SizedBox(height: 26),
                  const BiteSanoLogo(width: 240),
                  const SizedBox(height: 12),
                  Text(
                    'Come fuera con total seguridad y sin\nriesgos de alergias alimentarias.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: BiteSanoColors.deepForest.withValues(alpha: 0.82),
                      fontSize: 17,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildFormCard(context),
                  const SizedBox(height: 26),
                  const Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      Text(
                        '¿No tienes una cuenta?',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Regístrate gratis',
                        style: TextStyle(
                          color: BiteSanoColors.deepForest,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _buildPrivacyNote(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Correo electrónico', style: _fieldLabelStyle),
              Text(
                'Requerido',
                style: _fieldLabelStyle.copyWith(
                  color: BiteSanoColors.deepForest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            readOnly: true,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(
              hintText: 'ejemplo@correo.com',
              prefixIcon: const Icon(Icons.mail_outline_rounded),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 6,
            children: [
              const Text('Contraseña', style: _fieldLabelStyle),
              Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: BiteSanoColors.deepForest,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            readOnly: true,
            obscureText: true,
            decoration: _inputDecoration(
              hintText: '••••••••••••',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: const Icon(Icons.visibility_outlined),
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Icon(Icons.check_box, color: Color(0xFF1680EE), size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Mantener mi sesión activa en este dispositivo',
                  style: TextStyle(fontSize: 15, height: 1.35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 58,
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => const MainShellScreen(),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: BiteSanoColors.forest,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 5,
                shadowColor: BiteSanoColors.forest.withValues(alpha: 0.24),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Iniciar Sesión'),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward_rounded, size: 23),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPrivacyNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: BiteSanoColors.fieldBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.enhanced_encryption_outlined,
            color: BiteSanoColors.deepForest,
            size: 24,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Tus datos médicos y de alergias están protegidos con encriptación hospitalaria.',
              style: TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

const _fieldLabelStyle = TextStyle(fontSize: 16, color: Color(0xFF283331));

InputDecoration _inputDecoration({
  required String hintText,
  required Widget prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: BiteSanoColors.mutedText, fontSize: 16),
    filled: true,
    fillColor: BiteSanoColors.fieldBackground,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    prefixIconColor: BiteSanoColors.mutedText,
    suffixIconColor: BiteSanoColors.mutedText,
    contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: BiteSanoColors.forest, width: 1.4),
    ),
  );
}
