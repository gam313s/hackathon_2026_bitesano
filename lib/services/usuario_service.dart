import '../models/usuario.dart';

class UsuarioService {
  static final List<Usuario> _usuarios = [
    const Usuario(nombre: 'Pedro', correo: 'Pedro@gmail.com', password: 'pedro21'),
    const Usuario(nombre: 'María González', correo: 'maria@gmail.com', password: 'maria\$12'),
  ];

  static Usuario? usuarioActual;

  static bool registrar(Usuario nuevo) {
    if (_usuarios.any((u) => u.correo == nuevo.correo)) return false;
    _usuarios.add(nuevo);
    return true;
  }

  static Usuario? iniciarSesion(String correo, String password) {
    for (final u in _usuarios) {
      if (u.correo == correo && u.password == password) {
        usuarioActual = u;
        return u;
      }
    }
    return null;
  }

  static bool existeCorreo(String correo) => _usuarios.any((u) => u.correo == correo);

  static bool cambiarPassword(String correo, String nueva) {
    final i = _usuarios.indexWhere((u) => u.correo == correo);
    if (i == -1 || _usuarios[i].password == nueva) return false;
    _usuarios[i] = Usuario(nombre: _usuarios[i].nombre, correo: correo, password: nueva);
    return true;
  }
}