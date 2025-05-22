import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cetic_sgde_front/restrict/models/manutencao_dto.dart';

class ManutencaoService {
  final String _baseUrl = 'http://localhost:8080/sistema/manutencao';

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('final_token');
  }

  Future<List<ManutencaoDTO>> listarManutencoesDTO() async {
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
      return data.map((e) => ManutencaoDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar manutenções: ${response.statusCode}');
    }
  }

  Future<List<ManutencaoDTO>> listarManutencoesPorEquipamento(ManutencaoDTO dto) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/porEquipamento'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => ManutencaoDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar manutenções por equipamento: ${response.statusCode}');
    }
  }

  Future<ManutencaoDTO> buscarManutencaoDTO(ManutencaoDTO dto) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/buscar'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return ManutencaoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Manutenção não encontrada');
    }
  }

  Future<ManutencaoDTO> criarManutencaoDTO(ManutencaoDTO dto) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 201) {
      return ManutencaoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar manutenção: ${response.statusCode}');
    }
  }

  Future<ManutencaoDTO> atualizarManutencaoDTO(ManutencaoDTO dto) async {
    final token = await _getAuthToken();
    final response = await http.put(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return ManutencaoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar manutenção: ${response.statusCode}');
    }
  }

  Future<void> removerManutencaoDTO(ManutencaoDTO dto) async {
    final token = await _getAuthToken();
    final response = await http.delete(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Erro ao remover manutenção: ${response.statusCode}');
    }
  }
}
