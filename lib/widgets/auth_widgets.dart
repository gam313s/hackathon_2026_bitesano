import 'package:flutter/material.dart';
import 'brand_components.dart';

class BarraSeguridad extends StatelessWidget {
  const BarraSeguridad({super.key, required this.password});
  final String password;

  static int nivel(String p) {
    int n = 0;
    if (p.length > 4) n++;
    if (RegExp(r'[A-Z]').hasMatch(p)) n++;
    if (RegExp(r'[0-9]').hasMatch(p)) n++;
    if (RegExp(r'[^A-Za-z0-9\s]').hasMatch(p)) n++;
    return n;
  }

  Color _color(int n) => switch (n) {
        1 => const Color(0xFFB91C1C),
        2 => Colors.orange,
        3 => Colors.amber,
        _ => BiteSanoColors.forest,
      };

  @override
  Widget build(BuildContext context) {
    final n = nivel(password);
    const textos = ['', 'Débil', 'Regular', 'Buena', 'Fuerte'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) => Expanded(
            child: Container(
              height: 5,
              margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
              decoration: BoxDecoration(
                color: i < n ? _color(n) : const Color(0xFFD8E1EF),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          )),
        ),
        const SizedBox(height: 6),
        if (n > 0)
          Text(textos[n], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _color(n))),
        const Text(
          'Debe tener mayúscula, número, símbolo (\$ # " . !) y más de 4 caracteres.',
          style: TextStyle(color: BiteSanoColors.mutedText, fontSize: 11.5),
        ),
      ],
    );
  }
}

class CodigoFlotante {
  static void mostrar(BuildContext context, String codigo) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Row(
          children: [
            Icon(Icons.mark_email_unread_outlined, color: BiteSanoColors.forest),
            SizedBox(width: 8),
            Text('Código de seguridad'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Este código llegaría a tu correo:', style: TextStyle(color: BiteSanoColors.mutedText, fontSize: 13)),
            const SizedBox(height: 14),
            Text(codigo, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 8, color: BiteSanoColors.forest)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido', style: TextStyle(color: BiteSanoColors.forest, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}