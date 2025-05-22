import 'package:flutter/material.dart';
import 'requisicao_service.dart';
import '../models/requisicao_dto.dart';

class RequisicaoProvider extends ChangeNotifier {
  final RequisicaoService _service = RequisicaoService();
  List<RequisicaoDTO> _requisicoes = [];
  bool _isLoading = false;
  String? _erro;

  List<RequisicaoDTO> get requisicoes => _requisicoes;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  Future<void> carregarRequisicoes() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      _requisicoes = await _service.buscarTodasRequisicoes();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> criarRequisicaoDTO(RequisicaoDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.salvarRequisicao(dto);
      await carregarRequisicoes();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarRequisicaoDTO(RequisicaoDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.atualizarRequisicao(dto);
      await carregarRequisicoes();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removerRequisicaoDTO(RequisicaoDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.removerRequisicao(dto);
      await carregarRequisicoes();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
