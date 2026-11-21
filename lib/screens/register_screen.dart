import 'package:flutter/material.dart';

import '../controllers/bitesano_controller.dart';
import '../theme/app_theme.dart';
import '../utils/profile_validation.dart';
import '../widgets/brand.dart';

class RegisterScreen extends StatefulWidget {
  final BiteSanoController controller;
  const RegisterScreen({super.key, required this.controller});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _working = false;
  bool _hidePassword = true;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_form.currentState?.validate() != true) return;
    setState(() {
      _working = true;
      _error = null;
    });
    final navigator = Navigator.of(context);
    final email = _email.text.trim();
    final error = await widget.controller.register(
      username: _username.text,
      email: _email.text,
      password: _password.text,
    );
    if (error == null) {
      // Regresa al inicio de sesión devolviendo el correo registrado.
      navigator.pop(email);
    } else if (mounted) {
      setState(() {
        _working = false;
        _error = error;
      });
    }
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  Widget _eye() => IconButton(
    tooltip: _hidePassword ? 'Mostrar' : 'Ocultar',
    onPressed: () => setState(() => _hidePassword = !_hidePassword),
    icon: Icon(
      _hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Crear cuenta')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            children: [
              const Center(child: BrandMark(size: 70)),
              const SizedBox(height: 16),
              SurfaceCard(
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Registro de usuario',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Crea tu cuenta para guardar tu perfil de alergias.',
                      ),
                      const SizedBox(height: 20),
                      _label('Correo electrónico'),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        validator: validateRequiredEmail,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail_outline),
                          hintText: 'ejemplo@correo.com',
                        ),
                      ),
                      const SizedBox(height: 18),
                      _label('Nombre de usuario'),
                      TextFormField(
                        controller: _username,
                        autocorrect: false,
                        maxLength: 30,
                        textInputAction: TextInputAction.next,
                        validator: validateUsername,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                          hintText: 'maria_gonzalez',
                          counterText: '',
                        ),
                      ),
                      const SizedBox(height: 10),
                      _label('Contraseña'),
                      TextFormField(
                        controller: _password,
                        obscureText: _hidePassword,
                        autocorrect: false,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.next,
                        validator: validatePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: 'Mínimo 8, con letras y números',
                          suffixIcon: _eye(),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _label('Confirmar contraseña'),
                      TextFormField(
                        controller: _confirm,
                        obscureText: _hidePassword,
                        autocorrect: false,
                        enableSuggestions: false,
                        onFieldSubmitted: (_) => _working ? null : _register(),
                        validator: (v) => v == _password.text
                            ? null
                            : 'Las contraseñas no coinciden',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline),
                          hintText: 'Repite tu contraseña',
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 14),
                        Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: _working ? null : _register,
                        icon: const Icon(Icons.check),
                        label: const Text('Crear cuenta'),
                      ),
                      const SizedBox(height: 6),
                      TextButton(
                        onPressed: _working ? null : () => Navigator.pop(context),
                        child: const Text('Ya tengo cuenta'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const SurfaceCard(
                color: BiteColors.input,
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, color: BiteColors.green),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tus datos se guardan en este dispositivo. La contraseña se guarda cifrada.',
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
  );
}
