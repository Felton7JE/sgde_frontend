import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cetic_sgde_front/restrict/models/avaria_dto.dart';

class AvariaService {
  final String _baseUrl = 'http://localhost:8080/sistema/avarias';

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('final_token');
  }

  Future<AvariaDTO> buscarAvariaDTO(AvariaDTO dto) async {
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
      return AvariaDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Avaria não encontrada');
    }
  }

  Future<AvariaDTO> criarAvariaDTO(AvariaDTO dto) async {
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
      return AvariaDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar avaria: ${response.statusCode}');
    }
  }

  Future<AvariaDTO> atualizarAvariaDTO(AvariaDTO dto) async {
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
      return AvariaDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar avaria: ${response.statusCode}');
    }
  }

  Future<void> removerAvariaDTO(AvariaDTO dto) async {
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
      throw Exception('Erro ao remover avaria: ${response.statusCode}');
    }
  }

  Future<List<AvariaDTO>> listarAvarias() async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => AvariaDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar avarias: ${response.statusCode}');
    }
  }

  Future<bool> verificarSeAvariaExiste(String numeroSerie) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/exists/$numeroSerie'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as bool;
    } else {
      throw Exception('Erro ao verificar existência da avaria: ${response.statusCode}');
    }
  }

  Future<int> contarAvarias() async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/count'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as int;
    } else {
      throw Exception('Erro ao contar avarias: ${response.statusCode}');
    }
  }

  Future<List<AvariaDTO>> buscarAvariasPorStatus(String status) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/status/$status'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => AvariaDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar avarias por status: ${response.statusCode}');
    }
  }
}
