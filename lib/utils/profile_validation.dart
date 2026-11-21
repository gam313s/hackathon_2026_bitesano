String? validateProfileName(String? value) {
  final name = value?.trim() ?? '';
  if (name.isEmpty) return 'Escribe tu nombre';
  if (name.length < 2 || name.length > 80) return 'Usa entre 2 y 80 caracteres';
  if (RegExp(r'^[\d\s._-]+$').hasMatch(name) ||
      RegExp(r'[\x00-\x1f\x7f]').hasMatch(name))
    return 'Escribe un nombre válido';
  return null;
}

/// Valida formato, no la existencia ni la titularidad del correo.
String? validateOptionalEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return null;
  final parts = email.split('@');
  final valid =
      parts.length == 2 &&
      email.length <= 254 &&
      parts.first.length <= 64 &&
      RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+$").hasMatch(parts.first) &&
      !parts.first.startsWith('.') &&
      !parts.first.endsWith('.') &&
      !parts.first.contains('..') &&
      RegExp(
        r'^(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,63}$',
      ).hasMatch(parts.last);
  return valid ? null : 'Escribe un correo válido';
}

String? validateCustomAllergy(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Escribe el ingrediente';
  if (text.length > 80) return 'Máximo 80 caracteres';
  if (!RegExp(r'[a-zA-ZÀ-ÿ]').hasMatch(text) ||
      RegExp(r'[\x00-\x1f\x7f]').hasMatch(text))
    return 'Escribe un ingrediente válido';
  return null;
}

String? validateUsername(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Escribe un nombre de usuario';
  if (text.length < 3 || text.length > 30) return 'Usa entre 3 y 30 caracteres';
  if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(text)) {
    return 'Solo letras, números, punto, guion y guion bajo';
  }
  return null;
}

String? validateRequiredEmail(String? value) {
  if ((value?.trim() ?? '').isEmpty) return 'Escribe tu correo';
  return validateOptionalEmail(value);
}

String? validatePassword(String? value) {
  final text = value ?? '';
  if (text.isEmpty) return 'Escribe una contraseña';
  if (text.length < 8) return 'Mínimo 8 caracteres';
  if (text.length > 64) return 'Máximo 64 caracteres';
  if (!RegExp(r'[a-zA-Z]').hasMatch(text) || !RegExp(r'\d').hasMatch(text)) {
    return 'Combina letras y números';
  }
  return null;
}
