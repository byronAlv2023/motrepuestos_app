import 'package:flutter/material.dart';
import '../../core/utils/session_service.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> iniciarSesion() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    // Validación básica
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _errorMessage = 'Por favor ingrese email y contraseña';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Simulación de autenticación
    await Future.delayed(const Duration(seconds: 1));

    // Guardar sesión (comentado temporalmente si da error)
    // await SessionService.guardarSesion(emailController.text);

    _isLoading = false;
    notifyListeners();

    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
