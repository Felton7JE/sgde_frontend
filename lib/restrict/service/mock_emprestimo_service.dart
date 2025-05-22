// Serviço mock para Empréstimo
import '../models/emprestimo_dto.dart';

class MockEmprestimoService {
  static final List<EmprestimoDTO> _emprestimos = [
    EmprestimoDTO(
      numeroSerie: 'EQP001',
      responsavel: 'João',
      dataEmprestimo: DateTime(2025, 5, 10),
      quantidade: 1,
      dataDevolucao: DateTime(2025, 5, 20),
      justificativaEmprestimo: 'Uso em evento',
      status: 'Ativo',
      quemFezEmprestimo: 'João',
      status2: null,
    ),
    EmprestimoDTO(
      numeroSerie: 'EQP002',
      responsavel: 'Maria',
      dataEmprestimo: DateTime(2025, 4, 15),
      quantidade: 2,
      dataDevolucao: DateTime(2025, 4, 25),
      justificativaEmprestimo: 'Reunião',
      status: 'Finalizado',
      quemFezEmprestimo: 'Maria',
      status2: null,
    ),
  ];

  Future<List<EmprestimoDTO>> listarEmprestimos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_emprestimos);
  }

  Future<List<EmprestimoDTO>> listarEmprestimosDTO() async {
    return listarEmprestimos();
  }

  Future<void> criarEmprestimo(EmprestimoDTO emprestimo) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _emprestimos.add(emprestimo);
  }

  Future<void> criarEmprestimoDTO(EmprestimoDTO dto) async {
    await criarEmprestimo(dto);
  }

  Future<void> atualizarEmprestimoDTO(EmprestimoDTO dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _emprestimos.indexWhere((e) => e.numeroSerie == dto.numeroSerie);
    if (idx != -1) {
      _emprestimos[idx] = dto;
    }
  }

  Future<void> removerEmprestimo(EmprestimoDTO emprestimo) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _emprestimos.removeWhere((e) => e.numeroSerie == emprestimo.numeroSerie);
  }

  Future<void> removerEmprestimoDTO(EmprestimoDTO dto) async {
    await removerEmprestimo(dto);
  }

  Future<List<EmprestimoDTO>> buscarEmprestimosPorStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _emprestimos.where((e) => e.status == status).toList();
  }
}
