import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/restrict/service/emprestimo_service.dart';
import 'package:cetic_sgde_front/restrict/models/emprestimo_dto.dart';

class EmprestimoProvider extends ChangeNotifier {
  final EmprestimoService _service = EmprestimoService();
  List<EmprestimoDTO> _emprestimos = [];
  bool _isLoading = false;
  String? _erro;

  List<EmprestimoDTO> get emprestimos => _emprestimos;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  Future<void> carregarEmprestimosDTO() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      _emprestimos = await _service.listarEmprestimosDTO();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarEmprestimos() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      _emprestimos = await _service.listarEmprestimosDTO();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> criarEmprestimoDTO(EmprestimoDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.criarEmprestimoDTO(dto);
      await carregarEmprestimosDTO();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarEmprestimoDTO(EmprestimoDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.atualizarEmprestimoDTO(dto);
      await carregarEmprestimosDTO();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removerEmprestimoDTO(EmprestimoDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.removerEmprestimoDTO(dto);
      await carregarEmprestimosDTO();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> buscarEmprestimosPorStatus(String status) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      _emprestimos = await _service.buscarEmprestimosPorStatus(status);
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pesquisarEmprestimosMultiCampo(String texto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      final todos = await _service.listarEmprestimosDTO();
      _emprestimos = todos.where((e) =>
        (e.numeroSerie.toLowerCase().contains(texto.toLowerCase())) ||
        (e.responsavel?.toLowerCase().contains(texto.toLowerCase()) ?? false) ||
        (e.status?.toLowerCase().contains(texto.toLowerCase()) ?? false) ||
        (e.status2?.toLowerCase().contains(texto.toLowerCase()) ?? false)
      ).toList();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filtrarPorData(DateTime? inicio, DateTime? fim) {
    if (inicio == null && fim == null) return;
    _emprestimos = _emprestimos.where((e) {
      final data = e.dataEmprestimo;
      if (data == null) return false;
      if (inicio != null && data.isBefore(inicio)) return false;
      if (fim != null && data.isAfter(fim)) return false;
      return true;
    }).toList();
    notifyListeners();
  }
}
