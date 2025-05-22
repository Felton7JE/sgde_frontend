class AlocacaoDTO {
  final String numeroSerie;
  final String? localAlocado;
  final String? usuario;
  final DateTime? dataAlocacao;
  final String? status;
  final String? status2;

  AlocacaoDTO({
    required this.numeroSerie,
    this.localAlocado,
    this.usuario,
    this.dataAlocacao,
    this.status,
    this.status2,
  });

  factory AlocacaoDTO.fromJson(Map<String, dynamic> json) {
    return AlocacaoDTO(
      numeroSerie: json['numeroSerie'],
      localAlocado: json['localAlocado'],
      usuario: json['usuario'],
      dataAlocacao: json['dataAlocacao'] != null ? DateTime.tryParse(json['dataAlocacao']) : null,
      status: json['status'],
      status2: json['status2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numeroSerie': numeroSerie,
      'localAlocado': localAlocado,
      'usuario': usuario,
      'dataAlocacao': dataAlocacao?.toIso8601String().substring(0, 10),
      'status': status,
      'status2': status2,
    };
  }
}
