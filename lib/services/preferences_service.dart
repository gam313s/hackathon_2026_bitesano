import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/profile.dart';

/// Preferencias privadas de Android; no se presentan como una cuenta autenticada
/// ni como almacenamiento médico cifrado. En otras plataformas son de sesión.
class PreferencesService {
  static const _channel = MethodChannel('bitesano/preferences');
  Future<AllergyProfile?> load() async {
    try {
      final raw = await _channel
          .invokeMethod<String>('load')
          .timeout(const Duration(seconds: 2));
      if (raw == null) return null;
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final allergies = <String, AllergySeverity>{};
      final saved = json['allergies'];
      if (saved is Map) {
        for (final entry in saved.entries) {
          final severity = AllergySeverity.values.where(
            (v) => v.name == entry.value,
          );
          if (severity.isNotEmpty)
            allergies[entry.key.toString()] = severity.first;
        }
      }
      return AllergyProfile(
        name: json['name']?.toString() ?? 'Invitado',
        email: json['email']?.toString() ?? '',
        allergies: allergies,
        crossContact: json['crossContact'] != false,
        offline: json['offline'] != false,
        alerts: json['alerts'] != false,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> save(AllergyProfile profile) async {
    try {
      await _channel
          .invokeMethod(
            'save',
            jsonEncode({
              'name': profile.name,
              'email': profile.email,
              'allergies': profile.allergies.map((k, v) => MapEntry(k, v.name)),
              'crossContact': profile.crossContact,
              'offline': profile.offline,
              'alerts': profile.alerts,
            }),
          )
          .timeout(const Duration(seconds: 2));
    } catch (_) {
      /* sigue funcionando localmente durante la sesión */
    }
  }

  Future<void> clear() async {
    try {
      await _channel.invokeMethod('clear').timeout(const Duration(seconds: 2));
    } catch (_) {}
  }
}
