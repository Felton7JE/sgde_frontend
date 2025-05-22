import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/auth/models/login.dart';
import 'package:cetic_sgde_front/auth/models/twofactor.dart';
import 'package:cetic_sgde_front/auth/models/cadastro.dart';
import 'package:cetic_sgde_front/auth/service/auth.dart';

class AuthProvider extends ChangeNotifier {
  String? _tempToken;
  String? _finalToken;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  String? get tempToken => _tempToken;
  String? get finalToken => _finalToken;
  bool get isLoading => _isLoading;

  Future<String> registrarUsuario(UsuarioCadastroModel usuario) async {
    _isLoading = true;
    notifyListeners();
    try {
      return await _authService.registrarUsuario(usuario);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(LoginCredenciaisModel credenciais) async {
    _isLoading = true;
    notifyListeners();
    try {
      final accessToken = await _authService.login(credenciais);
      _tempToken = accessToken.token;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verificar2FA(TwoFactorAuthModel twoFactorAuth) async {
    if (_tempToken == null) {
      throw Exception('Token temporário não encontrado. Faça login primeiro.');
    }
    _isLoading = true;
    notifyListeners();
    try {
      final finalTokenModel = await _authService.verificarCodigo2FA(twoFactorAuth, tempToken: _tempToken);
      _finalToken = finalTokenModel.token;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _tempToken = null;
    _finalToken = null;
    notifyListeners();
  }
}
