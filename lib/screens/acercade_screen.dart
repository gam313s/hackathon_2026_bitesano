import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/brand_components.dart';

const _ink = Color(0xFF0B1C30);
const _inkSoft = Color(0xFF3D4A42);
const _mint = Color(0xFF85F8C4);
const _mintDark = Color(0xFF005137);
const _supportEmail = 'soporte@bitesano.app';

class AcercaDeScreen extends StatefulWidget {
  const AcercaDeScreen({super.key});

  @override
  State<AcercaDeScreen> createState() => _AcercaDeScreenState();
}

class _AcercaDeScreenState extends State<AcercaDeScreen> {
  bool _copied = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _copyEmail() {
    Clipboard.setData(const ClipboardData(text: _supportEmail));
    setState(() => _copied = true);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _copied = false);
    });
  }

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildHero(),
                  const SizedBox(height: 30),
                  _buildSteps(),
                  const SizedBox(height: 24),
                  _buildMedicalNotice(),
                  const SizedBox(height: 28),
                  _buildLegal(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        if (Navigator.of(context).canPop())
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: BiteSanoColors.deepForest,
            tooltip: 'Volver',
          ),
        const BrandMark(size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BiteSanoWordmark(fontSize: 22),
              Text('Historial / Análisis',
                  style: TextStyle(
                      color: BiteSanoColors.mutedText, fontSize: 13)),
            ],
          ),
        ),
        Icon(Icons.account_circle_outlined,
            color: BiteSanoColors.mutedText, size: 30),
      ],
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: BiteSanoColors.forest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.health_and_safety,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('BiteSano',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: _ink)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: BiteSanoColors.fieldBackground,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('v2.4.0',
                              style: TextStyle(fontSize: 11, color: _inkSoft)),
                        ),
                      ],
                    ),
                    const Text('Tu copiloto gastronómico seguro',
                        style: TextStyle(fontSize: 13, color: _inkSoft)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: _mint,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 16, color: _mintDark),
                SizedBox(width: 6),
                Flexible(
                  child: Text('MOTOR IA V2.4 • 99.4% PRECISIÓN',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _mintDark)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nuestra misión es que disfrutes cada comida fuera de casa con total tranquilidad, detectando alérgenos ocultos en segundos mediante inteligencia artificial.',
            style: TextStyle(fontSize: 15, height: 1.5, color: _inkSoft),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps() {
    const steps = [
      (Icons.tune_rounded, 'Configura tu perfil de alergias y severidad',
          'Personaliza intolerancias, trazas y nivel de sensibilidad en segundos.',
          Color(0xFFB8F3D9)),
      (Icons.qr_code_scanner_rounded, 'Escanea cualquier menú físico o QR',
          'Apunta la cámara incluso en restaurantes con poca luz.',
          Color(0xFFDAE2FD)),
      (Icons.traffic_rounded, 'Recibe un semáforo de seguridad al instante',
          'Identifica platillos seguros, con precaución o de alto riesgo al momento.',
          _mint),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text('¿Cómo te protege BiteSano?',
                  style: TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w600, color: _ink)),
            ),
            Icon(Icons.gpp_good_outlined, color: BiteSanoColors.forest),
          ],
        ),
        const SizedBox(height: 14),
        for (final (i, (icon, title, sub, bg)) in steps.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: _card(radius: 22),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(icon, color: _mintDark),
                      ),
                      Positioned(
                        right: -6,
                        top: -6,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: BiteSanoColors.forest,
                          child: Text('${i + 1}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _ink)),
                        const SizedBox(height: 2),
                        Text(sub,
                            style: const TextStyle(
                                fontSize: 13, color: _inkSoft)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMedicalNotice() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDDB8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF825100),
            child: Icon(Icons.medical_information, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aviso Médico y Responsabilidad',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2A1700))),
                SizedBox(height: 4),
                Text(
                  'BiteSano es una herramienta de apoyo informativo basada en inteligencia artificial y no sustituye el criterio médico profesional. En casos de alergias severas o anafilaxia, confirma siempre los ingredientes y la preparación directamente con el chef o personal del restaurante.',
                  style: TextStyle(
                      fontSize: 13, height: 1.5, color: Color(0xFF653E00)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text('LEGAL Y SOPORTE',
              style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w600,
                  color: _inkSoft)),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: _card(radius: 22),
          child: Column(
            children: [
              _legalTile(Icons.description_outlined, 'Términos y Condiciones'),
              const Divider(height: 1, color: Color(0xFFEFF4FF)),
              _legalTile(Icons.lock_outline_rounded, 'Política de Privacidad'),
              const Divider(height: 1, color: Color(0xFFEFF4FF)),
              ListTile(
                onTap: _copyEmail,
                leading:
                    const Icon(Icons.mail_outline_rounded, color: BiteSanoColors.forest),
                title: const Text(_supportEmail,
                    style: TextStyle(color: BiteSanoColors.forest)),
                subtitle: Text(_copied
                    ? '¡Correo copiado al portapapeles!'
                    : 'Toca para copiar correo de contacto'),
                trailing: Icon(
                  _copied ? Icons.check_circle : Icons.content_copy_rounded,
                  color: BiteSanoColors.forest,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legalTile(IconData icon, String label) {
    return ListTile(
      onTap: () {},
      leading: Icon(icon, color: _inkSoft),
      title: Text(label, style: const TextStyle(color: _ink)),
      trailing: const Icon(Icons.chevron_right_rounded, color: _inkSoft),
    );
  }

  BoxDecoration _card({double radius = 26}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF263B49).withValues(alpha: 0.07),
          blurRadius: 28,
          offset: const Offset(0, 14),
        ),
      ],
    );
  }
}
