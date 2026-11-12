import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl =
      'https://hair4hope-backend.onrender.com';

  // Chaves do SharedPreferences
  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  // Registrar usuario
  static Future<Map<String, dynamic>> registrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final url = Uri.parse('$_baseUrl/usuario/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'message': data['message']};
    } else {
      final msg = data['detail'] ?? data['message'] ?? 'Erro ao registrar';
      return {'success': false, 'message': msg.toString()};
    }
  }

  // Logar usuario
  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final url = Uri.parse('$_baseUrl/usuario/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'senha': senha,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Salvar tokens no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, data['access_token'] ?? '');
      await prefs.setString(_refreshTokenKey, data['refresh_token'] ?? '');

      // Buscar dados do usuario logado
      await _fetchAndSaveUserData(prefs);

      return {'success': true, 'message': data['message']};
    } else {
      final msg = data['detail'] ?? data['message'] ?? 'Erro ao fazer login';
      return {'success': false, 'message': msg.toString()};
    }
  }

  // Buscar dados do usuario e salvar local
  static Future<void> _fetchAndSaveUserData(SharedPreferences prefs) async {
    final token = prefs.getString(_tokenKey) ?? '';
    if (token.isEmpty) return;

    try {
      final url = Uri.parse('$_baseUrl/usuario/whoami');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString(_userNameKey, data['nome'] ?? '');
        await prefs.setString(_userEmailKey, data['email'] ?? '');
      }
    } catch (e) {
      // Ignora erros ao buscar dados do usuario
    }
  }

  // Verificar se está logado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey) ?? '';
    return token.isNotEmpty;
  }

  // Pegar o token salvo
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? '';
  }

  // Pegar nome do usuario salvo
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey) ?? '';
  }

  // Pegar email do usuario salvo
  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey) ?? '';
  }

  // Refresh token
  static Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey) ?? '';
    if (token.isEmpty) return false;

    try {
      final url = Uri.parse('$_baseUrl/usuario/refresh');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tokens = data['tokens'];
        if (tokens != null) {
          await prefs.setString(_tokenKey, tokens['access_token'] ?? '');
          await prefs.setString(_refreshTokenKey, tokens['refresh_token'] ?? '');
        }
        return true;
      }
    } catch (e) {
      // Erro ao dar refresh
    }
    return false;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }
}
