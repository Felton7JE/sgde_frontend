// Serviço mock para Equipamento
import '../models/modelEquipamento.dart';

class MockEquipamentoService {
  static final List<Equipamento> _equipamentos = [
    Equipamento(numeroSerie: 'EQP001', nome: 'Notebook', status: 'Disponível'),
    Equipamento(numeroSerie: 'EQP002', nome: 'Projetor', status: 'Em uso'),
  ];

  Future<List<Equipamento>> listarEquipamentos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_equipamentos);
  }

  Future<void> criarEquipamento(Equipamento equipamento) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _equipamentos.add(equipamento);
  }

  Future<void> deletarEquipamento(Equipamento equipamento) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _equipamentos.removeWhere((e) => e.numeroSerie == equipamento.numeroSerie);
  }

  Future<void> atualizarEquipamento(Equipamento equipamento) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _equipamentos.indexWhere((e) => e.numeroSerie == equipamento.numeroSerie);
    if (idx != -1) {
      _equipamentos[idx] = equipamento;
    }
  }

  Future<Equipamento?> buscarEquipamentoPorNumeroSerie(Equipamento equipamento) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _equipamentos.firstWhere((e) => e.numeroSerie == equipamento.numeroSerie);
    } catch (_) {
      return null;
    }
  }

  Future<List<Equipamento>> pesquisarEquipamentos(String atributo, String valor) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _equipamentos.where((e) {
      switch (atributo) {
        case 'nome':
          return e.nome.toLowerCase().contains(valor.toLowerCase());
        case 'numeroSerie':
          return e.numeroSerie.toLowerCase().contains(valor.toLowerCase());
        case 'categoria':
          return (e.categoria ?? '').toLowerCase().contains(valor.toLowerCase());
        case 'marca':
          return (e.marca ?? '').toLowerCase().contains(valor.toLowerCase());
        default:
          return false;
      }
    }).toList();
  }
}
