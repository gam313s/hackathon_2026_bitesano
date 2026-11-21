import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../data/catalog.dart';
import '../models/account.dart';
import '../models/menu.dart';
import '../models/profile.dart';
import '../models/analysis_snapshot.dart';
import '../repositories/catalog_repository.dart';
import '../repositories/food_repository.dart';
import '../services/auth_service.dart';
import '../services/menu_ocr_service.dart';
import '../services/preferences_service.dart';
import '../utils/food_text.dart';
import '../utils/profile_validation.dart';

class BiteSanoController extends ChangeNotifier {
  final FoodRepository repository;
  final MenuOcrService _ocr;
  final PreferencesService _preferences;
  final ImagePicker _picker;
  final AuthService _auth;
  final CatalogRepository _catalog;
  BiteSanoController({
    FoodRepository? repository,
    MenuOcrService? ocr,
    PreferencesService? preferences,
    ImagePicker? picker,
    AuthService? auth,
    CatalogRepository? catalog,
  }) : repository = repository ?? FoodRepository(),
       _ocr = ocr ?? MenuOcrService(),
       _preferences = preferences ?? PreferencesService(),
       _picker = picker ?? ImagePicker(),
       _auth = auth ?? SqliteAuthService(),
       _catalog = catalog ?? CatalogRepository();

  bool ready = false;
  bool signedIn = false;
  String name = 'Invitado';
  String email = '';
  bool remember = true;
  bool crossContact = true;
  bool alerts = true;
  bool useOnline = false;
  final Map<String, AllergySeverity> allergies = {};
  final List<AnalysisSnapshot> history = [];
  List<MenuItem> items = [];
  final Map<MenuItem, AllergyResult> results = {};
  bool busy = false;
  bool analysisStarted = false;
  bool demo = false;
  String? error;
  Uint8List? image;
  MenuFilter filter = MenuFilter.all;
  bool _disposed = false;

  AllergyProfile get profile => AllergyProfile(
    name: name,
    email: email,
    allergies: Map.of(allergies),
    crossContact: crossContact,
    offline: !useOnline,
    alerts: alerts,
  );
  Set<String> get selected => allergies.keys.toSet();
  List<MenuItem> get visible => filterMenuItems(items, results, filter);
  int count(MenuFilter value) => filterMenuItems(items, results, value).length;
  int get pending => items.length - results.length;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  /// Lee el catálogo de alimentos y alérgenos desde SQLite. Si la base no está
  /// disponible, la app sigue con el catálogo incluido en lib/data.
  Future<void> _loadCatalog() async {
    try {
      final loaded = await _catalog.load();
      if (!_disposed) currentCatalog = loaded;
    } catch (_) {
      // Se conserva el catálogo incluido.
    }
  }

  Future<void> initialize() async {
    await _loadCatalog();
    final stored = await _preferences.load();
    if (_disposed) return;
    if (stored != null &&
        validateProfileName(stored.name) == null &&
        validateOptionalEmail(stored.email) == null) {
      name = stored.name;
      email = stored.email;
      allergies.addAll(stored.allergies);
      crossContact = stored.crossContact;
      alerts = stored.alerts;
      useOnline = !stored.offline;
      signedIn = true;
    }
    ready = true;
    _notify();
  }

  Future<bool> enter(String displayName, String address, bool keep) async {
    if (validateProfileName(displayName) != null ||
        validateOptionalEmail(address) != null ||
        _disposed)
      return false;
    name = displayName.trim();
    email = address.trim();
    remember = keep;
    signedIn = true;
    _notify();
    await saveProfile();
    return true;
  }

  /// Devuelve null si todo salió bien, o el mensaje de error para mostrar.
  Future<String?> login(String identifier, String password, bool keep) =>
      _authenticate(() => _auth.login(identifier, password), keep);

  /// Crea la cuenta SIN iniciar sesión: el usuario debe entrar desde el acceso.
  /// Devuelve null si todo salió bien, o el mensaje de error para mostrar.
  Future<String?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    if (_disposed) return 'Inténtalo de nuevo';
    try {
      await _auth.register(username: username, email: email, password: password);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'No se pudo acceder a la base de datos de este dispositivo.';
    }
  }

  Future<String?> _authenticate(Future<Account> Function() action, bool keep) async {
    if (_disposed) return 'Inténtalo de nuevo';
    try {
      final account = await action();
      name = account.username;
      email = account.email;
      remember = keep;
      signedIn = true;
      _notify();
      await saveProfile();
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'No se pudo acceder a la base de datos de este dispositivo.';
    }
  }

  Future<void> saveProfile() async {
    if (remember) await _preferences.save(profile);
  }

  Future<void> signOut() async {
    if (busy) return;
    await _preferences.clear();
    signedIn = false;
    name = 'Invitado';
    email = '';
    allergies.clear();
    history.clear();
    items = [];
    results.clear();
    image = null;
    demo = false;
    remember = true;
    useOnline = false;
    alerts = true;
    crossContact = true;
    analysisStarted = false;
    filter = MenuFilter.all;
    error = null;
    _notify();
  }

  void _invalidate() {
    results.clear();
    analysisStarted = false;
    filter = MenuFilter.all;
    error = null;
  }

  bool addAllergy(
    String value, [
    AllergySeverity severity = AllergySeverity.high,
  ]) {
    final trimmed = value.trim();
    if (validateCustomAllergy(trimmed) != null || busy) return false;
    if (allergies.keys.any(
      (key) => normalizeFood(key) == normalizeFood(trimmed),
    ))
      return false;
    allergies[trimmed] = severity;
    _invalidate();
    _notify();
    saveProfile();
    return true;
  }

  void removeAllergy(String value) {
    if (busy) return;
    allergies.remove(value);
    _invalidate();
    _notify();
    saveProfile();
  }

  void setSeverity(String value, AllergySeverity severity) {
    if (busy || !allergies.containsKey(value)) return;
    allergies[value] = severity;
    _notify();
    saveProfile();
  }

  void setCrossContact(bool value) {
    crossContact = value;
    _notify();
    saveProfile();
  }

  void setAlerts(bool value) {
    alerts = value;
    _notify();
    saveProfile();
  }

  void setOnline(bool value) {
    if (busy) return;
    useOnline = value;
    _invalidate();
    if (value) repository.remote.resetConnection();
    _notify();
    saveProfile();
  }

  void setFilter(MenuFilter value) {
    filter = value;
    _notify();
  }

  Future<void> pick(ImageSource source) async {
    if (busy) return;
    busy = true;
    error = null;
    _notify();
    try {
      final selected = await _picker.pickImage(
        source: source,
        imageQuality: 90,
      );
      if (selected == null || _disposed) return;
      final bytes = await selected.readAsBytes();
      final products = await _ocr.read(selected.path);
      if (_disposed) return;
      image = bytes;
      items = products;
      demo = false;
      _invalidate();
      if (items.isEmpty)
        error = 'No se encontraron productos. Prueba una foto más clara.';
      else if (items.every((p) => p.price == null))
        error = 'No se detectaron precios; conservamos los nombres.';
    } catch (_) {
      if (!_disposed) error = 'No se pudo leer la imagen. Verifica los permisos o intenta otra foto.';
    } finally {
      busy = false;
      _notify();
    }
  }

  void loadDemo() {
    if (busy) return;
    image = null;
    demo = true;
    items = List.of(currentCatalog.demoMenu);
    _invalidate();
    _notify();
  }

  void edit(MenuItem? original, MenuItem? updated) {
    if (busy || demo) return;
    if (original == null && updated != null) {
      items.add(updated);
    } else if (original != null && items.contains(original)) {
      final idx = items.indexOf(original);
      if (updated == null)
        items.removeAt(idx);
      else
        items[idx] = updated;
    }
    _invalidate();
    _notify();
  }

  Future<bool> analyze() async {
    if (busy || items.isEmpty || allergies.isEmpty) return false;
    busy = true;
    error = null;
    results.clear();
    analysisStarted = true;
    filter = MenuFilter.all;
    _notify();
    final currentItems = List<MenuItem>.of(items);
    final currentAllergies = selected;
    try {
      for (final item in currentItems) {
        if (_disposed) return false;
        try {
          results[item] = await repository.analyze(
            item,
            currentAllergies,
            demo: demo,
            useOnline: useOnline,
          );
        } catch (_) {
          results[item] = const AllergyResult(
            AllergyStatus.insufficient,
            'No fue posible analizar esta referencia.',
          );
        }
        _notify();
      }
      if (_disposed) return false;
      history.insert(
        0,
        AnalysisSnapshot(
          title: demo ? 'Menú de demostración' : 'Menú escaneado',
          time: DateTime.now(),
          items: items,
          results: results,
          allergies: currentAllergies,
          demo: demo,
        ),
      );
      return true;
    } finally {
      busy = false;
      _notify();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _ocr.close();
    super.dispose();
  }
}
