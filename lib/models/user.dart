class User {
  final int id;
  final String? nombre;
  final String? apellido;
  final String? correo;
  final String token;

  User({
    required this.id,
    this.nombre,
    this.apellido,
    this.correo,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final userData = json['usuario'] ?? json;

    return User(
      id: userData['id'],
      nombre: userData['nombre'] ?? '',
      apellido: userData['apellido'] ?? '',
      correo: userData['correo'] ?? '',
      token: (userData['token'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'apellido': apellido,
    'correo': correo,
    'token': token,
  };
}
