// Serviço mock para Manutenção
import '../models/manutencao_dto.dart';

class MockManutencaoService {
  static final List<ManutencaoDTO> _manutencoes = [
    ManutencaoDTO(
      numeroSerie: 'EQP001',
      tipoManutencao: 'Preventiva',
      dataManutencao: DateTime(2025, 5, 2),
      descricaoManutencao: 'Troca de HD',
      responsavel: 'Carlos',
      status: 'Pendente',
      tempoInatividade: 2,
    ),
    ManutencaoDTO(
      numeroSerie: 'EQP002',
      tipoManutencao: 'Corretiva',
      dataManutencao: DateTime(2025, 4, 18),
      descricaoManutencao: 'Limpeza',
      responsavel: 'Ana',
      status: 'Concluída',
      tempoInatividade: 1,
    ),
  ];

  Future<List<ManutencaoDTO>> listarManutencoes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_manutencoes);
  }

  Future<List<ManutencaoDTO>> listarManutencoesDTO() async {
    return listarManutencoes();
  }

  Future<void> criarManutencao(ManutencaoDTO manutencao) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _manutencoes.add(manutencao);
  }

  Future<void> criarManutencaoDTO(ManutencaoDTO dto) async {
    await criarManutencao(dto);
  }

  Future<void> atualizarManutencaoDTO(ManutencaoDTO dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _manutencoes.indexWhere((m) => m.numeroSerie == dto.numeroSerie);
    if (idx != -1) {
      _manutencoes[idx] = dto;
    }
  }

  Future<void> removerManutencao(ManutencaoDTO manutencao) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _manutencoes.removeWhere((m) => m.numeroSerie == manutencao.numeroSerie);
  }

  Future<void> removerManutencaoDTO(ManutencaoDTO dto) async {
    await removerManutencao(dto);
  }
}
