// lib/models/equipamento_model.dart
import 'dart:convert';

class Equipamento {
  final int? id; // Long é mapeado para int em Dart. Nullable para novos equipamentos.
  final String nome;
  final String numeroSerie;
  final String? categoria;
  final String? marca;
  final String? modelo;
  final String? descricaoTecnica;
  final DateTime? dataAquisicao; // LocalDate será mapeado para DateTime
  final String? fornecedor;
  final int? quantidade; // Integer é mapeado para int
  final String? status;
  final String? status2;

  Equipamento({
    this.id,
    required this.nome,
    required this.numeroSerie,
    this.categoria,
    this.marca,
    this.modelo,
    this.descricaoTecnica,
    this.dataAquisicao,
    this.fornecedor,
    this.quantidade,
    this.status,
    this.status2,
  });

  // Converte um objeto Equipamento para um Map (para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'numeroSerie': numeroSerie,
      'categoria': categoria,
      'marca': marca,
      'modelo': modelo,
      'descricaoTecnica': descricaoTecnica,
      // Formata DateTime para String no formato YYYY-MM-DD
      'dataAquisicao': dataAquisicao?.toIso8601String().substring(0, 10),
      'fornecedor': fornecedor,
      'quantidade': quantidade,
      'status': status,
      'status2': status2,
    };
  }

  // Cria um objeto Equipamento a partir de um Map (de JSON)
  factory Equipamento.fromJson(Map<String, dynamic> json) {
    return Equipamento(
      id: json['id'] as int?,
      nome: json['nome'] as String,
      numeroSerie: json['numeroSerie'] as String,
      categoria: json['categoria'] as String?,
      marca: json['marca'] as String?,
      modelo: json['modelo'] as String?,
      descricaoTecnica: json['descricaoTecnica'] as String?,
      // Parse da String YYYY-MM-DD para DateTime
      dataAquisicao: json['dataAquisicao'] != null
          ? DateTime.tryParse(json['dataAquisicao'] as String)
          : null,
      fornecedor: json['fornecedor'] as String?,
      quantidade: json['quantidade'] as int?,
      status: json['status'] as String?,
      status2: json['status2'] as String?,
    );
  }

  // Helper para facilitar a cópia com modificações (imutabilidade)
  Equipamento copyWith({
    int? id,
    String? nome,
    String? numeroSerie,
    String? categoria,
    String? marca,
    String? modelo,
    String? descricaoTecnica,
    DateTime? dataAquisicao,
    String? fornecedor,
    int? quantidade,
    String? status,
    String? status2,
  }) {
    return Equipamento(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      numeroSerie: numeroSerie ?? this.numeroSerie,
      categoria: categoria ?? this.categoria,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      descricaoTecnica: descricaoTecnica ?? this.descricaoTecnica,
      dataAquisicao: dataAquisicao ?? this.dataAquisicao,
      fornecedor: fornecedor ?? this.fornecedor,
      quantidade: quantidade ?? this.quantidade,
      status: status ?? this.status,
      status2: status2 ?? this.status2,
    );
  }
}