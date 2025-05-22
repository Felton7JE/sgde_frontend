import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/restrict/service/avaria_service.dart';
import 'package:cetic_sgde_front/restrict/models/avaria_dto.dart';

class AvariaProvider extends ChangeNotifier {
  final AvariaService _service = AvariaService();
  List<AvariaDTO> _avarias = [];
  bool _isLoading = false;
  String? _erro;

  List<AvariaDTO> get avarias => _avarias;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  Future<void> carregarAvarias() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      _avarias = await _service.listarAvarias();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> criarAvariaDTO(AvariaDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.criarAvariaDTO(dto);
      await carregarAvarias();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarAvariaDTO(AvariaDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.atualizarAvariaDTO(dto);
      await carregarAvarias();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removerAvariaDTO(AvariaDTO dto) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.removerAvariaDTO(dto);
      await carregarAvarias();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
