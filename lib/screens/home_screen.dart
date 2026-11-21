import 'package:flutter/material.dart';
import '../widgets/brand_components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenScanner, required this.onOpenHistory, required this.onEditAllergies});
  final VoidCallback onOpenScanner, onOpenHistory, onEditAllergies;

  static const _allergies = [
    ('Cacahuates', 'Severa', Color(0xFFFDE8E8), Color(0xFFB91C1C), Icons.warning_amber_rounded),
    ('Mariscos', 'Severa', Color(0xFFFDE8E8), Color(0xFFB91C1C), Icons.set_meal_outlined),
    ('Gluten', 'Moderada', Color(0xFFFDE6C4), Color(0xFFA16207), Icons.grass_rounded),
    ('Lácteos', 'Intolerancia', Color(0xFFE0E7FF), Color(0xFF475569), Icons.local_drink_outlined),
  ];

  static const _scans = [
    ('Trattoria Bella Vista', 'Hoy, 14:30 • 16 platos analizados', '3 Alertas', Color(0xFFFDE8E8), Color(0xFFB91C1C), Icons.restaurant_rounded, '13 Seguros', '3 Alérgenos', 'Revisar →'),
    ('Sushi Koi Bar', 'Ayer, 21:10 • 10 platos analizados', 'Mariscos', Color(0xFFFDE8E8), Color(0xFFB91C1C), Icons.ramen_dining_outlined, '8 Seguros', '2 Alérgenos', 'Revisar →'),
    ('Café & Bakery Organik', '12 Mar • Menú de Desayuno', '100% Seguro', Color(0xFFDCFCE7), BiteSanoColors.deepForest, Icons.bakery_dining_outlined, 'Sin trazas detectadas', null, 'Detalles →'),
  ];

  static const _tips = [
    (Icons.soup_kitchen_outlined, Color(0xFFFEF3C7), Color(0xFFB45309), 'Salsas con cacahuate oculto', 'En platos asiáticos como Pad Thai o Satay, las salsas espesas pueden contener pasta de maní sin indicarse.'),
    (Icons.outdoor_grill_outlined, Color(0xFFD1FAE5), BiteSanoColors.deepForest, 'Pregunta clave al chef: Fritura compartida', 'Consulta si las guarniciones se fríen en el mismo aceite usado para mariscos o productos con trigo.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                children: [
                  _greeting(),
                  const SizedBox(height: 16),
                  _scannerCard(),
                  const SizedBox(height: 22),
                  _sectionTitle(Icons.verified_user_outlined, 'Mis Alergias Activas', 'Editar >', onEditAllergies),
                  const SizedBox(height: 12),
                  _allergiesGrid(),
                  const SizedBox(height: 14),
                  _chefCard(context),
                  const SizedBox(height: 24),
                  _sectionTitle(Icons.document_scanner_outlined, 'Escaneos Recientes', 'Ver todo >', onOpenHistory),
                  const SizedBox(height: 12),
                  ..._scans.map(_scanCard),
                  const SizedBox(height: 14),
                  _sectionTitle(Icons.lightbulb_outline_rounded, 'Tips de Seguridad Alimentaria'),
                  const SizedBox(height: 12),
                  ..._tips.map(_tipCard),
                  const SizedBox(height: 8),
                  _footerBanner(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))),
        child: const Row(
          children: [
            BrandMark(size: 36),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BiteSanoWordmark(fontSize: 19),
                Text('Historial / Análisis', style: TextStyle(fontSize: 12, color: BiteSanoColors.mutedText)),
              ],
            ),
            Spacer(),
            CircleAvatar(radius: 19, backgroundColor: Color(0xFFE0F0EE), child: Icon(Icons.person_rounded, color: BiteSanoColors.deepForest)),
          ],
        ),
      );

  Widget _greeting() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hola, María 👋', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13.5, color: Color(0xFF4B5563)),
                    children: [
                      TextSpan(text: 'Tu escudo está activo ('),
                      TextSpan(text: '4 alérgenos vigilados', style: TextStyle(color: BiteSanoColors.forest, fontWeight: FontWeight.w700)),
                      TextSpan(text: ')'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(16)),
            child: const Row(
              children: [
                Icon(Icons.circle, size: 8, color: BiteSanoColors.forest),
                SizedBox(width: 6),
                Text('IA Activa •\nv2.4', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, height: 1.15, color: BiteSanoColors.deepForest)),
              ],
            ),
          ),
        ],
      );

  Widget _scannerCard() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(colors: [Color(0xFF007A5A), BiteSanoColors.deepForest]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ANÁLISIS EN TIEMPO REAL', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFFA7F3D0))),
                      Text('Escanear Carta o\nMenú', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, height: 1.15, color: Colors.white)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12)),
                  child: const Text('Instantáneo', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Detecta ingredientes ocultos y riesgo de contaminación cruzada en segundos.', style: TextStyle(fontSize: 13.5, color: Colors.white.withValues(alpha: 0.9))),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onOpenScanner,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: BiteSanoColors.deepForest,
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.photo_camera_outlined, size: 20),
                    label: const Text('Abrir Escáner IA', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: onOpenScanner,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.qr_code_2_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _sectionTitle(IconData icon, String title, [String? action, VoidCallback? onTap]) => Row(
        children: [
          Icon(icon, size: 19, color: BiteSanoColors.forest),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
          const Spacer(),
          if (action != null)
            GestureDetector(
              onTap: onTap,
              child: Text(action, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: BiteSanoColors.forest)),
            ),
        ],
      );

  Widget _allergiesGrid() => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.55,
        children: _allergies.map((a) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            decoration: BoxDecoration(color: a.$3, borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(color: a.$4.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(9)),
                  child: Icon(a.$5, size: 17, color: a.$4),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.$1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                      Text(a.$2, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: a.$4)),
                    ],
                  ),
                ),
                CircleAvatar(radius: 3.5, backgroundColor: a.$4),
              ],
            ),
          );
        }).toList(),
      );

  Widget _chefCard(BuildContext context) => ListTile(
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Aviso al Chef'),
            content: const Text('Alergia severa a Cacahuates y Mariscos. Intolerancia a Gluten y Lácteos.'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar'))],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFE5ECF6))),
        leading: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(color: const Color(0xFFFDE8E8), borderRadius: BorderRadius.circular(11)),
          child: const Icon(Icons.badge_outlined, color: Color(0xFFB91C1C)),
        ),
        title: Row(
          children: [
            const Text('Tarjeta de Mesa', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFFDE8E8), borderRadius: BorderRadius.circular(7)),
              child: const Text('Chef', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFB91C1C))),
            ),
          ],
        ),
        subtitle: const Text('Muestra tus restricciones al mesero...', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.5)),
        trailing: const CircleAvatar(radius: 16, backgroundColor: Color(0xFFF3F6FC), child: Icon(Icons.fullscreen_rounded, size: 19, color: Color(0xFF374151))),
      );

  Widget _scanCard((String, String, String, Color, Color, IconData, String, String?, String) s) => Container(
        margin: const EdgeInsets.only(bottom: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5ECF6)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(border: Border(left: BorderSide(color: s.$5, width: 4))),
            padding: const EdgeInsets.all(13),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(color: s.$4, borderRadius: BorderRadius.circular(11)),
                      child: Icon(s.$6, color: s.$5, size: 21),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.$1, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                          Text(s.$2, style: const TextStyle(fontSize: 12, color: BiteSanoColors.mutedText)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(color: s.$4, borderRadius: BorderRadius.circular(11)),
                      child: Text(s.$3, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: s.$5)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, size: 15, color: BiteSanoColors.forest),
                      const SizedBox(width: 4),
                      Text(s.$7, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: BiteSanoColors.deepForest)),
                      if (s.$8 != null) ...[
                        const Text('  •  ', style: TextStyle(color: BiteSanoColors.mutedText)),
                        const Icon(Icons.cancel_outlined, size: 15, color: Color(0xFFB91C1C)),
                        const SizedBox(width: 4),
                        Text(s.$8!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFB91C1C))),
                      ],
                      const Spacer(),
                      GestureDetector(
                        onTap: onOpenHistory,
                        child: Text(s.$9, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: BiteSanoColors.forest)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _tipCard((IconData, Color, Color, String, String) t) => Container(
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: const Color(0xFFF4F7FC), borderRadius: BorderRadius.circular(16)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: t.$2, borderRadius: BorderRadius.circular(10)),
              child: Icon(t.$1, color: t.$3, size: 20),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.$4, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(t.$5, style: const TextStyle(fontSize: 12.5, height: 1.35, color: Color(0xFF4B5563))),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _footerBanner() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFEAF3FA), borderRadius: BorderRadius.circular(16)),
        child: const Row(
          children: [
            CircleAvatar(radius: 18, backgroundColor: BiteSanoColors.forest, child: Icon(Icons.favorite_border, color: Colors.white, size: 19)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Comes seguro con BiteSano', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  Text('Base de datos de +18,000 ingredientes', style: TextStyle(fontSize: 12, color: BiteSanoColors.mutedText)),
                ],
              ),
            ),
            Icon(Icons.verified_user_outlined, color: BiteSanoColors.forest),
          ],
        ),
      );
}