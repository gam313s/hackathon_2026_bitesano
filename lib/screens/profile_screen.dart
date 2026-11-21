import 'package:flutter/material.dart';

import '../controllers/bitesano_controller.dart';
import '../models/profile.dart';
import '../theme/app_theme.dart';
import '../widgets/allergy_tiles.dart';
import '../widgets/brand.dart';

class ProfileScreen extends StatelessWidget {
  final BiteSanoController controller;
  final VoidCallback onManage;
  final VoidCallback onCard;
  const ProfileScreen({
    super.key,
    required this.controller,
    required this.onManage,
    required this.onCard,
  });
  void _info(BuildContext context, String title, String detail) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(detail),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 26),
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xffe6faef)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.all(19),
          child: Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: BiteColors.mint,
                foregroundColor: BiteColors.green,
                child: Text(
                  c.name.isEmpty ? 'I' : c.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      c.email.isEmpty ? 'Perfil local' : c.email,
                      style: const TextStyle(color: BiteColors.muted),
                    ),
                    const SizedBox(height: 8),
                    StatusPill(
                      label: c.allergies.isEmpty
                          ? 'PERFIL LOCAL'
                          : 'PERFIL ACTIVO',
                      icon: Icons.verified_user_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                'Mi Perfil de Alergias',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
              '${c.allergies.length} activas',
              style: const TextStyle(
                color: BiteColors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (c.allergies.isEmpty)
                const Text('Configura las alergias que deseas detectar.'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: c.allergies.entries.map((e) {
                  final (color, bg) = severityColors(e.value);
                  return StatusPill(
                    label: '${allergyInfo(e.key).title} · ${e.value.label}',
                    color: color,
                    background: bg,
                    icon: allergyInfo(e.key).icon,
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: c.busy ? null : onManage,
                icon: const Icon(Icons.tune),
                label: const Text('Gestionar alergias'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Preferencias de seguridad',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        SurfaceCard(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              SwitchListTile(
                value: c.crossContact,
                onChanged: c.setCrossContact,
                title: const Text('Alertas de contaminación cruzada'),
                subtitle: const Text(
                  'Recordatorios para consultar al restaurante',
                ),
                secondary: const Icon(
                  Icons.health_and_safety_outlined,
                  color: BiteColors.green,
                ),
              ),
              const Divider(height: 1),
              SwitchListTile(
                value: !c.useOnline,
                onChanged: c.busy ? null : (v) => c.setOnline(!v),
                title: const Text('Modo sin conexión'),
                subtitle: const Text('Usa el catálogo local sin gastar puntos'),
                secondary: const Icon(Icons.wifi_off, color: BiteColors.green),
              ),
              const Divider(height: 1),
              SwitchListTile(
                value: c.alerts,
                onChanged: c.setAlerts,
                title: const Text('Avisos de riesgo en el escáner'),
                subtitle: const Text('Muestra advertencias al analizar'),
                secondary: const Icon(
                  Icons.notifications_none,
                  color: BiteColors.green,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Información y cuenta local',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        SurfaceCard(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.badge_outlined,
                  color: BiteColors.green,
                ),
                title: const Text('Tarjeta para el mesero'),
                trailing: const Icon(Icons.chevron_right),
                onTap: onCard,
              ),
              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: BiteColors.green,
                ),
                title: const Text('Acerca de BiteSano'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _info(
                  context,
                  'Acerca de BiteSano',
                  'Prototipo de asistencia con OCR, referencias locales y consultas opcionales. No verifica los ingredientes reales ni el contacto cruzado.',
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock_outline,
                  color: BiteColors.green,
                ),
                title: const Text('Privacidad de mi perfil'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _info(
                  context,
                  'Privacidad',
                  'Tus preferencias pueden guardarse en el almacenamiento privado de Android. No existe autenticación remota ni cifrado médico dedicado. Puedes borrar el perfil al cerrar la sesión local.',
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.help_outline,
                  color: BiteColors.green,
                ),
                title: const Text('Ayuda y soporte'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _info(
                  context,
                  'Cómo usar BiteSano',
                  'Selecciona tus alergias, escanea o carga un menú, revisa el OCR y aplica el análisis. Pregunta siempre al establecimiento por los ingredientes.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: BiteColors.dangerBg,
            foregroundColor: BiteColors.danger,
          ),
          onPressed: c.busy
              ? null
              : () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cerrar sesión local'),
                      content: const Text(
                        'Se eliminará tu perfil guardado y el historial de esta sesión.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Cerrar sesión'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) await c.signOut();
                },
          icon: const Icon(Icons.logout),
          label: const Text('Cerrar sesión local'),
        ),
      ],
    );
  }
}
