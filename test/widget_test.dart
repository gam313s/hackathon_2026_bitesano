import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_2026_bitesano/main.dart';

void main() {
  testWidgets('Splash displays the BiteSano logo', (WidgetTester tester) async {
    await tester.pumpWidget(const BiteSanoApp());

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/bitesano_logo.png',
      ),
      findsOneWidget,
    );

    await tester.pumpWidget(const SizedBox());
  });
}
