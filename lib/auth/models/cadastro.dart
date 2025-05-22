// lib/models/auth/usuario_cadastro_model.dart
class UsuarioCadastroModel {
  final String nome;
  final String email;
  final String senha;
  final String contato;

  UsuarioCadastroModel({
    required this.nome,
    required this.email,
    required this.senha,
    required this.contato,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      'contato': contato,
    };
  }
}