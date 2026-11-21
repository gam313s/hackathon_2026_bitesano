import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_2026_bitesano/main.dart';
import 'package:hackathon_2026_bitesano/screens/allergy_results_screen.dart';

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

  testWidgets('Allergy results render and handle mouse movement', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AllergyResultsScreen()));
    await tester.pumpAndSettle();

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(30, 30));
    await mouse.moveTo(const Offset(100, 100));
    await tester.pump();

    expect(find.text('Trattoria Bella Vista'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await mouse.removePointer();
  });

  testWidgets('Back button closes allergy results and returns to scanner', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => const AllergyResultsScreen(),
                ),
              ),
              child: const Text('Abrir escáner'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir escáner'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Volver al escáner'));
    await tester.pumpAndSettle();

    expect(find.text('Abrir escáner'), findsOneWidget);
    expect(find.text('Trattoria Bella Vista'), findsNothing);
  });
}
