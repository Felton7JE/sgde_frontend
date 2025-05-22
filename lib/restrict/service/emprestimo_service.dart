import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cetic_sgde_front/restrict/models/emprestimo_dto.dart';

class EmprestimoService {
  final String _baseUrl = 'http://localhost:8080/sistema/emprestimos';

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('final_token');
  }

  Future<List<EmprestimoDTO>> listarEmprestimosDTO() async {
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
      return data.map((e) => EmprestimoDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar empréstimos: ${response.statusCode}');
    }
  }

  Future<EmprestimoDTO> buscarEmprestimoDTO(EmprestimoDTO dto) async {
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
      return EmprestimoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Empréstimo não encontrado');
    }
  }

  Future<EmprestimoDTO> criarEmprestimoDTO(EmprestimoDTO dto) async {
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
      return EmprestimoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar empréstimo: ${response.statusCode}');
    }
  }

  Future<EmprestimoDTO> atualizarEmprestimoDTO(EmprestimoDTO dto) async {
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
      return EmprestimoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar empréstimo: ${response.statusCode}');
    }
  }

  Future<void> removerEmprestimoDTO(EmprestimoDTO dto) async {
    final token = await _getAuthToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl/excluir'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Erro ao remover empréstimo: ${response.statusCode}');
    }
  }

  Future<bool> verificarSeEmprestimoExiste(String numeroSerie) async {
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
      throw Exception('Erro ao verificar existência do empréstimo: ${response.statusCode}');
    }
  }

  Future<int> contarEmprestimos() async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/contagem'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as int;
    } else {
      throw Exception('Erro ao contar empréstimos: ${response.statusCode}');
    }
  }

  Future<List<EmprestimoDTO>> buscarEmprestimosPorResponsavel(String responsavel) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/responsavel/$responsavel'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => EmprestimoDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar empréstimos por responsável: ${response.statusCode}');
    }
  }

  Future<List<EmprestimoDTO>> buscarEmprestimosPorStatus(String status) async {
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
      return data.map((e) => EmprestimoDTO.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar empréstimos por status: ${response.statusCode}');
    }
  }
}
