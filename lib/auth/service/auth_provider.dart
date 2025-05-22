import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/auth/models/login.dart';
import 'package:cetic_sgde_front/auth/models/cadastro.dart';
import 'package:cetic_sgde_front/auth/service/mock_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final MockAuthService _mockAuthService = MockAuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<String> registrarUsuario(UsuarioCadastroModel usuario) async {
    _isLoading = true;
    notifyListeners();
    try {
      final sucesso = await _mockAuthService.cadastrar(usuario);
      if (sucesso) {
        return 'Usuário cadastrado com sucesso (simulado)';
      } else {
        throw Exception('Erro ao cadastrar usuário (simulado)');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(LoginCredenciaisModel credenciais) async {
    _isLoading = true;
    notifyListeners();
    try {
      final sucesso = await _mockAuthService.login(credenciais);
      if (!sucesso) {
        throw Exception('Usuário ou senha inválidos (simulado)');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verificar2FA(dynamic _) async {
    return;
  }

  void logout() {
    notifyListeners();
  }
}
