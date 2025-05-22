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
    return Consumer2<ManutencaoProvider, EquipamentoProvider>(
      builder: (context, manutencaoProvider, equipamentoProvider, child) {
        if (manutencaoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (manutencaoProvider.erro != null) {
          return Center(child: Text('Erro: ${manutencaoProvider.erro}'));
        }
        // Contagens por status reais conforme valores existentes no banco
        final statusList = manutencaoProvider.manutencoes.map((e) => (e.status ?? '').toLowerCase()).toList();
        final total = manutencaoProvider.manutencoes.length;
        final emManutencao = statusList.where((s) => s == 'em manutencao' || s == 'em manutenção').length;
        final aguardandoPecas = statusList.where((s) => s == 'aguardando pecas' || s == 'aguardando peças').length;
        final concluido = statusList.where((s) => s == 'concluido' || s == 'concluído').length;
        return Scaffold(
          backgroundColor: scaffoldBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cards
                Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Total em Manutenção',
                        value: total.toString(),
                        icon: Icons.build,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Em manutenção',
                        value: emManutencao.toString(),
                        icon: Icons.settings,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Aguardando peças',
                        value: aguardandoPecas.toString(),
                        icon: Icons.hourglass_empty,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Concluído',
                        value: concluido.toString(),
                        icon: Icons.check_circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Filtros avançados
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          child: DropdownButtonFormField<String>(
                            value: filtroStatus,
                            decoration: const InputDecoration(labelText: 'Status'),
                            items: const [
                              DropdownMenuItem(value: '', child: Text('Todos')),
                              DropdownMenuItem(value: 'Em manutenção', child: Text('Em manutenção')),
                              DropdownMenuItem(value: 'Aguardando peças', child: Text('Aguardando peças')),
                              DropdownMenuItem(value: 'Concluído', child: Text('Concluído')),
                              DropdownMenuItem(value: 'Danificado', child: Text('Danificado')),
                              DropdownMenuItem(value: 'Cancelado', child: Text('Cancelado')),
                            ],
                            onChanged: (v) => setState(() => filtroStatus = v),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: DropdownButtonFormField<String>(
                            value: filtroTipo,
                            decoration: const InputDecoration(labelText: 'Tipo de Manutenção'),
                            items: const [
                              DropdownMenuItem(value: '', child: Text('Todos')),
                              DropdownMenuItem(value: 'Manutenção Corretiva', child: Text('Corretiva')),
                              DropdownMenuItem(value: 'Manutenção Preventiva', child: Text('Preventiva')),
                              DropdownMenuItem(value: 'Manutenção Preditiva', child: Text('Preditiva')),
                              DropdownMenuItem(value: 'Manutenção Detectiva', child: Text('Detectiva')),
                              DropdownMenuItem(value: 'Manutenção Proativa', child: Text('Proativa')),
                            ],
                            onChanged: (v) => setState(() => filtroTipo = v),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: filtroData ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) setState(() => filtroData = picked);
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Data',
                                  hintText: 'YYYY-MM-DD',
                                ),
                                controller: TextEditingController(
                                  text: filtroData != null ? filtroData!.toIso8601String().substring(0, 10) : '',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: TextField(
                            decoration: const InputDecoration(labelText: 'Responsável'),
                            onChanged: (v) => setState(() => filtroResponsavel = v),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: TextField(
                            decoration: const InputDecoration(labelText: 'Buscar...'),
                            onChanged: (v) => setState(() => filtroBusca = v),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: 'Limpar filtros',
                          onPressed: () => setState(() {
                            filtroStatus = null;
                            filtroTipo = null;
                            filtroData = null;
                            filtroResponsavel = null;
                            filtroBusca = '';
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: CustomTable(
                      headers: [
                        TableHeader(
                            text: 'Número de Série', alignment: TextAlign.left),
                        TableHeader(
                            text: 'Nome do Equipamento',
                            alignment: TextAlign.left),
                        TableHeader(
                            text: 'Tipo de Manutenção',
                            alignment: TextAlign.left),
                        TableHeader(text: 'Data', alignment: TextAlign.center),
                        TableHeader(
                            text: 'Descrição', alignment: TextAlign.left),
                        TableHeader(
                            text: 'Responsável', alignment: TextAlign.left),
                        TableHeader(
                            text: 'Status', alignment: TextAlign.center),
                        TableHeader(
                            text: 'Ação', alignment: TextAlign.center),
                      ],
                      allRows: _aplicarFiltros(manutencaoProvider.manutencoes)
                          .whereType<ManutencaoDTO>()
                          .map((m) {
                        final equipamento =
                            equipamentoProvider.equipamentos.firstWhere(
                          (e) => e.numeroSerie == m.numeroSerie,
                          orElse: () => Equipamento(
                              nome: '-', numeroSerie: m.numeroSerie),
                        );
                        return TableRowData(cells: [
                          TableCellData(
                              text: m.numeroSerie, alignment: TextAlign.left),
                          TableCellData(
                              text: equipamento.nome,
                              alignment: TextAlign.left),
                          TableCellData(
                              text: m.tipoManutencao,
                              alignment: TextAlign.left),
                          TableCellData(
                              text: m.dataManutencao
                                  .toIso8601String()
                                  .substring(0, 10),
                              alignment: TextAlign.center),
                          TableCellData(
                              text: m.descricaoManutencao,
                              alignment: TextAlign.left),
                          TableCellData(
                              text: m.responsavel, alignment: TextAlign.left),
                          TableCellData(
                            alignment: TextAlign.center,
                            widget: DropdownButton<String>(
                              value: () {
                                final statusBanco = (m.status ?? '').trim().toLowerCase().replaceAll('ç', 'c').replaceAll('ã', 'a').replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u');
                                if (statusBanco == 'em manutencao' || statusBanco == 'em manutenção') return 'Em manutenção';
                                if (statusBanco == 'aguardando pecas' || statusBanco == 'aguardando peças') return 'Aguardando peças';
                                if (statusBanco == 'concluido' || statusBanco == 'concluído') return 'Concluído';
                                if (statusBanco == 'danificado') return 'Danificado';
                                if (statusBanco == 'cancelado') return 'Cancelado';
                                return 'Em manutenção';
                              }(),
                              items: const [
                                DropdownMenuItem(value: 'Em manutenção', child: Text('Em manutenção')),
                                DropdownMenuItem(value: 'Aguardando peças', child: Text('Aguardando peças')),
                                DropdownMenuItem(value: 'Concluído', child: Text('Concluído')),
                                DropdownMenuItem(value: 'Danificado', child: Text('Danificado')),
                                DropdownMenuItem(value: 'Cancelado', child: Text('Cancelado')),
                              ],
                              onChanged: (String? newStatus) async {
                                if (newStatus != null && newStatus != m.status) {
                                  final provider = Provider.of<ManutencaoProvider>(context, listen: false);
                                  // Enviar todos os campos obrigatórios ao atualizar
                                  final atualizado = ManutencaoDTO(
                                    numeroSerie: m.numeroSerie,
                                    tipoManutencao: m.tipoManutencao,
                                    dataManutencao: m.dataManutencao,
                                    descricaoManutencao: m.descricaoManutencao,
                                    responsavel: m.responsavel,
                                    status: newStatus,
                                    tempoInatividade: m.tempoInatividade,
                                  );
                                  await provider.atualizarManutencaoDTO(atualizado);
                                }
                              },
                            ),
                          ),
                          TableCellData(
                            alignment: TextAlign.center,
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  tooltip: 'Editar',
                                  onPressed: () => _showForm(manutencao: m),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Remover',
                                  onPressed: () => _confirmDelete(context, m),
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                      rowsPerPage: 5,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canvasColor,
                        foregroundColor: white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        elevation: 4,
                      ),
                      onPressed: () => _showForm(),
                      child: const Text('Nova Manutenção',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
