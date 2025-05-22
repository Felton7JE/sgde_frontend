import 'package:cetic_sgde_front/restrict/pages/componets/cards.dart';
// import 'package:cetic_sgde_front/componets/sidebar.dart';

import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/tables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cetic_sgde_front/restrict/service/requisicao_provider.dart';
import 'package:cetic_sgde_front/restrict/service/equipamento_provider.dart';
import 'package:cetic_sgde_front/restrict/models/requisicao_dto.dart';

class RequisicaoEquipamentoScreen extends StatefulWidget {
  const RequisicaoEquipamentoScreen({Key? key}) : super(key: key);

  @override
  _RequisicaoEquipamentoScreenState createState() => _RequisicaoEquipamentoScreenState();
}

class _RequisicaoEquipamentoScreenState extends State<RequisicaoEquipamentoScreen> {
  // Filtros avançados
  String? filtroStatus2;
  DateTime? filtroData;
  String? filtroResponsavel;
  String? filtroTipo;
  String filtroBusca = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RequisicaoProvider>(context, listen: false).carregarRequisicoes();
      Provider.of<EquipamentoProvider>(context, listen: false).carregarEquipamentos();
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

  void _showForm({RequisicaoDTO? requisicao}) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController responsavelController = TextEditingController(text: requisicao?.responsavel ?? '');
        final TextEditingController dataRequisicaoController = TextEditingController(text: requisicao?.dataRequisicao?.toIso8601String().substring(0, 10) ?? '');
        final TextEditingController status2Controller = TextEditingController(text: requisicao?.status2 ?? '');
        final TextEditingController quantidadeController = TextEditingController(text: requisicao?.quantidade?.toString() ?? '');
        final TextEditingController justificativaController = TextEditingController(text: requisicao?.justificativaRequisicao ?? '');
        final TextEditingController nomeEquipamentoController = TextEditingController(text: requisicao?.nomeEquipamento ?? '');
        final TextEditingController modeloEquipamentoController = TextEditingController(text: requisicao?.modeloEquipamento ?? '');
        final TextEditingController tipoEquipamentoController = TextEditingController(text: requisicao?.tipoEquipamento ?? '');
        final TextEditingController descricaoEquipamentoController = TextEditingController(text: requisicao?.descricaoEquipamento ?? '');
        bool _isLoadingDialog = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(requisicao == null ? 'Nova Requisição' : 'Editar Requisição'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: responsavelController, decoration: InputDecoration(labelText: 'Responsável')),
                    GestureDetector(
                      onTap: () async {
                        final data = await showDatePicker(
                          context: context,
                          initialDate: requisicao?.dataRequisicao ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (data != null) {
                          setState(() {
                            dataRequisicaoController.text = data.toIso8601String().substring(0, 10);
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dataRequisicaoController,
                          decoration: InputDecoration(labelText: 'Data Requisição'),
                        ),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: () {
                        final status2Banco = (status2Controller.text).trim().toLowerCase();
                        if (status2Banco == 'pendente') return 'Pendente';
                        if (status2Banco == 'aceite') return 'Aceite';
                        if (status2Banco == 'recebido') return 'Recebido';
                        if (status2Banco == 'cancelado') return 'Cancelado';
                        return 'Pendente';
                      }(),
                      decoration: const InputDecoration(labelText: 'Status 2'),
                      items: const [
                        DropdownMenuItem(value: 'Pendente', child: Text('Pendente')),
                        DropdownMenuItem(value: 'Aceite', child: Text('Aceite')),
                        DropdownMenuItem(value: 'Recebido', child: Text('Recebido')),
                        DropdownMenuItem(value: 'Cancelado', child: Text('Cancelado')),
                      ],
                      onChanged: (String? newStatus2) {
                        if (newStatus2 != null) status2Controller.text = newStatus2;
                      },
                    ),
                    TextField(controller: quantidadeController, decoration: InputDecoration(labelText: 'Quantidade'), keyboardType: TextInputType.number),
                    TextField(controller: justificativaController, decoration: InputDecoration(labelText: 'Justificativa')), 
                    TextField(controller: nomeEquipamentoController, decoration: InputDecoration(labelText: 'Nome do Equipamento')),
                    TextField(controller: modeloEquipamentoController, decoration: InputDecoration(labelText: 'Modelo do Equipamento')),
                    TextField(controller: tipoEquipamentoController, decoration: InputDecoration(labelText: 'Tipo do Equipamento')),
                    TextField(controller: descricaoEquipamentoController, decoration: InputDecoration(labelText: 'Descrição do Equipamento')),
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
                      final provider = Provider.of<RequisicaoProvider>(context, listen: false);
                      final dto = RequisicaoDTO(
                        id: requisicao?.id, // Adiciona o id ao DTO para atualização
                        responsavel: responsavelController.text,
                        dataRequisicao: dataRequisicaoController.text.isNotEmpty ? DateTime.tryParse(dataRequisicaoController.text) : null,
                        status: '', // Campo removido
                        status2: status2Controller.text,
                        quantidade: quantidadeController.text.isNotEmpty ? int.tryParse(quantidadeController.text) : null,
                        justificativaRequisicao: justificativaController.text,
                        nomeEquipamento: nomeEquipamentoController.text,
                        modeloEquipamento: modeloEquipamentoController.text,
                        tipoEquipamento: tipoEquipamentoController.text,
                        descricaoEquipamento: descricaoEquipamentoController.text,
                      );
                      if (requisicao == null) {
                        await provider.criarRequisicaoDTO(dto);
                      } else {
                        await provider.atualizarRequisicaoDTO(dto);
                      }
                    } catch (e) {
                      success = false;
                      errorMsg = 'Erro ao salvar requisição.';
                    }
                    Navigator.of(context).pop();
                    if (success) {
                      _showSnackBar(requisicao == null ? 'Requisição salva com sucesso!' : 'Requisição editada com sucesso!');
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

  List<RequisicaoDTO> _aplicarFiltros(List<RequisicaoDTO> lista) {
    return lista.where((r) {
      final statusOk = filtroStatus2 == null || filtroStatus2!.isEmpty || (r.status2 ?? '').toLowerCase().contains(filtroStatus2!.toLowerCase());
      final dataOk = filtroData == null || (r.dataRequisicao != null && r.dataRequisicao!.toIso8601String().substring(0, 10) == filtroData!.toIso8601String().substring(0, 10));
      final responsavelOk = filtroResponsavel == null || filtroResponsavel!.isEmpty || (r.responsavel ?? '').toLowerCase().contains(filtroResponsavel!.toLowerCase());
      final tipoOk = filtroTipo == null || filtroTipo!.isEmpty || (r.tipoEquipamento ?? '').toLowerCase().contains(filtroTipo!.toLowerCase());
      final buscaOk = filtroBusca.isEmpty ||
        (r.nomeEquipamento ?? '').toLowerCase().contains(filtroBusca.toLowerCase()) ||
        (r.modeloEquipamento ?? '').toLowerCase().contains(filtroBusca.toLowerCase()) ||
        (r.tipoEquipamento ?? '').toLowerCase().contains(filtroBusca.toLowerCase()) ||
        (r.responsavel ?? '').toLowerCase().contains(filtroBusca.toLowerCase()) ||
        (r.justificativaRequisicao ?? '').toLowerCase().contains(filtroBusca.toLowerCase()) ||
        (r.descricaoEquipamento ?? '').toLowerCase().contains(filtroBusca.toLowerCase());
      return statusOk && dataOk && responsavelOk && tipoOk && buscaOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RequisicaoProvider, EquipamentoProvider>(
      builder: (context, requisicaoProvider, equipamentoProvider, child) {
        if (requisicaoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (requisicaoProvider.erro != null) {
          return Center(child: Text('Erro: ${requisicaoProvider.erro}'));
        }
        // Contagens por status reais conforme valores existentes no banco
        final statusList = requisicaoProvider.requisicoes.map((e) => (e.status2 ?? '').toLowerCase()).toList();
        final total = requisicaoProvider.requisicoes.length;
        final pendente = statusList.where((s) => s == 'pendente').length;
        final aceite = statusList.where((s) => s == 'aceite').length;
        final cancelado = statusList.where((s) => s == 'cancelado').length;
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
                        title: 'Total de Requisições',
                        value: total.toString(),
                        icon: Icons.devices_other,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Pendente',
                        value: pendente.toString(),
                        icon: Icons.timelapse,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Aceite',
                        value: aceite.toString(),
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Cancelado',
                        value: cancelado.toString(),
                        icon: Icons.cancel,
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
                          width: 160,
                          child: DropdownButtonFormField<String>(
                            value: filtroStatus2,
                            decoration: const InputDecoration(labelText: 'Status'),
                            items: const [
                              DropdownMenuItem(value: '', child: Text('Todos')),
                              DropdownMenuItem(value: 'Pendente', child: Text('Pendente')),
                              DropdownMenuItem(value: 'Aceite', child: Text('Aceite')),
                              DropdownMenuItem(value: 'Recebido', child: Text('Recebido')),
                              DropdownMenuItem(value: 'Cancelado', child: Text('Cancelado')),
                            ],
                            onChanged: (v) => setState(() => filtroStatus2 = v),
                          ),
                        ),
                        SizedBox(
                          width: 140,
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
                          width: 180,
                          child: TextField(
                            decoration: const InputDecoration(labelText: 'Tipo de Equipamento'),
                            onChanged: (v) => setState(() => filtroTipo = v),
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
                            filtroStatus2 = null;
                            filtroData = null;
                            filtroResponsavel = null;
                            filtroTipo = null;
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
                        TableHeader(text: 'Nome do Equipamento', alignment: TextAlign.left),
                        TableHeader(text: 'Modelo', alignment: TextAlign.left),
                        TableHeader(text: 'Tipo', alignment: TextAlign.left),
                        TableHeader(text: 'Responsável', alignment: TextAlign.left),
                        TableHeader(text: 'Data Requisição', alignment: TextAlign.center),
                        TableHeader(text: 'Quantidade', alignment: TextAlign.center),
                        TableHeader(text: 'Status 2', alignment: TextAlign.center),
                        TableHeader(text: 'Descrição', alignment: TextAlign.left),
                      ],
                      allRows: _aplicarFiltros(requisicaoProvider.requisicoes).whereType<RequisicaoDTO>().map((r) {
                        return TableRowData(cells: [
                          TableCellData(text: r.nomeEquipamento ?? '', alignment: TextAlign.left),
                          TableCellData(text: r.modeloEquipamento ?? '', alignment: TextAlign.left),
                          TableCellData(text: r.tipoEquipamento ?? '', alignment: TextAlign.left),
                          TableCellData(text: r.responsavel ?? '', alignment: TextAlign.left),
                          TableCellData(text: r.dataRequisicao != null ? r.dataRequisicao!.toIso8601String().substring(0, 10) : '', alignment: TextAlign.center),
                          TableCellData(text: r.quantidade?.toString() ?? '', alignment: TextAlign.center),
                          TableCellData(
                            alignment: TextAlign.center,
                            widget: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DropdownButton<String>(
                                value: () {
                                  final status2Banco = (r.status2 ?? '').trim().toLowerCase();
                                  if (status2Banco == 'pendente') return 'Pendente';
                                  if (status2Banco == 'aceite') return 'Aceite';
                                  if (status2Banco == 'recebido') return 'Recebido';
                                  if (status2Banco == 'cancelado') return 'Cancelado';
                                  return 'Pendente';
                                }(),
                                items: const [
                                  DropdownMenuItem(value: 'Pendente', child: Text('Pendente')),
                                  DropdownMenuItem(value: 'Aceite', child: Text('Aceite')),
                                  DropdownMenuItem(value: 'Recebido', child: Text('Recebido')),
                                  DropdownMenuItem(value: 'Cancelado', child: Text('Cancelado')),
                                ],
                                onChanged: (String? newStatus2) async {
                                  if (newStatus2 != null && newStatus2 != r.status2) {
                                    final provider = Provider.of<RequisicaoProvider>(context, listen: false);
                                    final atualizado = RequisicaoDTO(
                                      id: r.id, // Adiciona o id ao DTO para atualização
                                      responsavel: r.responsavel,
                                      dataRequisicao: r.dataRequisicao,
                                      status: '', // Campo removido
                                      status2: newStatus2,
                                      quantidade: r.quantidade,
                                      justificativaRequisicao: r.justificativaRequisicao,
                                      nomeEquipamento: r.nomeEquipamento,
                                      modeloEquipamento: r.modeloEquipamento,
                                      tipoEquipamento: r.tipoEquipamento,
                                      descricaoEquipamento: r.descricaoEquipamento,
                                    );
                                    await provider.atualizarRequisicaoDTO(atualizado);
                                  }
                                },
                              ),
                            ),
                          ),
                          TableCellData(text: r.descricaoEquipamento ?? '', alignment: TextAlign.left),
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
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                        elevation: 4,
                      ),
                      onPressed: () => _showForm(),
                      child: const Text('Nova Requisição', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                // Removido botão Exportar PDF duplicado. O botão de exportação deve aparecer apenas ao lado do campo de pesquisa, dentro do CustomTable.
              ],
            ),
          ),
        );
      },
    );
  }
}
