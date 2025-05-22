import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/requisicao_dto.dart';

class RequisicaoService {
  final String baseUrl = 'http://localhost:8080/sistema/requisicao';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('final_token');
  }

  Future<List<RequisicaoDTO>> buscarTodasRequisicoes() async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => RequisicaoDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar requisições: status=\\${response.statusCode}, body=\\${response.body}');
    }
  }

  Future<RequisicaoDTO> salvarRequisicao(RequisicaoDTO dto) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return RequisicaoDTO.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao salvar requisição');
    }
  }

  Future<List<RequisicaoDTO>> buscarRequisicoesPorResponsavel(String responsavel) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/responsavel'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'responsavel': responsavel}),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => RequisicaoDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar por responsável');
    }
  }

  Future<List<RequisicaoDTO>> buscarRequisicoesPorStatus(String status) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'status': status}),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => RequisicaoDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar por status');
    }
  }

  Future<RequisicaoDTO> atualizarStatus({required int id, required String status}) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'id': id, 'status': status}),
    );
    if (response.statusCode == 200) {
      return RequisicaoDTO.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao atualizar status da requisição');
    }
  }

  Future<RequisicaoDTO> atualizarRequisicao(RequisicaoDTO dto) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return RequisicaoDTO.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao atualizar requisição');
    }
  }

  Future<void> removerRequisicao(RequisicaoDTO dto) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/remover'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(dto.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Erro ao remover requisição');
    }
  }
}
