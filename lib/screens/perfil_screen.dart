import 'package:flutter/material.dart';

import '../widgets/brand_components.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _crossContamination = true;
  bool _offlineMode = true;
  bool _riskNotifications = true;

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
                  _buildUserCard(),
                  const SizedBox(height: 30),
                  _buildSectionTitle('Mi Perfil Médico', trailing: '4 activas'),
                  const SizedBox(height: 14),
                  _buildMedicalCard(),
                  const SizedBox(height: 30),
                  _buildSectionTitle('Preferencias de Seguridad'),
                  const SizedBox(height: 14),
                  _buildPreferencesCard(),
                  const SizedBox(height: 30),
                  _buildSectionTitle('Información y Cuenta'),
                  const SizedBox(height: 14),
                  _buildAccountCard(),
                  const SizedBox(height: 22),
                  _buildLogoutButton(),
                  const SizedBox(height: 22),
                  _buildPrivacyNote(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 68,
        height: 68,
        child: FloatingActionButton(
          onPressed: () {},
          elevation: 0,
          shape: const CircleBorder(),
          backgroundColor: BiteSanoColors.forest,
          foregroundColor: Colors.white,
          child: const Icon(Icons.photo_camera_outlined, size: 30),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const BrandMark(size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BiteSanoWordmark(fontSize: 22),
              Text(
                'Historial / Análisis',
                style: TextStyle(
                  color: BiteSanoColors.mutedText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.notifications_none_rounded,
          color: BiteSanoColors.mutedText,
          size: 26,
        ),
      ],
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: BiteSanoColors.fieldBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: BiteSanoColors.deepForest,
                  size: 40,
                ),
              ),
              Positioned(
                right: -6,
                bottom: -6,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: BiteSanoColors.forest,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'María González',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: BiteSanoColors.deepForest,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'maria.gonzalez@email.com',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: BiteSanoColors.mutedText,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: BiteSanoColors.fieldBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shield_rounded,
                        size: 16,
                        color: BiteSanoColors.deepForest,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Escudo Activo',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: BiteSanoColors.deepForest,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: _sectionStyle),
        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(
              color: BiteSanoColors.deepForest,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildMedicalCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: _AllergyChip(
                  icon: Icons.warning_amber_rounded,
                  name: 'Maní',
                  level: 'ALTA',
                  background: _redBg,
                  foreground: _redFg,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _AllergyChip(
                  icon: Icons.warning_amber_rounded,
                  name: 'Mariscos',
                  level: 'ALTA',
                  background: _redBg,
                  foreground: _redFg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _AllergyChip(
                  icon: Icons.grain_rounded,
                  name: 'Gluten',
                  level: 'MODERADA',
                  background: _orangeBg,
                  foreground: _orangeFg,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _AllergyChip(
                  icon: Icons.water_drop_outlined,
                  name: 'Lácteos',
                  level: 'INTOL.',
                  background: _blueBg,
                  foreground: _blueFg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            height: 58,
            decoration: BoxDecoration(
              color: BiteSanoColors.forest,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: BiteSanoColors.forest.withValues(alpha: 0.24),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.tune_rounded, color: Colors.white, size: 22),
                SizedBox(width: 12),
                Text(
                  'Gestionar Alergias',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _SwitchTile(
            icon: Icons.track_changes_rounded,
            title: 'Alertas de Contaminación Cruzada',
            subtitle: 'Avisa sobre trazas en cocina compartida',
            value: _crossContamination,
            onChanged: (v) => setState(() => _crossContamination = v),
          ),
          const SizedBox(height: 20),
          _SwitchTile(
            icon: Icons.wifi_off_rounded,
            title: 'Modo Sin Conexión (Tarjeta Médica)',
            subtitle: 'Acceso rápido sin internet en restaurantes',
            value: _offlineMode,
            onChanged: (v) => setState(() => _offlineMode = v),
          ),
          const SizedBox(height: 20),
          _SwitchTile(
            icon: Icons.notifications_active_outlined,
            title: 'Notificaciones de Riesgo',
            subtitle: 'Alertas en tiempo real al escanear',
            value: _riskNotifications,
            onChanged: (v) => setState(() => _riskNotifications = v),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: _cardDecoration(),
      child: const Column(
        children: [
          _LinkTile(icon: Icons.info_outline_rounded, label: 'Acerca de BiteSano'),
          Divider(color: Color(0xFFD8E1EF), height: 1),
          _LinkTile(
            icon: Icons.enhanced_encryption_outlined,
            label: 'Privacidad y Encriptación Médica',
          ),
          Divider(color: Color(0xFFD8E1EF), height: 1),
          _LinkTile(icon: Icons.support_agent_rounded, label: 'Ayuda y Soporte'),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: _redBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, color: _redFg, size: 22),
          SizedBox(width: 12),
          Text(
            'Cerrar Sesión',
            style: TextStyle(
              color: _redFg,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
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

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF263B49).withValues(alpha: 0.07),
            blurRadius: 28,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: const SafeArea(
        top: false,
        child: SizedBox(
          height: 76,
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.verified_user_outlined,
                  label: 'Inicio',
                ),
              ),
              Expanded(child: _NavItem(label: 'Escanear')),
              Expanded(
                child: _NavItem(
                  icon: Icons.assignment_outlined,
                  label: 'Historial',
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.manage_accounts_outlined,
                  label: 'Perfil',
                  selected: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _redBg = Color(0xFFFDE4E2);
const _redFg = Color(0xFF9B0A0A);
const _orangeBg = Color(0xFFFFE6CC);
const _orangeFg = Color(0xFF7A4A0A);
const _blueBg = Color(0xFFE1E6FF);
const _blueFg = Color(0xFF5A6280);

const _sectionStyle = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.w500,
  color: Color(0xFF283331),
);

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(26),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF263B49).withValues(alpha: 0.07),
        blurRadius: 28,
        offset: const Offset(0, 14),
      ),
    ],
  );
}

class _AllergyChip extends StatelessWidget {
  const _AllergyChip({
    required this.icon,
    required this.name,
    required this.level,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String name;
  final String level;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Icon(icon, color: foreground, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foreground,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            level,
            style: TextStyle(
              color: foreground,
              fontSize: 10,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: BiteSanoColors.fieldBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: BiteSanoColors.deepForest, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF283331),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: BiteSanoColors.mutedText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: BiteSanoColors.forest,
        ),
      ],
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Icon(icon, color: BiteSanoColors.deepForest, size: 24),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF283331),
              ),
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: BiteSanoColors.mutedText),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({this.icon, required this.label, this.selected = false});

  final IconData? icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? BiteSanoColors.forest : const Color(0xFF283331);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (icon != null)
          Icon(icon, color: color, size: 26)
        else
          const SizedBox(height: 26),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
