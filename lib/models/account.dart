/// Cuenta de usuario. Nunca guarda la contraseña en texto plano.
class Account {
  final int id;
  final String username;
  final String email;
  const Account({required this.id, required this.username, required this.email});
}
