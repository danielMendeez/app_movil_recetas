import 'package:flutter/foundation.dart';
import '../../models/auth/register_request.dart';
import '../../models/user.dart';
import '../../services/auth/auth_register_service.dart';
import '../../services/auth/secure_storage_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRegisterService _authRegisterService = AuthRegisterService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _nombreError;
  String? _apellidoError;
  String? _correoError;
  String? _passwordError;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get nombreError => _nombreError;
  String? get apellidoError => _apellidoError;
  String? get correoError => _correoError;
  String? get passwordError => _passwordError;

  // Métodos para limpiar errores específicos
  void clearNombreError() {
    _nombreError = null;
    notifyListeners();
  }

  void clearApellidoError() {
    _apellidoError = null;
    notifyListeners();
  }

  void clearCorreoError() {
    _correoError = null;
    notifyListeners();
  }

  void clearPasswordError() {
    _passwordError = null;
    notifyListeners();
  }

  void clearAllErrors() {
    _errorMessage = null;
    _nombreError = null;
    _apellidoError = null;
    _correoError = null;
    _passwordError = null;
    notifyListeners();
  }

  // Validación del formulario
  bool validateForm({
    required String nombre,
    required String apellido,
    required String correo,
    required String password,
  }) {
    clearAllErrors();

    bool isValid = true;

    // Validar nombre
    if (nombre.isEmpty) {
      _nombreError = 'Por favor ingresa tu nombre';
      isValid = false;
    }

    // Validar apellido
    if (apellido.isEmpty) {
      _apellidoError = 'Por favor ingresa tu apellido';
      isValid = false;
    }

    // Validar correo
    if (correo.isEmpty) {
      _correoError = 'Por favor ingresa tu correo electrónico';
      isValid = false;
    } else if (!_isValidEmail(correo)) {
      _correoError = 'Por favor ingresa un correo electrónico válido';
      isValid = false;
    }

    // Validar contraseña
    if (password.isEmpty) {
      _passwordError = 'Por favor ingresa tu contraseña';
      isValid = false;
    } else if (password.length < 12) {
      _passwordError = 'La contraseña debe tener al menos 12 caracteres';
      isValid = false;
    }

    if (!isValid) {
      notifyListeners();
    }

    return isValid;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<User?> register({
    required String nombre,
    required String apellido,
    required String correo,
    required String password,
  }) async {
    // Primero validar el formulario
    if (!validateForm(
      nombre: nombre,
      apellido: apellido,
      correo: correo,
      password: password,
    )) {
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final registerRequest = RegisterRequest(
        nombre: nombre,
        apellido: apellido,
        correo: correo,
        password: password,
      );

      final user = await _authRegisterService.register(registerRequest);

      if (user != null) {
        // Guardar token de sesión sólo si viene en la respuesta
        if (user.token.isNotEmpty) {
          await SecureStorageService.saveToken(user.token);
        }
        await SecureStorageService.saveUser(user);
      }

      _isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }
}
