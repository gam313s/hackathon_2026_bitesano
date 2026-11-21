import 'package:flutter/material.dart';

import '../controllers/bitesano_controller.dart';
import '../theme/app_theme.dart';
import '../utils/profile_validation.dart';
import '../widgets/brand.dart';

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
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _remember = true;
  bool _working = false;
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _enter({bool guest = false}) async {
    if (!guest && _form.currentState?.validate() != true) return;
    setState(() => _working = true);
    final onEntered = widget.onEntered;
    final accepted = await widget.controller.enter(
      guest ? 'Invitado' : _name.text,
      guest ? '' : _email.text,
      guest ? false : _remember,
    );
    if (accepted) {
      onEntered();
    } else if (mounted) {
      setState(() => _working = false);
    }
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
                        'Bienvenido',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      const Text('Crea tu perfil local para empezar.'),
                      const SizedBox(height: 20),
                      const Text(
                        'Nombre',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _name,
                        validator: validateProfileName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 80,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                          hintText: 'Tu nombre',
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Correo electrónico (opcional)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail_outline),
                          hintText: 'ejemplo@correo.com',
                        ),
                        validator: validateOptionalEmail,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 12),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _remember,
                        onChanged: (value) =>
                            setState(() => _remember = value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('Recordarme en este dispositivo'),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _working ? null : () => _enter(),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Continuar al perfil'),
                      ),
                      const SizedBox(height: 14),
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
                        onPressed: _working ? null : () => _enter(guest: true),
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
                        'Modo local: no enviamos tu perfil a un servidor ni solicitamos contraseña.',
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
