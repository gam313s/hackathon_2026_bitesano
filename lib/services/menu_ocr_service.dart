import 'dart:math' as math;
import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/menu.dart';
import '../repositories/local_food_repository.dart';

/// Una línea OCR con su posición original en la imagen (píxeles).
class MenuOcrLine {
  final String text;
  final Rect box;
  const MenuOcrLine(this.text, this.box);
}

class _Candidate {
  String name;
  final Rect anchor;
  Rect box;
  String? price;
  String currency = r'$';
  String? section;
  final List<String> description = [];
  _Candidate(this.name, this.box, [this.price]) : anchor = box;
}

/// Líneas que describen un producto en vez de nombrar otro platillo.
bool _explicitDescription(String text) => RegExp(
  r'^(?:ingredientes?\b|ingredients?\b|al[eé]rgenos?\b|allergens?\b|contiene\b|contienen\b|contains\b|con\s+|servid[oa]s?\s+con\b|acompa[nñ]ad[oa]s?\s+(?:de|con)\b|incluye\b|rellen[oa]\s+de\b|prepared\s+with\b|served\s+with\b)',
  caseSensitive: false,
).hasMatch(text.trim());

bool _ingredientList(String text) {
  final commaCount = ','.allMatches(text).length;
  return (text.trim().endsWith(',') || commaCount >= 2) &&
      localFood(text) == null;
}

/// Independiente de ML Kit: se puede probar con rectángulos sintéticos.
List<MenuItem> reconstructMenu(List<MenuOcrLine> lines) {
  final valid = lines
      .where(
        (l) => l.text.trim().isNotEmpty && l.box.height > 0 && l.box.width > 0,
      )
      .toList();
  if (valid.isEmpty) return [];
  final heights = valid.map((l) => l.box.height).toList()..sort();
  final h = heights[heights.length ~/ 2];
  final money = RegExp(
    r'([\$€£])\s*(\d+(?:[.,]\d{1,2})?)|(\d+(?:[.,]\d{1,2})?)\s*([€£])',
  );
  final barePrice = RegExp(
    r'^(\d{2,4}(?:[.,]\d{1,2})?|\d(?:[.,]\d{1,2}))\s*(?:MXN)?$',
    caseSensitive: false,
  );
  final prices = <(String, Rect, String)>[];
  final names = <_Candidate>[];
  final headings = RegExp(
    r'^(?:men[uú](?: del (?:restaurante|d[ií]a))?|base de agua|saludables|smoothies|bebidas|caf[eé]s|postres|entradas|platos fuertes|desayunos|comidas|cenas|hamburguesas|tacos|antojitos|guisados|especialidades|comida mexicana|sopas|ensaladas|mariscos|pizzas|botanas|acompa[nñ]amientos|platillos|carnes|promociones|precios|precio|tapas|raciones|bocadillos|pinchos|montaditos|para compartir|primeros platos|segundos platos|platos principales|platos del d[ií]a|pescados y mariscos|c[oó]cteles|vinos|cervezas|entrantes|guarniciones|sandwiches|appetizers|starters|main courses|drinks|desserts|salads|sides)$',
    caseSensitive: false,
  );
  final size = RegExp(r'^\d+\s*(?:oz|0z|ml|l|g)$', caseSensitive: false);

  for (final line in valid) {
    final value = line.text.trim();
    final numeric = barePrice.firstMatch(value);
    if (numeric != null) {
      prices.add((numeric.group(1)!, line.box, r'$'));
      continue;
    }
    final matches = money.allMatches(value).toList();
    if (matches.isNotEmpty) {
      // Una línea puede incluir un nombre y un precio o solo el precio.
      // En la entrada real se conservan las cajas de las palabras monetarias.
      final match = matches.first;
      final amount = match.group(2) ?? match.group(3)!;
      final currency = match.group(1) ?? match.group(4)!;
      final before = value
          .substring(0, match.start)
          .replaceAll(RegExp(r'[.·\s]+$'), '')
          .trim();
      final after = value.substring(match.end).trim();
      if (before.isNotEmpty && RegExp(r'[A-Za-zÀ-ÿ]').hasMatch(before)) {
        names.add(_Candidate(before, line.box, amount)..currency = currency);
      } else {
        prices.add((amount, line.box, currency));
      }
      if (after.isNotEmpty && RegExp(r'[A-Za-zÀ-ÿ]').hasMatch(after)) {
        names.add(_Candidate(after, line.box));
      }
      continue;
    }
    if (size.hasMatch(value) || !RegExp(r'[A-Za-zÀ-ÿ]').hasMatch(value))
      continue;
    names.add(_Candidate(value, line.box));
  }

  // Detecta columnas por grupos de comienzos X, sin asumir que la foto tiene
  // un tamaño concreto. Solo se consideran columnas con varios nombres.
  final xStarts =
      names
          .where(
            (n) => !_explicitDescription(n.name) && !_ingredientList(n.name),
          )
          .map((n) => n.anchor.left)
          .toList()
        ..sort();
  final clusters = <List<double>>[];
  for (final x in xStarts) {
    if (clusters.isEmpty || x - clusters.last.first > h * 4.5) {
      clusters.add([x]);
    } else {
      clusters.last.add(x);
    }
  }
  final columns = clusters
      .where((cluster) => cluster.length >= 2)
      .map((cluster) => cluster.first)
      .toList();
  int columnOf(double x) {
    var index = 0;
    for (var i = 1; i < columns.length; i++) {
      if (x >= columns[i] - h * .5) index = i;
    }
    return index;
  }

  // Se comparan las filas por su centro vertical y únicamente hacia la derecha.
  // Una tolerancia relativa evita depender de la resolución de la fotografía.
  final pairs = <(double, int, int)>[];
  for (var i = 0; i < names.length; i++) {
    final n = names[i];
    if (n.price != null ||
        _explicitDescription(n.name) ||
        _ingredientList(n.name) ||
        n.name.startsWith('(') ||
        RegExp(r'''^["'“‘]''').hasMatch(n.name))
      continue;
    for (var j = 0; j < prices.length; j++) {
      final p = prices[j].$2;
      final dy = (n.anchor.center.dy - p.center.dy).abs();
      final dx = p.left - n.anchor.right;
      final tolerance = math.max(h, math.min(n.anchor.height, p.height)) * .8;
      final col = columnOf(n.anchor.left);
      if (columns.length > 1 &&
          col + 1 < columns.length &&
          p.left >= columns[col + 1] - h * .5)
        continue;
      final intervening = names.any(
        (other) =>
            other != n &&
            !headings.hasMatch(other.name) &&
            !_explicitDescription(other.name) &&
            !_ingredientList(other.name) &&
            other.anchor.left > n.anchor.left + h * 1.5 &&
            other.anchor.center.dx < p.center.dx &&
            (other.anchor.center.dy - p.center.dy).abs() <= tolerance,
      );
      if (intervening) continue;
      if (dx >= -h * .4 &&
          dy <= tolerance &&
          p.center.dx > n.anchor.center.dx) {
        // Prioriza cercanía vertical; usa la distancia horizontal para empates.
        pairs.add((dy / tolerance + math.max(0, dx) / h * .025, i, j));
      }
    }
  }
  pairs.sort((a, b) => a.$1.compareTo(b.$1));
  final used = <int>{};
  for (final pair in pairs) {
    final n = names[pair.$2];
    if (n.price == null && used.add(pair.$3)) {
      n.price = prices[pair.$3].$1;
      n.currency = prices[pair.$3].$3;
    }
  }

  // Las aclaraciones explícitas como (MINERAL) y las listas de sabores
  // entre comillas se agregan únicamente a un producto cercano arriba.
  names.sort((a, b) {
    final byColumn = columnOf(a.anchor.left).compareTo(columnOf(b.anchor.left));
    if (byColumn != 0) return byColumn;
    final y = a.box.top.compareTo(b.box.top);
    return y == 0 ? a.box.left.compareTo(b.box.left) : y;
  });
  final products = <_Candidate>[];
  final sections = <int, String>{};
  for (final n in names) {
    final column = columnOf(n.anchor.left);
    if (n.price == null && headings.hasMatch(n.name)) {
      sections[column] = n.name;
      continue;
    }
    _Candidate? parent;
    bool asDescription = false;
    final explicit = _explicitDescription(n.name);
    final list = _ingredientList(n.name);
    final annotation =
        n.name.startsWith('(') || RegExp(r'''^["'“‘]''').hasMatch(n.name);
    for (final p in products.reversed) {
      final gap = n.box.top - p.box.bottom;
      if (columnOf(n.anchor.left) != columnOf(p.anchor.left)) continue;
      if (p.section != sections[column]) continue;
      final aligned =
          (n.box.left - p.anchor.left).abs() <= h * 2 ||
          (n.box.left >= p.anchor.left && n.box.left < p.anchor.right);
      final knownWrap =
          n.price == null &&
          gap <= h * .45 &&
          localFood(p.name + ' ' + n.name) != null &&
          localFood(p.name) == null &&
          localFood(n.name) == null;
      final smallerText = n.box.height < p.anchor.height * .82;
      final listContinuation =
          p.description.isNotEmpty &&
          (smallerText ||
              (p.description.last.trim().endsWith(',') &&
                  RegExp(r'^[a-zà-ÿ]').hasMatch(n.name))) &&
          localFood(n.name) == null &&
          n.price == null;
      final description =
          explicit ||
          list ||
          listContinuation ||
          (smallerText &&
              localFood(n.name) == null &&
              RegExp(r'^[a-zà-ÿ]').hasMatch(n.name) &&
              n.name.split(' ').length >= 3);
      final flavorWrap =
          p.name.contains('"') &&
          n.price == null &&
          RegExp(
            r'^(?:(?:rojos|pl[aá]tano|fresa|mango)["\x27,\s]*)+$',
            caseSensitive: false,
          ).hasMatch(n.name) &&
          gap <= h * .35 &&
          aligned;
      if ((n.price == null || (explicit && p.price == null)) &&
          gap >= -h * .3 &&
          gap <= h * (explicit ? 2.5 : 1.5) &&
          aligned &&
          (annotation || flavorWrap || knownWrap || description)) {
        parent = p;
        asDescription = description && !annotation && !flavorWrap && !knownWrap;
        break;
      }
    }
    if (parent != null) {
      if (asDescription) {
        parent.description.add(n.name);
        if (parent.price == null && n.price != null) {
          parent.price = n.price;
          parent.currency = n.currency;
        }
      } else {
        parent.name += ' ${n.name}';
      }
      parent.box = parent.box.expandToInclude(n.box);
    } else if (!explicit && !list) {
      n.section = sections[column];
      products.add(n);
    }
  }
  return products
      .map(
        (p) => MenuItem(
          p.name,
          p.price,
          section: p.section,
          currency: p.currency,
          description: p.description.isEmpty
              ? null
              : p.description.join(' ').trim(),
        ),
      )
      .toList();
}

/// Separa los importes de una línea mixta usando las cajas de sus palabras.
/// Así una lectura como "$94 MOCHA" no asigna $94 a MOCHA.
Iterable<MenuOcrLine> _positionedLines(RecognizedText text) sync* {
  final money = RegExp(
    r'^(?:[\$€£]\s*\d+(?:[.,]\d{1,2})?|\d+(?:[.,]\d{1,2})?\s*[€£])$',
  );
  final number = RegExp(r'^\d+(?:[.,]\d{1,2})?$');
  for (final block in text.blocks) {
    for (final line in block.lines) {
      final words = line.elements.toList()
        ..sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
      if (words.isEmpty) {
        yield MenuOcrLine(line.text, line.boundingBox);
        continue;
      }
      final parts = <MenuOcrLine>[];
      var pending = <TextElement>[];
      void flush() {
        if (pending.isEmpty) return;
        final box = pending
            .map((w) => w.boundingBox)
            .reduce((a, b) => a.expandToInclude(b));
        parts.add(MenuOcrLine(pending.map((w) => w.text).join(' '), box));
        pending = [];
      }

      for (var i = 0; i < words.length; i++) {
        final w = words[i];
        final wordHeight = math.max(1.0, w.boundingBox.height);
        final gapBefore = i == 0
            ? 0.0
            : w.boundingBox.left - words[i - 1].boundingBox.right;
        final bigGap = gapBefore > wordHeight * 3.5;
        if (bigGap) flush();
        final looksLikeBarePrice =
            RegExp(r'^(?:\d{2,4}(?:[.,]\d{1,2})?|\d[.,]\d{1,2})$')
                .hasMatch(w.text.trim()) &&
            (i == words.length - 1 ||
                words[i + 1].boundingBox.left - w.boundingBox.right >
                    wordHeight * 2) &&
            gapBefore > wordHeight * .8;
        if (money.hasMatch(w.text.trim())) {
          flush();
          parts.add(MenuOcrLine(w.text, w.boundingBox));
        } else if ([r'$', '€', '£'].contains(w.text.trim()) &&
            i + 1 < words.length &&
            number.hasMatch(words[i + 1].text.trim())) {
          flush();
          final next = words[++i];
          parts.add(
            MenuOcrLine(
              '${w.text}${next.text}',
              w.boundingBox.expandToInclude(next.boundingBox),
            ),
          );
        } else if (number.hasMatch(w.text.trim()) &&
            i + 1 < words.length &&
            ['€', '£'].contains(words[i + 1].text.trim())) {
          flush();
          final next = words[++i];
          parts.add(
            MenuOcrLine(
              '${w.text}${next.text}',
              w.boundingBox.expandToInclude(next.boundingBox),
            ),
          );
        } else if (looksLikeBarePrice) {
          flush();
          parts.add(MenuOcrLine(w.text, w.boundingBox));
        } else {
          pending.add(w);
        }
      }
      flush();
      yield* parts;
    }
  }
}

class MenuOcrService {
  final _recognizer = TextRecognizer(script: TextRecognitionScript.latin);
  Future<List<MenuItem>> read(String path) async {
    final text = await _recognizer.processImage(InputImage.fromFilePath(path));
    return reconstructMenu(_positionedLines(text).toList());
  }

  Future<void> close() async {
    try {
      await _recognizer.close();
    } catch (_) {
      /* no recognizer on unsupported platforms */
    }
  }
}
