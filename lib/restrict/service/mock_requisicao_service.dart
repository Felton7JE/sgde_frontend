// Serviço mock para Requisição
import '../models/requisicao_dto.dart';

class MockRequisicaoService {
  static final List<RequisicaoDTO> _requisicoes = [
    RequisicaoDTO(
      id: 1,
      dataRequisicao: DateTime(2025, 5, 12),
      quantidade: 1,
      justificativaRequisicao: 'Necessidade de uso',
      status: 'Pendente',
      status2: null,
      responsavel: 'João',
      nomeEquipamento: 'Notebook',
      modeloEquipamento: 'Dell XPS',
      tipoEquipamento: 'Informática',
      descricaoEquipamento: 'Notebook para trabalho remoto',
    ),
    RequisicaoDTO(
      id: 2,
      dataRequisicao: DateTime(2025, 4, 22),
      quantidade: 2,
      justificativaRequisicao: 'Reunião',
      status: 'Aprovada',
      status2: null,
      responsavel: 'Maria',
      nomeEquipamento: 'Projetor',
      modeloEquipamento: 'Epson',
      tipoEquipamento: 'Audiovisual',
      descricaoEquipamento: 'Projetor para apresentação',
    ),
  ];

  Future<List<RequisicaoDTO>> listarRequisicoes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_requisicoes);
  }

  Future<List<RequisicaoDTO>> buscarTodasRequisicoes() async {
    return listarRequisicoes();
  }

  Future<void> criarRequisicao(RequisicaoDTO requisicao) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _requisicoes.add(requisicao);
  }

  Future<void> salvarRequisicao(RequisicaoDTO dto) async {
    await criarRequisicao(dto);
  }

  Future<void> atualizarRequisicao(RequisicaoDTO dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _requisicoes.indexWhere((r) => r.id == dto.id);
    if (idx != -1) {
      _requisicoes[idx] = dto;
    }
  }

  Future<void> removerRequisicao(RequisicaoDTO dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _requisicoes.removeWhere((r) => r.id == dto.id);
  }
}
