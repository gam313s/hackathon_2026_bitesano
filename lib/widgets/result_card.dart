import 'package:flutter/material.dart';

import '../models/menu.dart';
import '../theme/app_theme.dart';
import 'brand.dart';

({String label, Color color, Color background, IconData icon}) resultStyle(
  AllergyStatus status,
) => switch (status) {
  AllergyStatus.risk => (
    label: 'POSIBLE RIESGO · CONSULTAR',
    color: BiteColors.danger,
    background: BiteColors.dangerBg,
    icon: Icons.warning_amber_rounded,
  ),
  AllergyStatus.noMatch => (
    label: 'SIN RIESGO DETECTADO*',
    color: BiteColors.green,
    background: BiteColors.mint,
    icon: Icons.info_outline,
  ),
  AllergyStatus.insufficient => (
    label: 'PRECAUCIÓN · SIN DATOS',
    color: BiteColors.amber,
    background: BiteColors.amberBg,
    icon: Icons.help_outline,
  ),
  AllergyStatus.pending => (
    label: 'PENDIENTE DE ANÁLISIS',
    color: BiteColors.blueGray,
    background: BiteColors.blueBg,
    icon: Icons.schedule,
  ),
};

class ResultCard extends StatelessWidget {
  final MenuItem item;
  final AllergyResult? result;
  final VoidCallback? onEdit;
  final bool compact;
  const ResultCard({
    super.key,
    required this.item,
    this.result,
    this.onEdit,
    this.compact = false,
  });
  @override
  Widget build(BuildContext context) {
    final style = resultStyle(result?.status ?? AllergyStatus.pending);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0b182635),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: style.color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.section?.isNotEmpty == true) ...[
                      Text(
                        item.section!,
                        style: const TextStyle(
                          color: BiteColors.green,
                          fontSize: 11,
                          letterSpacing: .7,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                    if (result != null) ...[
                      StatusPill(
                        label: style.label,
                        color: style.color,
                        background: style.background,
                        icon: style.icon,
                      ),
                      const SizedBox(height: 9),
                    ],
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.priceLabel,
                          style: const TextStyle(
                            color: BiteColors.muted,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        if (onEdit != null)
                          IconButton(
                            tooltip: 'Corregir producto',
                            visualDensity: VisualDensity.compact,
                            onPressed: onEdit,
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: BiteColors.green,
                              size: 19,
                            ),
                          ),
                      ],
                    ),
                    if (item.description?.isNotEmpty == true) ...[
                      const SizedBox(height: 5),
                      const Text(
                        'DESCRIPCIÓN DEL MENÚ',
                        style: TextStyle(
                          fontSize: 10,
                          color: BiteColors.muted,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .35,
                        ),
                      ),
                      Text(
                        item.description!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: BiteColors.muted,
                          height: 1.4,
                        ),
                      ),
                    ],
                    if (result != null) ...[
                      const SizedBox(height: 9),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: style.background.withValues(alpha: .56),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(style.icon, color: style.color, size: 19),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                result!.reason,
                                maxLines: compact ? 3 : null,
                                overflow: compact
                                    ? TextOverflow.ellipsis
                                    : null,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
