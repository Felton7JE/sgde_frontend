import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cetic_sgde_front/restrict/models/modelEquipamento.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EquipamentoService {
  final String _baseUrl = 'http://localhost:8080/sistema/equipamento';

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('final_token');
  }

  Future<List<Equipamento>> listarEquipamentos() async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/listar'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => Equipamento.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar equipamentos: ${response.statusCode}');
    }
  }

  Future<Equipamento> buscarEquipamentoPorNumeroSerie(Equipamento equipamento) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/buscar'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'numeroSerie': equipamento.numeroSerie}),
    );
    if (response.statusCode == 200) {
      return Equipamento.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Equipamento não encontrado');
    }
  }

  Future<void> criarEquipamento(Equipamento equipamento) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/add'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(equipamento.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao criar equipamento: ${response.statusCode}');
    }
  }

  Future<void> atualizarEquipamento(Equipamento equipamento) async {
    final token = await _getAuthToken();
    final response = await http.put(
      Uri.parse('$_baseUrl/edit'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(equipamento.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar equipamento: ${response.statusCode}');
    }
  }

  Future<void> deletarEquipamento(Equipamento equipamento) async {
    final token = await _getAuthToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl/deletar'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'numeroSerie': equipamento.numeroSerie}),
    );
    if (response.statusCode != 204) {
      throw Exception('Erro ao deletar equipamento: ${response.statusCode}');
    }
  }

  Future<List<Equipamento>> pesquisarEquipamentos(String atributo, String valor) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/pesquisar?atributo=$atributo&valor=$valor'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => Equipamento.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao pesquisar equipamentos: ${response.statusCode}');
    }
  }
}
