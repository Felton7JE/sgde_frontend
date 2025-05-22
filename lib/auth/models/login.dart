// lib/models/auth/login_credenciais_model.dart
class LoginCredenciaisModel {
  final String email;
  final String senha;

  LoginCredenciaisModel({
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'senha': senha,
    };
  }
}