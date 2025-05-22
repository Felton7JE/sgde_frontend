import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/restrict/models/modelEquipamento.dart';
import 'package:cetic_sgde_front/restrict/service/equipamento_service.dart'; // Corrigido o caminho se necessário

class EquipamentoProvider extends ChangeNotifier {
  final EquipamentoService _service = EquipamentoService();
  List<Equipamento> _equipamentos = [];
  Equipamento? _equipamentoSelecionado; // Para o resultado de buscarPorNumeroSerie
  bool _isLoading = false;
  String? _erro;

  List<Equipamento> get equipamentos => _equipamentos;
  Equipamento? get equipamentoSelecionado => _equipamentoSelecionado;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  // Método para limpar o erro
  void limparErro() {
    _erro = null;
    notifyListeners();
  }

  // Método para limpar o equipamento selecionado
  void limparEquipamentoSelecionado() {
    _equipamentoSelecionado = null;
    notifyListeners();
  }

  Future<void> carregarEquipamentos() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      _equipamentos = await _service.listarEquipamentos();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> adicionarEquipamento(Equipamento equipamento) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.criarEquipamento(equipamento);
      // Após adicionar, recarrega a lista para refletir a adição
      await carregarEquipamentos();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarEquipamento(Equipamento equipamento) async {
    if (equipamento.numeroSerie.isEmpty) {
      _erro = "Número de série do equipamento é inválido para atualização.";
      notifyListeners();
      return;
    }
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.atualizarEquipamento(equipamento);
      await carregarEquipamentos();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removerEquipamento(Equipamento equipamento) async {
    if (equipamento.numeroSerie.isEmpty) {
      _erro = "Número de série do equipamento é inválido para remoção.";
      notifyListeners();
      return;
    }
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      await _service.deletarEquipamento(equipamento);
      await carregarEquipamentos();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> buscarEquipamentoPorNumeroSerie(Equipamento equipamento) async {
    _isLoading = true;
    _erro = null;
    _equipamentoSelecionado = null; // Limpa seleção anterior
    notifyListeners();
    try {
      _equipamentoSelecionado = await _service.buscarEquipamentoPorNumeroSerie(equipamento);
    } catch (e) {
      _erro = e.toString();
      _equipamentoSelecionado = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pesquisarEquipamentos(String atributo, String valor) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      _equipamentos = await _service.pesquisarEquipamentos(atributo, valor);
    } catch (e) {
      _erro = e.toString();
      _equipamentos = []; // Limpa a lista em caso de erro na pesquisa
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pesquisarEquipamentosMultiCampo(String valor) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();
    try {
      final List<String> campos = ['nome', 'numeroSerie', 'categoria', 'marca'];
      Set<String> numerosSerieUnicos = {};
      List<Equipamento> resultados = [];
      for (final campo in campos) {
        final encontrados = await _service.pesquisarEquipamentos(campo, valor);
        for (final eq in encontrados) {
          if (!numerosSerieUnicos.contains(eq.numeroSerie)) {
            numerosSerieUnicos.add(eq.numeroSerie);
            resultados.add(eq);
          }
        }
      }
      _equipamentos = resultados;
    } catch (e) {
      _erro = e.toString();
      _equipamentos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}