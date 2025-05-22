class EmprestimoDTO {
  final String numeroSerie;
  final String? responsavel;
  final DateTime? dataEmprestimo;
  final int? quantidade;
  final DateTime? dataDevolucao;
  final String? justificativaEmprestimo;
  final String? status;
  final String? quemFezEmprestimo;
  final String? status2;

  EmprestimoDTO({
    required this.numeroSerie,
    this.responsavel,
    this.dataEmprestimo,
    this.quantidade,
    this.dataDevolucao,
    this.justificativaEmprestimo,
    this.status,
    this.quemFezEmprestimo,
    this.status2,
  });

  factory EmprestimoDTO.fromJson(Map<String, dynamic> json) {
    return EmprestimoDTO(
      numeroSerie: json['numeroSerie'],
      responsavel: json['responsavel'],
      dataEmprestimo: json['dataEmprestimo'] != null ? DateTime.tryParse(json['dataEmprestimo']) : null,
      quantidade: json['quantidade'],
      dataDevolucao: json['dataDevolucao'] != null ? DateTime.tryParse(json['dataDevolucao']) : null,
      justificativaEmprestimo: json['justificativaEmprestimo'],
      status: json['status'],
      quemFezEmprestimo: json['quemFezEmprestimo'],
      status2: json['status2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numeroSerie': numeroSerie,
      'responsavel': responsavel,
      'dataEmprestimo': dataEmprestimo?.toIso8601String().substring(0, 10),
      'quantidade': quantidade,
      'dataDevolucao': dataDevolucao?.toIso8601String().substring(0, 10),
      'justificativaEmprestimo': justificativaEmprestimo,
      'status': status,
      'quemFezEmprestimo': quemFezEmprestimo,
      'status2': status2,
    };
  }
}
