import 'package:cetic_sgde_front/restrict/pages/componets/cards.dart';
// import 'package:cetic_sgde_front/componets/sidebar.dart';

import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/tables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cetic_sgde_front/restrict/service/manutencao_provider.dart';
import 'package:cetic_sgde_front/restrict/models/manutencao_dto.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/equipamento_picker_dialog.dart';
import 'package:cetic_sgde_front/restrict/service/avaria_provider.dart';
import 'package:cetic_sgde_front/restrict/service/equipamento_provider.dart';
import 'package:cetic_sgde_front/restrict/models/modelEquipamento.dart';

class ManutencaoEquipamentoScreen extends StatefulWidget {
  const ManutencaoEquipamentoScreen({Key? key}) : super(key: key);

  @override
  _ManutencaoEquipamentoScreenState createState() =>
      _ManutencaoEquipamentoScreenState();
}

class _ManutencaoEquipamentoScreenState
    extends State<ManutencaoEquipamentoScreen> {
  // Filtros avançados
  String? filtroStatus;
  String? filtroTipo;
  DateTime? filtroData;
  String? filtroResponsavel;
  String filtroBusca = '';

  List<ManutencaoDTO> _aplicarFiltros(List<ManutencaoDTO> lista) {
    return lista.where((m) {
      final statusOk = filtroStatus == null || filtroStatus!.isEmpty || m.status.toLowerCase().contains(filtroStatus!.toLowerCase());
      final tipoOk = filtroTipo == null || filtroTipo!.isEmpty || m.tipoManutencao.toLowerCase().contains(filtroTipo!.toLowerCase());
      final dataOk = filtroData == null || m.dataManutencao.toIso8601String().substring(0, 10) == filtroData!.toIso8601String().substring(0, 10);
      final responsavelOk = filtroResponsavel == null || filtroResponsavel!.isEmpty || m.responsavel.toLowerCase().contains(filtroResponsavel!.toLowerCase());
      final buscaOk = filtroBusca.isEmpty ||
        m.numeroSerie.toLowerCase().contains(filtroBusca.toLowerCase()) ||
        m.tipoManutencao.toLowerCase().contains(filtroBusca.toLowerCase()) ||
        m.descricaoManutencao.toLowerCase().contains(filtroBusca.toLowerCase()) ||
        m.responsavel.toLowerCase().contains(filtroBusca.toLowerCase());
      return statusOk && tipoOk && dataOk && responsavelOk && buscaOk;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ManutencaoProvider>(context, listen: false)
          .carregarManutencoesDTO();
      Provider.of<EquipamentoProvider>(context, listen: false)
          .carregarEquipamentos();
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showForm({ManutencaoDTO? manutencao}) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController numeroSerieController =
            TextEditingController(text: manutencao?.numeroSerie ?? '');
        final TextEditingController tipoManutencaoController =
            TextEditingController(text: manutencao?.tipoManutencao ?? '');
        final TextEditingController dataManutencaoController =
            TextEditingController(
                text: manutencao != null
                    ? manutencao.dataManutencao
                        .toIso8601String()
                        .substring(0, 10)
                    : '');
        final TextEditingController descricaoManutencaoController =
            TextEditingController(text: manutencao?.descricaoManutencao ?? '');
        final TextEditingController responsavelController =
            TextEditingController(text: manutencao?.responsavel ?? '');
        final TextEditingController statusController =
            TextEditingController(text: manutencao?.status ?? '');
        final TextEditingController tempoInatividadeController =
            TextEditingController(
                text: manutencao?.tempoInatividade.toString() ?? '');
        bool _isLoadingDialog = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                  manutencao == null ? 'Nova Manutenção' : 'Editar Manutenção'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: numeroSerieController,
                            decoration:
                                InputDecoration(labelText: 'Número de Série'),
                            readOnly: true,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.list_alt),
                          tooltip: 'Listar Equipamentos Disponíveis',
                          onPressed: () async {
                            // Buscar equipamentos que estão na tabela de avaria com status 'AVARIADO'
                            final avariasProvider = Provider.of<AvariaProvider>(
                                context,
                                listen: false);
                            await avariasProvider.carregarAvarias();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                context: context,
                                builder: (ctx) => EquipamentoPickerDialog(
                                  tipoOperacao:
                                      TipoOperacaoEquipamento.manutencao,
                                  onSelecionar: (equipamento) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      numeroSerieController.text =
                                          equipamento.numeroSerie;
                                      Navigator.of(ctx).pop();
                                    });
                                  },
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    DropdownButtonFormField<String>(
                      value: [
                        'Manutenção Corretiva',
                        'Manutenção Preventiva',
                        'Manutenção Preditiva',
                        'Manutenção Detectiva',
                        'Manutenção Proativa',
                      ].contains(tipoManutencaoController.text)
                          ? tipoManutencaoController.text
                          : null,
                      decoration: const InputDecoration(labelText: 'Tipo de Manutenção'),
                      items: const [
                        DropdownMenuItem(value: 'Manutenção Corretiva', child: Text('Manutenção Corretiva')),
                        DropdownMenuItem(value: 'Manutenção Preventiva', child: Text('Manutenção Preventiva')),
                        DropdownMenuItem(value: 'Manutenção Preditiva', child: Text('Manutenção Preditiva')),
                        DropdownMenuItem(value: 'Manutenção Detectiva', child: Text('Manutenção Detectiva')),
                        DropdownMenuItem(value: 'Manutenção Proativa', child: Text('Manutenção Proativa')),
                      ],
                      onChanged: (String? value) {
                        if (value != null) tipoManutencaoController.text = value;
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              manutencao?.dataManutencao ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          dataManutencaoController.text =
                              pickedDate.toIso8601String().substring(0, 10);
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dataManutencaoController,
                          decoration: InputDecoration(
                              labelText: 'Data da Manutenção (YYYY-MM-DD)'),
                        ),
                      ),
                    ),
                    TextField(
                        controller: descricaoManutencaoController,
                        decoration: InputDecoration(
                            labelText: 'Descrição da Manutenção')),
                    TextField(
                        controller: responsavelController,
                        decoration: InputDecoration(labelText: 'Responsável')),
                    if (manutencao != null)
                      DropdownButtonFormField<String>(
                        value: () {
                          final statusBanco = (statusController.text).trim().toLowerCase().replaceAll('ç', 'c').replaceAll('ã', 'a').replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u');
                          if (statusBanco == 'em manutencao' || statusBanco == 'em manutenção') return 'Em manutenção';
                          if (statusBanco == 'aguardando pecas' || statusBanco == 'aguardando peças') return 'Aguardando peças';
                          if (statusBanco == 'concluido' || statusBanco == 'concluído') return 'Concluído';
                          if (statusBanco == 'danificado') return 'Danificado';
                          if (statusBanco == 'cancelado') return 'Cancelado';
                          return 'Em manutenção';
                        }(),
                        decoration: const InputDecoration(labelText: 'Status'),
                        items: const [
                          DropdownMenuItem(value: 'Em manutenção', child: Text('Em manutenção')),
                          DropdownMenuItem(value: 'Aguardando peças', child: Text('Aguardando peças')),
                          DropdownMenuItem(value: 'Concluído', child: Text('Concluído')),
                          DropdownMenuItem(value: 'Danificado', child: Text('Danificado')),
                          DropdownMenuItem(value: 'Cancelado', child: Text('Cancelado')),
                        ],
                        onChanged: (String? value) {
                          if (value != null) statusController.text = value;
                        },
                      ),
                    TextField(
                      controller: tempoInatividadeController,
                      decoration: InputDecoration(labelText: 'Tempo de Inatividade (em horas)'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    setState(() => _isLoadingDialog = true);
                    bool success = true;
                    String errorMsg = '';
                    try {
                      final provider = Provider.of<ManutencaoProvider>(
                          context,
                          listen: false);
                      final dto = ManutencaoDTO(
                        numeroSerie: numeroSerieController.text,
                        tipoManutencao: tipoManutencaoController.text,
                        dataManutencao:
                            DateTime.parse(dataManutencaoController.text),
                        descricaoManutencao:
                            descricaoManutencaoController.text,
                        responsavel: responsavelController.text,
                        status: statusController.text,
                        tempoInatividade:
                            int.tryParse(tempoInatividadeController.text) ??
                                0,
                      );
                      if (manutencao == null) {
                        await provider.criarManutencaoDTO(dto);
                      } else {
                        await provider.atualizarManutencaoDTO(dto);
                      }
                    } catch (e) {
                      success = false;
                      errorMsg = 'Erro ao salvar manutenção.';
                    }
                    Navigator.of(context).pop();
                    if (success) {
                      _showSnackBar(manutencao == null ? 'Manutenção salva com sucesso!' : 'Manutenção editada com sucesso!');
                    } else {
                      _showSnackBar(errorMsg, isError: true);
                    }
                  },
                  child: _isLoadingDialog
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ManutencaoDTO manutencao) {
    showDialog(
      context: context,
      builder: (context) {
        bool _isLoadingDialog = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                  'Deseja apagar a manutenção do equipamento ${manutencao.numeroSerie}?'),
              content: const Text('Esta ação não poderá ser desfeita.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() => _isLoadingDialog = true);
                    bool success = true;
                    String errorMsg = '';
                    try {
                      await Provider.of<ManutencaoProvider>(context,
                              listen: false)
                          .removerManutencaoDTO(manutencao);
                    } catch (e) {
                      success = false;
                      errorMsg = 'Erro ao remover manutenção.';
                    }
                    Navigator.of(context).pop();
                    if (success) {
                      _showSnackBar('Manutenção removida com sucesso!');
                    } else {
                      _showSnackBar(errorMsg, isError: true);
                    }
                  },
                  child: _isLoadingDialog
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Apagar', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Implemente o build normalmente aqui
    return Container(); // Exemplo de retorno válido
  }
}
