import 'package:cetic_sgde_front/restrict/models/alocacao_dto.dart';
import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/restrict/service/alocacao_service.dart';

class AlocacaoProvider extends ChangeNotifier {
  final AlocacaoService _service = AlocacaoService();
  List<AlocacaoDTO> _alocacoes = [];
  bool _isLoading = false;
  String? _erro;

  List<AlocacaoDTO> get alocacoes => _alocacoes;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  Future<void> carregarAlocacoes() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      _alocacoes = await _service.listarAlocacoes();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarAlocacao(AlocacaoDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.adicionarAlocacao(dto);
      await carregarAlocacoes();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removerAlocacao(AlocacaoDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.excluirAlocacao(dto);
      await carregarAlocacoes();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> criarAlocacao(AlocacaoDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.adicionarAlocacao(dto); // Supondo que o backend decide se é criação ou atualização
      await carregarAlocacoes();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
