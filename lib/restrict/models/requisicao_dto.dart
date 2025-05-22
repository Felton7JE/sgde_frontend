class RequisicaoDTO {
  final int? id;
  final DateTime? dataRequisicao;
  final int? quantidade;
  final String? justificativaRequisicao;
  final String? status;
  final String? status2;
  final String? responsavel;
  final String? nomeEquipamento;
  final String? modeloEquipamento;
  final String? tipoEquipamento;
  final String? descricaoEquipamento;

  RequisicaoDTO({
    this.id,
    this.dataRequisicao,
    this.quantidade,
    this.justificativaRequisicao,
    this.status,
    this.status2,
    this.responsavel,
    this.nomeEquipamento,
    this.modeloEquipamento,
    this.tipoEquipamento,
    this.descricaoEquipamento,
  });

  factory RequisicaoDTO.fromJson(Map<String, dynamic> json) {
    return RequisicaoDTO(
      id: json['id'],
      dataRequisicao: json['dataRequisicao'] != null ? DateTime.tryParse(json['dataRequisicao']) : null,
      quantidade: json['quantidade'],
      justificativaRequisicao: json['justificativaRequisicao'],
      status: json['status'],
      status2: json['status2'],
      responsavel: json['responsavel'],
      nomeEquipamento: json['nomeEquipamento'],
      modeloEquipamento: json['modeloEquipamento'],
      tipoEquipamento: json['tipoEquipamento'],
      descricaoEquipamento: json['descricaoEquipamento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataRequisicao': dataRequisicao?.toIso8601String().substring(0, 10),
      'quantidade': quantidade,
      'justificativaRequisicao': justificativaRequisicao,
      'status': status,
      'status2': status2,
      'responsavel': responsavel,
      'nomeEquipamento': nomeEquipamento,
      'modeloEquipamento': modeloEquipamento,
      'tipoEquipamento': tipoEquipamento,
      'descricaoEquipamento': descricaoEquipamento,
    };
  }
}
