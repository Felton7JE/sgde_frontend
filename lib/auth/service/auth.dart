// lib/services/auth_service.dart
import 'dart:convert';
import 'package:cetic_sgde_front/auth/models/cadastro.dart';
import 'package:cetic_sgde_front/auth/models/login.dart';
import 'package:cetic_sgde_front/auth/models/senhaRecuperacao.dart';
import 'package:cetic_sgde_front/auth/models/token.dart';
import 'package:cetic_sgde_front/auth/models/twofactor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Interface para gerenciar tokens. Pode ser implementada com SharedPreferences, SecureStorage, etc.
abstract class TokenManager {
  Future<void> saveTempToken(String token);
  Future<String?> getTempToken();
  Future<void> clearTempToken();
  Future<void> saveFinalToken(String token);
  Future<String?> getFinalToken();
  Future<void> clearFinalToken();
}

// Implementação simples com variáveis estáticas (NÃO USE EM PRODUÇÃO, use SharedPreferences/SecureStorage)
class InMemoryTokenManager implements TokenManager {
  String? _tempToken;
  String? _finalToken;

  @override
  Future<String?> getFinalToken() async => _finalToken;
  @override
  Future<String?> getTempToken() async => _tempToken;
  @override
  Future<void> saveFinalToken(String token) async => _finalToken = token;
  @override
  Future<void> saveTempToken(String token) async => _tempToken = token;
  @override
  Future<void> clearFinalToken() async => _finalToken = null;
  @override
  Future<void> clearTempToken() async => _tempToken = null;
}

class SharedPreferencesTokenManager implements TokenManager {
  static const String _tempTokenKey = 'temp_token';
  static const String _finalTokenKey = 'final_token';

  @override
  Future<void> saveTempToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tempTokenKey, token);
  }

  @override
  Future<String?> getTempToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tempTokenKey);
  }

  @override
  Future<void> clearTempToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tempTokenKey);
  }

  @override
  Future<void> saveFinalToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_finalTokenKey, token);
  }

  @override
  Future<String?> getFinalToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_finalTokenKey);
  }

  @override
  Future<void> clearFinalToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_finalTokenKey);
  }
}

class AuthService {
  final String _baseUrl = "http://localhost:8080/autorizado"; // Exemplo para Web/Desktop

  final TokenManager _tokenManager;

  AuthService({TokenManager? tokenManager}) : _tokenManager = tokenManager ?? SharedPreferencesTokenManager();


  // POST /novousuario
  Future<String> registrarUsuario(UsuarioCadastroModel usuario) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/novousuario'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(usuario.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return utf8.decode(response.bodyBytes); // "Usuário cadastrado com sucesso..."
    } else if (response.statusCode == 409) {
      return utf8.decode(response.bodyBytes); // "O e-mail já está registrado..."
    } else {
      // Para outros erros (ex: 400 Bad Request), o corpo pode ser a mensagem genérica
      String errorMessage = "Erro ao registrar: ${response.statusCode}";
      try {
        errorMessage = utf8.decode(response.bodyBytes);
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }

  // GET /verificarusuario/{uuid}
  Future<String> verificarCadastro(String uuid) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/verificarusuario/$uuid'),
    );

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Falha ao verificar cadastro: ${response.statusCode} - ${utf8.decode(response.bodyBytes)}');
    }
  }

  // POST /login
  Future<AcessTokenModel> login(LoginCredenciaisModel credenciais) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(credenciais.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final accessToken = AcessTokenModel.fromJson(data);
      if (accessToken.token != null) {
        await _tokenManager.saveTempToken(accessToken.token!); // Salva o token temporário
      }
      return accessToken;
    } else {
      String errorMessage = "Erro de login: ${response.statusCode}";
       try {
        errorMessage = utf8.decode(response.bodyBytes);
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }

  // POST /verificar2fa
  Future<AcessTokenModel> verificarCodigo2FA(TwoFactorAuthModel twoFactorAuth, {String? tempToken}) async {
    final tempToken = await _tokenManager.getTempToken();
    if (tempToken == null) {
      throw Exception("Token temporário para 2FA não encontrado. Faça login primeiro.");
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/verificar2fa'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tempToken',
      },
      body: jsonEncode(twoFactorAuth.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final finalAccessToken = AcessTokenModel.fromJson(data);
      if (finalAccessToken.token != null) {
        await _tokenManager.saveFinalToken(finalAccessToken.token!);
      }
      return finalAccessToken;
    } else {
      String errorMessage = "Erro ao verificar 2FA: ${response.statusCode}";
      try {
        errorMessage = utf8.decode(response.bodyBytes);
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }

  // POST /recuperar
  Future<String> solicitarRecuperacaoSenha(EmailRecuperacaoModel emailDto) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/recuperar'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(emailDto.toJson()),
    );

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      String errorMessage = "Erro ao solicitar recuperação: ${response.statusCode}";
      try {
        errorMessage = utf8.decode(response.bodyBytes);
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }

  // POST /redefinirSenha/{token}
  Future<String> redefinirSenha(String tokenRecuperacao, String novaSenha) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/redefinirSenha/$tokenRecuperacao'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'novaSenha': novaSenha}),
    );

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      String errorMessage = "Erro ao redefinir senha: ${response.statusCode}";
      try {
        errorMessage = utf8.decode(response.bodyBytes);
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }

  // Método para obter o token final para usar em outros services
  Future<String?> getAuthToken() async {
    return _tokenManager.getFinalToken();
  }

  // Método para logout
  Future<void> logout() async {
    await _tokenManager.clearFinalToken();
    await _tokenManager.clearTempToken();
    // Adicionar aqui qualquer chamada de API para invalidar o token no backend, se houver.
  }
}