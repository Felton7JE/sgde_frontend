// lib/auth/service/mock_auth_service.dart
// Serviço de autenticação mock para testes sem backend

import '../models/login.dart';
import '../models/cadastro.dart';

class MockAuthService {
  // Usuário fixo para login
  static const String _emailFixo = 'teste@teste.com';
  static const String _senhaFixa = '123456';

  // Simula login
  Future<bool> login(LoginCredenciaisModel login) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return login.email == _emailFixo && login.senha == _senhaFixa;
  }

  // Simula cadastro (aceita qualquer dado, mas não armazena)
  Future<bool> cadastrar(UsuarioCadastroModel cadastro) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Sempre retorna sucesso
    return true;
  }

  // Simula recuperação de senha
  Future<bool> recuperarSenha(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Sempre retorna sucesso
    return true;
  }
}
