import 'dart:math';

class CodigoService {
  static const _codigos = ['1957', '4821', '7305', '2468', '9134'];
  static String? _actual;

  static String generar() => _actual = _codigos[Random().nextInt(_codigos.length)];
  static bool validar(String c) => _actual != null && c == _actual;
  static void limpiar() => _actual = null;
}