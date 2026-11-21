import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  final double size;
  const BrandMark({super.key, this.size = 44});
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: BiteColors.green,
      borderRadius: BorderRadius.circular(size * .29),
    ),
    child: Icon(
      Icons.verified_user_outlined,
      size: size * .62,
      color: Colors.white,
    ),
  );
}

class BrandHeader extends StatelessWidget {
  final String subtitle;
  final String name;
  final VoidCallback? onProfile;
  const BrandHeader({
    super.key,
    required this.subtitle,
    this.name = 'Invitado',
    this.onProfile,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
    child: Row(
      children: [
        const BrandMark(size: 42),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BiteSano',
                style: TextStyle(
                  color: BiteColors.green,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.7,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: BiteColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onProfile,
          borderRadius: BorderRadius.circular(30),
          child: CircleAvatar(
            radius: 21,
            backgroundColor: BiteColors.mint,
            foregroundColor: BiteColors.green,
            child: Text(
              name.trim().isEmpty
                  ? 'I'
                  : name.trim().substring(0, 1).toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    ),
  );
}

class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(21),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0b183548),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Material(type: MaterialType.transparency, child: child),
  );
}

class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;
  final IconData? icon;
  const StatusPill({
    super.key,
    required this.label,
    this.color = BiteColors.green,
    this.background = BiteColors.mint,
    this.icon,
  });
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(24),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 5),
        ],
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: .2,
            ),
          ),
        ),
      ],
    ),
  );
}
