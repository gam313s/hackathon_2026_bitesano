import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BiteNavigation extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const BiteNavigation({
    super.key,
    required this.selected,
    required this.onSelect,
  });
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14182335),
            blurRadius: 18,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (i) {
          const titles = ['Inicio', 'Escanear', 'Historial', 'Perfil'];
          const icons = [
            Icons.verified_user_outlined,
            Icons.camera_alt_outlined,
            Icons.assignment_outlined,
            Icons.manage_accounts_outlined,
          ];
          final active = i == selected;
          return Expanded(
            child: InkWell(
              onTap: () => onSelect(i),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (i == 1)
                    Container(
                      width: 52,
                      height: 45,
                      decoration: BoxDecoration(
                        color: active ? BiteColors.green : BiteColors.mint,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(
                        icons[i],
                        color: active ? Colors.white : BiteColors.green,
                        size: 26,
                      ),
                    )
                  else
                    Icon(
                      icons[i],
                      color: active ? BiteColors.green : BiteColors.muted,
                      size: 25,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    titles[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                      color: active ? BiteColors.green : BiteColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ),
  );
}
