// Serviço mock para Alocação
import '../models/alocacao_dto.dart';

class MockAlocacaoService {
  static final List<AlocacaoDTO> _alocacoes = [
    AlocacaoDTO(
      numeroSerie: 'EQP001',
      localAlocado: 'Sala 101',
      usuario: 'João',
      dataAlocacao: DateTime(2025, 5, 5),
      status: 'Alocado',
      status2: null,
    ),
    AlocacaoDTO(
      numeroSerie: 'EQP002',
      localAlocado: 'Sala 202',
      usuario: 'Maria',
      dataAlocacao: DateTime(2025, 4, 10),
      status: 'Livre',
      status2: null,
    ),
  ];

  Future<List<AlocacaoDTO>> listarAlocacoes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_alocacoes);
  }

  Future<void> criarAlocacao(AlocacaoDTO alocacao) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _alocacoes.add(alocacao);
  }

  Future<void> adicionarAlocacao(AlocacaoDTO dto) async {
    await criarAlocacao(dto);
  }

  Future<void> atualizarAlocacao(AlocacaoDTO dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _alocacoes.indexWhere((a) => a.numeroSerie == dto.numeroSerie);
    if (idx != -1) {
      _alocacoes[idx] = dto;
    }
  }

  Future<void> removerAlocacao(AlocacaoDTO alocacao) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _alocacoes.removeWhere((a) => a.numeroSerie == alocacao.numeroSerie);
  }

  Future<void> excluirAlocacao(AlocacaoDTO dto) async {
    await removerAlocacao(dto);
  }
}
