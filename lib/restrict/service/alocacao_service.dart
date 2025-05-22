import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cetic_sgde_front/restrict/models/alocacao_dto.dart';
class AlocacaoService {
  final String _baseUrl = 'http://localhost:8080/sistema/alocacao';

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('final_token');
  }

  Future<List<AlocacaoDTO>> listarAlocacoes() async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => AlocacaoDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar alocações: ${response.statusCode}');
    }
  }

  Future<AlocacaoDTO> buscarAlocacao(AlocacaoDTO dto) async {
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
      return AlocacaoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Alocação não encontrada');
    }
  }

  Future<AlocacaoDTO> adicionarAlocacao(AlocacaoDTO dto) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/add'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 201) {
      return AlocacaoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao adicionar alocação: ${response.statusCode}');
    }
  }

  Future<AlocacaoDTO> atualizarAlocacao(AlocacaoDTO dto) async {
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
      return AlocacaoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar alocação: ${response.statusCode}');
    }
  }

  Future<void> excluirAlocacao(AlocacaoDTO dto) async {
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
      throw Exception('Erro ao excluir alocação: ${response.statusCode}');
    }
  }

  Future<bool> verificarSeAlocacaoExiste(String numeroSerie) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/verificar/$numeroSerie'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as bool;
    } else {
      throw Exception('Erro ao verificar alocação: ${response.statusCode}');
    }
  }

  Future<int> contarAlocacoes() async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/contar'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as int;
    } else {
      throw Exception('Erro ao contar alocações: ${response.statusCode}');
    }
  }

  Future<List<AlocacaoDTO>> buscarAlocacoesPorUsuario(String usuario) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/usuario'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'usuario': usuario}),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => AlocacaoDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar alocações por usuário: ${response.statusCode}');
    }
  }

  Future<List<AlocacaoDTO>> buscarAlocacoesPorStatus(String status) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/status'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => AlocacaoDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar alocações por status: ${response.statusCode}');
    }
  }
}
