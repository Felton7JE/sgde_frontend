import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/restrict/service/mock_manutencao_service.dart';
import 'package:cetic_sgde_front/restrict/models/manutencao_dto.dart';

class ManutencaoProvider extends ChangeNotifier {
  final MockManutencaoService _service = MockManutencaoService();
  List<ManutencaoDTO> _manutencoes = [];
  bool _isLoading = false;
  String? _erro;

  List<ManutencaoDTO> get manutencoes => _manutencoes;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  Future<void> carregarManutencoesDTO() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      _manutencoes = await _service.listarManutencoesDTO();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> criarManutencaoDTO(ManutencaoDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.criarManutencaoDTO(dto);
      await carregarManutencoesDTO();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarManutencaoDTO(ManutencaoDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.atualizarManutencaoDTO(dto);
      await carregarManutencoesDTO();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removerManutencaoDTO(ManutencaoDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.removerManutencaoDTO(dto);
      await carregarManutencoesDTO();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
