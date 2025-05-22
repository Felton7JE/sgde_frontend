// Serviço mock para Avaria
import '../models/avaria_dto.dart';

class MockAvariaService {
  static final List<AvariaDTO> _avarias = [
    AvariaDTO(
      numeroSerie: 'EQP001',
      departamento: 'TI',
      data: DateTime(2025, 5, 1),
      tipoAvaria: 'Hardware',
      descricaoAvaria: 'Tela quebrada',
      gravidade: 'Alta',
      status: 'Aberta',
      status2: null,
    ),
    AvariaDTO(
      numeroSerie: 'EQP002',
      departamento: 'Admin',
      data: DateTime(2025, 4, 20),
      tipoAvaria: 'Bateria',
      descricaoAvaria: 'Bateria ruim',
      gravidade: 'Média',
      status: 'Fechada',
      status2: null,
    ),
  ];

  Future<List<AvariaDTO>> listarAvarias() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_avarias);
  }

  Future<void> criarAvaria(AvariaDTO avaria) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _avarias.add(avaria);
  }

  Future<void> removerAvaria(AvariaDTO avaria) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _avarias.removeWhere((a) => a.numeroSerie == avaria.numeroSerie);
  }

  Future<void> criarAvariaDTO(AvariaDTO dto) async {
    await criarAvaria(dto);
  }

  Future<void> atualizarAvariaDTO(AvariaDTO dto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _avarias.indexWhere((a) => a.numeroSerie == dto.numeroSerie);
    if (idx != -1) {
      _avarias[idx] = dto;
    }
  }

  Future<void> removerAvariaDTO(AvariaDTO dto) async {
    await removerAvaria(dto);
  }
}
