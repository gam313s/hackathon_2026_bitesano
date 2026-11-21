import 'package:flutter/material.dart';

import '../controllers/bitesano_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/brand.dart';
import 'register_screen.dart';

class AccessScreen extends StatefulWidget {
  final BiteSanoController controller;
  final VoidCallback onEntered;
  const AccessScreen({
    super.key,
    required this.controller,
    required this.onEntered,
  });
  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _remember = true;
  bool _working = false;
  bool _hidePassword = true;
  String? _error;
  String? _notice;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_form.currentState?.validate() != true) return;
    setState(() {
      _working = true;
      _error = null;
    });
    final onEntered = widget.onEntered;
    final error = await widget.controller.login(
      _identifier.text,
      _password.text,
      _remember,
    );
    if (error == null) {
      onEntered();
    } else if (mounted) {
      setState(() {
        _working = false;
        _error = error;
      });
    }
  }

  Future<void> _guest() async {
    setState(() => _working = true);
    final onEntered = widget.onEntered;
    final accepted = await widget.controller.enter('Invitado', '', false);
    if (accepted) {
      onEntered();
    } else if (mounted) {
      setState(() => _working = false);
    }
  }

  Future<void> _openRegister() async {
    final registered = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => RegisterScreen(controller: widget.controller),
      ),
    );
    if (registered == null || !mounted) return;
    setState(() {
      _identifier.text = registered;
      _password.clear();
      _error = null;
      _notice = 'Cuenta creada. Inicia sesión con tu contraseña.';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 28),
            children: [
              const Center(
                child: StatusPill(
                  label: 'ASISTENTE DE ALÉRGENOS',
                  icon: Icons.auto_awesome,
                ),
              ),
              const SizedBox(height: 25),
              const Center(child: BrandMark(size: 85)),
              const SizedBox(height: 15),
              const Text(
                'BiteSano',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: BiteColors.green,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Come fuera con más información y tranquilidad.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  height: 1.45,
                  color: BiteColors.muted,
                ),
              ),
              const SizedBox(height: 27),
              SurfaceCard(
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Iniciar sesión',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      const Text('Entra con tu cuenta de BiteSano.'),
                      const SizedBox(height: 20),
                      const Text(
                        'Correo o nombre de usuario',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _identifier,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                          hintText: 'ejemplo@correo.com',
                        ),
                        validator: (v) => (v?.trim().isEmpty ?? true)
                            ? 'Escribe tu correo o usuario'
                            : null,
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Contraseña',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _password,
                        obscureText: _hidePassword,
                        autocorrect: false,
                        enableSuggestions: false,
                        onFieldSubmitted: (_) => _working ? null : _login(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: 'Tu contraseña',
                          suffixIcon: IconButton(
                            tooltip: _hidePassword ? 'Mostrar' : 'Ocultar',
                            onPressed: () => setState(
                              () => _hidePassword = !_hidePassword,
                            ),
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (v) =>
                            (v?.isEmpty ?? true) ? 'Escribe tu contraseña' : null,
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _remember,
                        onChanged: (value) =>
                            setState(() => _remember = value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Recordarme en este dispositivo'),
                      ),
                      if (_notice != null && _error == null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _notice!,
                          style: const TextStyle(color: BiteColors.green),
                        ),
                      ],
                      if (_error != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _working ? null : _login,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Iniciar sesión'),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text('¿No tienes cuenta?'),
                          TextButton(
                            onPressed: _working ? null : _openRegister,
                            child: const Text('Crear cuenta'),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 9),
                            child: Text(
                              'O CONTINÚA',
                              style: TextStyle(
                                fontSize: 11,
                                color: BiteColors.muted,
                              ),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: _working ? null : _guest,
                        icon: const Icon(Icons.person_outline),
                        label: const Text('Explorar como invitado'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const SurfaceCard(
                color: BiteColors.input,
                child: Row(
                  children: [
                    Icon(Icons.lock_outline, color: BiteColors.green),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tu cuenta se guarda solo en este dispositivo y la contraseña no se almacena en texto plano.',
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
