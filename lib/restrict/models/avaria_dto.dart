class AvariaDTO {
  final String numeroSerie;
  final String? departamento;
  final DateTime? data;
  final String? tipoAvaria;
  final String? descricaoAvaria;
  final String? gravidade;
  final String? status;
  final String? status2;

  AvariaDTO({
    required this.numeroSerie,
    this.departamento,
    this.data,
    this.tipoAvaria,
    this.descricaoAvaria,
    this.gravidade,
    this.status,
    this.status2,
  });

  factory AvariaDTO.fromJson(Map<String, dynamic> json) {
    return AvariaDTO(
      numeroSerie: json['numeroSerie'],
      departamento: json['departamento'],
      data: json['data'] != null ? DateTime.tryParse(json['data']) : null,
      tipoAvaria: json['tipoAvaria'],
      descricaoAvaria: json['descricaoAvaria'],
      gravidade: json['gravidade'],
      status: json['status'],
      status2: json['status2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numeroSerie': numeroSerie,
      'departamento': departamento,
      'data': data?.toIso8601String().substring(0, 10),
      'tipoAvaria': tipoAvaria,
      'descricaoAvaria': descricaoAvaria,
      'gravidade': gravidade,
      'status': status,
      'status2': status2,
    };
  }
}
