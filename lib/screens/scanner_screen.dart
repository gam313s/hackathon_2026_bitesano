import 'package:flutter/material.dart';
import '../widgets/brand_components.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _flashOn = false;
  bool _scanning = false;
  bool _showAltSample = false;

  // Aquí conectarás el http.post al backend de tu compañero
  Future<void> _runScan(String source) async {
    if (_scanning) return;
    setState(() => _scanning = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _scanning = false;
      _showAltSample = !_showAltSample;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Análisis completado ($source)'), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _showAltSample
        ? [
            ('Risotto Frutti di Mare', 'Contiene camarón, mejillones y caldo de mariscos.', false),
            ('Tacos de Nopal Asado', 'Libre de maní, mariscos y gluten en tortilla de maíz.', true),
          ]
        : [
            ('Pad Thai de Cacahuate', 'Contiene cacahuate tostado y pasta de maní en salsa.', false),
            ('Ensalada César Vegana', 'Libre de gluten, frutos secos y mariscos.', true),
          ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                children: [
                  _cameraViewfinder(),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Icon(Icons.psychology_outlined, size: 20, color: BiteSanoColors.forest),
                      const SizedBox(width: 8),
                      const Text('Resumen Instantáneo', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(12)),
                        child: Text('${results.length} platillos', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E3A8A))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...results.map(_resultCard),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: const Row(
          children: [
            BrandMark(size: 36),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BiteSanoWordmark(fontSize: 19),
                Text('Escáner De Menú', style: TextStyle(fontSize: 12, color: BiteSanoColors.mutedText)),
              ],
            ),
            Spacer(),
            CircleAvatar(radius: 19, backgroundColor: Color(0xFFE0F0EE), child: Icon(Icons.person_rounded, color: BiteSanoColors.deepForest)),
          ],
        ),
      );

  Widget _cameraViewfinder() => Container(
        height: 410,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B3538), Color(0xFF4A463F), Color(0xFF232C30)],
          ),
        ),
        child: Column(
          children: [
            // Controles superiores (Flash, Idioma, Tip)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleBtn(_flashOn ? Icons.flashlight_on_rounded : Icons.flashlight_off_rounded, () => setState(() => _flashOn = !_flashOn)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    children: [
                      Icon(Icons.translate_rounded, size: 15, color: Color(0xFF6EE7B7)),
                      SizedBox(width: 6),
                      Text('ES / Menú Detectado', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                _circleBtn(Icons.lightbulb_outline_rounded, () {}),
              ],
            ),
            const SizedBox(height: 10),
            // Banner de vigilancia activa
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(color: const Color(0xFF162226).withValues(alpha: 0.85), borderRadius: BorderRadius.circular(14)),
              child: const Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Color(0xFF34D399)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('VIGILANCIA IA ACTIVA', style: TextStyle(color: Color(0xFF6EE7B7), fontSize: 10, fontWeight: FontWeight.w700)),
                        Text('Filtros: Maní, Mariscos y Gluten', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.verified_user_outlined, color: Color(0xFF6EE7B7), size: 19),
                ],
              ),
            ),
            // Marco central de enfoque (aquí irá el CameraPreview real)
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(size: const Size(double.infinity, 190), painter: _CornersPainter()),
                  if (_scanning)
                    const CircularProgressIndicator(color: Color(0xFF6EE7B7))
                  else
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _tagPill('¡ALÉRGENO! (MANÍ)', const Color(0xFFB91C1C), Icons.warning_amber_rounded),
                        const SizedBox(height: 12),
                        _tagPill('100% SEGURO', BiteSanoColors.forest, Icons.check_circle_outline_rounded),
                      ],
                    ),
                  Positioned(
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFF162226).withValues(alpha: 0.88), borderRadius: BorderRadius.circular(18)),
                      child: const Row(
                        children: [
                          Icon(Icons.center_focus_weak_rounded, size: 14, color: Color(0xFF6EE7B7)),
                          SizedBox(width: 6),
                          Text('Apunta al texto o párrafos del menú', style: TextStyle(color: Colors.white, fontSize: 11.5)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Controles inferiores (Galería, Escanear Todo, Menú QR)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionCol(Icons.photo_library_outlined, 'Galería', false, () => _runScan('Galería')),
                _actionCol(Icons.document_scanner_rounded, 'Escanear Todo', true, () => _runScan('Cámara')),
                _actionCol(Icons.qr_code_scanner_rounded, 'Menú QR', false, () => _runScan('QR')),
              ],
            ),
          ],
        ),
      );

  Widget _circleBtn(IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: CircleAvatar(radius: 18, backgroundColor: Colors.black45, child: Icon(icon, size: 18, color: Colors.white)),
      );

  Widget _tagPill(String text, Color color, IconData icon) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 5),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700)),
          ],
        ),
      );

  Widget _actionCol(IconData icon, String label, bool primary, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: primary ? 56 : 44,
              height: primary ? 56 : 44,
              decoration: BoxDecoration(
                color: primary ? Colors.white : Colors.black45,
                shape: primary ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: primary ? null : BorderRadius.circular(14),
                border: primary ? Border.all(color: const Color(0xFF34D399), width: 3) : null,
              ),
              child: Icon(icon, color: primary ? BiteSanoColors.forest : Colors.white, size: primary ? 26 : 20),
            ),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: primary ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      );

  Widget _resultCard((String, String, bool) item) {
    final color = item.$3 ? BiteSanoColors.forest : const Color(0xFFB91C1C);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE5ECF6)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(border: Border(left: BorderSide(color: color, width: 4))),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.$1, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(item.$2, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: BiteSanoColors.mutedText)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(item.$1),
                    content: Text(item.$2),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendido'))],
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(
                    color: item.$3 ? BiteSanoColors.forest : const Color(0xFFFDE8E8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.$3 ? 'Apto' : 'Ver detalle',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: item.$3 ? Colors.white : const Color(0xFFB91C1C)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF6EE7B7)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const len = 22.0;
    const r = 14.0;
    final w = size.width;
    final h = size.height;

    canvas.drawPath(Path()..moveTo(0, len)..lineTo(0, r)..quadraticBezierTo(0, 0, r, 0)..lineTo(len, 0), p);
    canvas.drawPath(Path()..moveTo(w - len, 0)..lineTo(w - r, 0)..quadraticBezierTo(w, 0, w, r)..lineTo(w, len), p);
    canvas.drawPath(Path()..moveTo(0, h - len)..lineTo(0, h - r)..quadraticBezierTo(0, h, r, h)..lineTo(len, h), p);
    canvas.drawPath(Path()..moveTo(w - len, h)..lineTo(w - r, h)..quadraticBezierTo(w, h, w, h - r)..lineTo(w, h - len), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}