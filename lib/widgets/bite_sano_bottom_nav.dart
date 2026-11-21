import 'package:flutter/material.dart';
import 'brand_components.dart';

class BiteSanoBottomNavBar extends StatelessWidget {
  const BiteSanoBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItemData(icon: Icons.verified_user_outlined, label: 'Inicio'),
    _NavItemData(icon: Icons.photo_camera_outlined, label: 'Escanear'),
    _NavItemData(icon: Icons.receipt_long_outlined, label: 'Historial'),
    _NavItemData(icon: Icons.manage_accounts_outlined, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE5ECF6), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF263B49).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = index == currentIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  splashColor: BiteSanoColors.forest.withValues(alpha: 0.08),
                  highlightColor: Colors.transparent,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 28),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? BiteSanoColors.forest
                                  : const Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: isSelected ? -14 : 10,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          width: isSelected ? 48 : 28,
                          height: isSelected ? 48 : 28,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? BiteSanoColors.forest
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: BiteSanoColors.forest
                                          .withValues(alpha: 0.30),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            item.icon,
                            size: isSelected ? 24 : 22,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.icon, required this.label});
  final IconData icon;
  final String label;
}