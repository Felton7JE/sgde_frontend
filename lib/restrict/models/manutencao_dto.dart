class ManutencaoDTO {
  final String numeroSerie;
  final String tipoManutencao;
  final DateTime dataManutencao;
  final String descricaoManutencao;
  final String responsavel;
  final String status;
  final int tempoInatividade;

  ManutencaoDTO({
    required this.numeroSerie,
    required this.tipoManutencao,
    required this.dataManutencao,
    required this.descricaoManutencao,
    required this.responsavel,
    required this.status,
    required this.tempoInatividade,
  });

  factory ManutencaoDTO.fromJson(Map<String, dynamic> json) {
    return ManutencaoDTO(
      numeroSerie: json['numeroSerie'],
      tipoManutencao: json['tipoManutencao'],
      dataManutencao: DateTime.parse(json['dataManutencao']),
      descricaoManutencao: json['descricaoManutencao'],
      responsavel: json['responsavel'],
      status: json['status'],
      tempoInatividade: json['tempoInatividade'] is int ? json['tempoInatividade'] : int.tryParse(json['tempoInatividade'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numeroSerie': numeroSerie,
      'tipoManutencao': tipoManutencao,
      'dataManutencao': dataManutencao.toIso8601String(),
      'descricaoManutencao': descricaoManutencao,
      'responsavel': responsavel,
      'status': status,
      'tempoInatividade': tempoInatividade,
    };
  }
}
