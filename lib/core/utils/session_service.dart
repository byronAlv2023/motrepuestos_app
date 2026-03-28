import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';

  // Guardar sesión
  static Future<void> guardarSesion(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userEmailKey, email);
  }

  // Verificar si hay sesión activa
  static Future<bool> haySesionActiva() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Obtener email del usuario
  static Future<String?> obtenerEmailUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Cerrar sesión
  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
