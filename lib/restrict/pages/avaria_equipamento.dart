import 'package:cetic_sgde_front/restrict/pages/componets/cards.dart';
// import 'package:cetic_sgde_front/componets/sidebar.dart';

import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/tables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cetic_sgde_front/restrict/service/avaria_provider.dart';
import 'package:cetic_sgde_front/restrict/models/avaria_dto.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/equipamento_picker_dialog.dart';
import 'package:cetic_sgde_front/restrict/service/equipamento_provider.dart';
import 'package:cetic_sgde_front/restrict/models/modelEquipamento.dart';

class AvariaEquipamentoScreen extends StatefulWidget {
  const AvariaEquipamentoScreen({Key? key}) : super(key: key);

  @override
  _AvariaEquipamentoScreenState createState() => _AvariaEquipamentoScreenState();
}

class _AvariaEquipamentoScreenState extends State<AvariaEquipamentoScreen> {
  // Filtros avançados
  String? filtroStatus;
  String? filtroTipo;
  String? filtroGravidade;
  DateTime? filtroData;
  String filtroBusca = '';

  List<AvariaDTO> _aplicarFiltros(List<AvariaDTO> lista) {
    return lista.where((a) {
      final statusOk = filtroStatus == null || filtroStatus!.isEmpty || (a.status ?? '').toLowerCase().contains(filtroStatus!.toLowerCase());
      final tipoOk = filtroTipo == null || filtroTipo!.isEmpty || (a.tipoAvaria ?? '').toLowerCase().contains(filtroTipo!.toLowerCase());
      final gravidadeOk = filtroGravidade == null || filtroGravidade!.isEmpty || (a.gravidade ?? '').toLowerCase().contains(filtroGravidade!.toLowerCase());
      final dataOk = filtroData == null || (a.data != null && a.data!.toIso8601String().substring(0, 10) == filtroData!.toIso8601String().substring(0, 10));
      final buscaOk = filtroBusca.isEmpty ||
        a.numeroSerie.toLowerCase().contains(filtroBusca.toLowerCase()) ||
        (a.tipoAvaria ?? '').toLowerCase().contains(filtroBusca.toLowerCase()) ||
        (a.descricaoAvaria ?? '').toLowerCase().contains(filtroBusca.toLowerCase()) ||
        (a.departamento ?? '').toLowerCase().contains(filtroBusca.toLowerCase());
      return statusOk && tipoOk && gravidadeOk && dataOk && buscaOk;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AvariaProvider>(context, listen: false).carregarAvarias();
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

  void _showForm({AvariaDTO? avaria}) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController numeroSerieController = TextEditingController(text: avaria?.numeroSerie ?? '');
        final TextEditingController departamentoController = TextEditingController(text: avaria?.departamento ?? '');
        final TextEditingController tipoAvariaController = TextEditingController(text: avaria?.tipoAvaria ?? '');
        final TextEditingController descricaoAvariaController = TextEditingController(text: avaria?.descricaoAvaria ?? '');
        final TextEditingController gravidadeController = TextEditingController(text: avaria?.gravidade ?? '');
        final TextEditingController statusController = TextEditingController(text: avaria?.status ?? '');
        bool _isLoadingDialog = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(avaria == null ? 'Nova Avaria' : 'Editar Avaria'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: numeroSerieController,
                            decoration: InputDecoration(labelText: 'Número de Série'),
                            readOnly: true,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.list_alt),
                          tooltip: 'Listar Equipamentos Disponíveis',
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                context: context,
                                builder: (ctx) => EquipamentoPickerDialog(
                                  tipoOperacao: TipoOperacaoEquipamento.avaria,
                                  onSelecionar: (equipamento) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      numeroSerieController.text = equipamento.numeroSerie;
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
                    TextField(controller: departamentoController, decoration: InputDecoration(labelText: 'Departamento')),
                    DropdownButtonFormField<String>(
                      value: tipoAvariaController.text.isNotEmpty ? tipoAvariaController.text : null,
                      decoration: const InputDecoration(labelText: 'Tipo de Avaria'),
                      items: const [
                        DropdownMenuItem(value: 'Avarias de Hardware', child: Text('Avarias de Hardware')),
                        DropdownMenuItem(value: 'Avarias de Software', child: Text('Avarias de Software')),
                        DropdownMenuItem(value: 'Avarias de Rede', child: Text('Avarias de Rede')),
                        DropdownMenuItem(value: 'Avarias de Segurança e Acesso', child: Text('Avarias de Segurança e Acesso')),
                      ],
                      onChanged: (String? value) {
                        if (value != null) tipoAvariaController.text = value;
                      },
                    ),
                    TextField(controller: descricaoAvariaController, decoration: InputDecoration(labelText: 'Descrição da Avaria')),
                    DropdownButtonFormField<String>(
                      value: gravidadeController.text.isNotEmpty ? gravidadeController.text : null,
                      decoration: const InputDecoration(labelText: 'Gravidade'),
                      items: const [
                        DropdownMenuItem(value: 'Leve', child: Text('Leve')),
                        DropdownMenuItem(value: 'Moderada', child: Text('Moderada')),
                        DropdownMenuItem(value: 'Crítica', child: Text('Crítica')),
                      ],
                      onChanged: (String? value) {
                        if (value != null) gravidadeController.text = value;
                      },
                    ),
                    if (avaria != null)
                      DropdownButtonFormField<String>(
                        value: () {
                          final statusBanco = (statusController.text).trim().toLowerCase().replaceAll('ç', 'c').replaceAll('ã', 'a').replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u');
                          if (statusBanco == 'avariado') return 'Avariado';
                          if (statusBanco == 'em analise' || statusBanco == 'em análise') return 'Em análise';
                          if (statusBanco == 'consertado') return 'Consertado';
                          if (statusBanco == 'danificado') return 'Danificado';
                          if (statusBanco == 'concluido' || statusBanco == 'concluído') return 'Concluído';
                          return 'Avariado';
                        }(),
                        decoration: const InputDecoration(labelText: 'Status'),
                        items: const [
                          DropdownMenuItem(value: 'Avariado', child: Text('Avariado')),
                          DropdownMenuItem(value: 'Em análise', child: Text('Em análise')),
                          DropdownMenuItem(value: 'Consertado', child: Text('Consertado')),
                          DropdownMenuItem(value: 'Danificado', child: Text('Danificado')),
                          DropdownMenuItem(value: 'Concluído', child: Text('Concluído')),
                        ],
                        onChanged: (String? newStatus) {
                          if (newStatus != null) statusController.text = newStatus;
                        },
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
                      final provider = Provider.of<AvariaProvider>(context, listen: false);
                      final dto = AvariaDTO(
                        numeroSerie: numeroSerieController.text,
                        departamento: departamentoController.text,
                        tipoAvaria: tipoAvariaController.text,
                        descricaoAvaria: descricaoAvariaController.text,
                        gravidade: gravidadeController.text,
                        status: avaria != null ? statusController.text : null,
                      );
                      if (avaria == null) {
                        await provider.criarAvariaDTO(dto);
                      } else {
                        await provider.atualizarAvariaDTO(dto);
                      }
                    } catch (e) {
                      success = false;
                      errorMsg = 'Erro ao salvar avaria.';
                    }
                    Navigator.of(context).pop();
                    if (success) {
                      _showSnackBar(avaria == null ? 'Avaria salva com sucesso!' : 'Avaria editada com sucesso!');
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

  void _confirmDelete(BuildContext context, AvariaDTO avaria) {
    showDialog(
      context: context,
      builder: (context) {
        bool _isLoadingDialog = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Deseja apagar a avaria do equipamento ${avaria.numeroSerie}?'),
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
                      await Provider.of<AvariaProvider>(context, listen: false)
                          .removerAvariaDTO(avaria);
                    } catch (e) {
                      success = false;
                      errorMsg = 'Erro ao remover avaria.';
                    }
                    Navigator.of(context).pop();
                    if (success) {
                      _showSnackBar('Avaria removida com sucesso!');
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

  void _confirmEdit(BuildContext context, AvariaDTO avaria) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Deseja editar a avaria do equipamento ${avaria.numeroSerie}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showForm(avaria: avaria);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AvariaProvider, EquipamentoProvider>(
      builder: (context, avariaProvider, equipamentoProvider, child) {
        if (avariaProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (avariaProvider.erro != null) {
          return Center(child: Text('Erro: avariaProvider.erro}'));
        }

        // Contagens por status reais conforme valores existentes no banco
        final statusList = avariaProvider.avarias.map((e) => (e.status ?? '').toLowerCase()).toList();
        final total = avariaProvider.avarias.length;
        final avariado = statusList.where((s) => s == 'avariado').length;
        final concluido = statusList.where((s) => s == 'concluido' || s == 'concluído').length;
        final danificado = statusList.where((s) => s == 'danificado').length;
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
                        title: 'Total em Avaria',
                        value: total.toString(),
                        icon: Icons.devices_other,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Avariado',
                        value: avariado.toString(),
                        icon: Icons.error_outline,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Danificado',
                        value: danificado.toString(),
                        icon: Icons.report_problem,
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
                            value: filtroStatus,
                            decoration: const InputDecoration(labelText: 'Status'),
                            items: const [
                              DropdownMenuItem(value: '', child: Text('Todos')),
                              DropdownMenuItem(value: 'Avariado', child: Text('Avariado')),
                              DropdownMenuItem(value: 'Em análise', child: Text('Em análise')),
                              DropdownMenuItem(value: 'Consertado', child: Text('Consertado')),
                              DropdownMenuItem(value: 'Danificado', child: Text('Danificado')),
                              DropdownMenuItem(value: 'Concluído', child: Text('Concluído')),
                            ],
                            onChanged: (v) => setState(() => filtroStatus = v),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: DropdownButtonFormField<String>(
                            value: filtroTipo,
                            decoration: const InputDecoration(labelText: 'Tipo de Avaria'),
                            items: const [
                              DropdownMenuItem(value: '', child: Text('Todos')),
                              DropdownMenuItem(value: 'Avarias de Hardware', child: Text('Hardware')),
                              DropdownMenuItem(value: 'Avarias de Software', child: Text('Software')),
                              DropdownMenuItem(value: 'Avarias de Rede', child: Text('Rede')),
                              DropdownMenuItem(value: 'Avarias de Segurança e Acesso', child: Text('Segurança e Acesso')),
                            ],
                            onChanged: (v) => setState(() => filtroTipo = v),
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: DropdownButtonFormField<String>(
                            value: filtroGravidade,
                            decoration: const InputDecoration(labelText: 'Gravidade'),
                            items: const [
                              DropdownMenuItem(value: '', child: Text('Todas')),
                              DropdownMenuItem(value: 'Leve', child: Text('Leve')),
                              DropdownMenuItem(value: 'Moderada', child: Text('Moderada')),
                              DropdownMenuItem(value: 'Crítica', child: Text('Crítica')),
                            ],
                            onChanged: (v) => setState(() => filtroGravidade = v),
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
                            filtroGravidade = null;
                            filtroData = null;
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
                        TableHeader(text: 'Número de Série', alignment: TextAlign.left),
                        TableHeader(text: 'Nome do Equipamento', alignment: TextAlign.left),
                        TableHeader(text: 'Departamento', alignment: TextAlign.left),
                        TableHeader(text: 'Tipo', alignment: TextAlign.left),
                        TableHeader(text: 'Descrição', alignment: TextAlign.left),
                        TableHeader(text: 'Gravidade', alignment: TextAlign.left),
                        TableHeader(text: 'Data de Entrada', alignment: TextAlign.center),
                        TableHeader(text: 'Status', alignment: TextAlign.center),
                        TableHeader(text: 'Ações', alignment: TextAlign.center),
                      ],
                      allRows: _aplicarFiltros(avariaProvider.avarias).whereType<AvariaDTO>().map((a) {
                        final equipamento = equipamentoProvider.equipamentos.firstWhere(
                          (e) => e.numeroSerie == a.numeroSerie,
                          orElse: () => Equipamento(nome: '-', numeroSerie: a.numeroSerie),
                        );
                        return TableRowData(cells: [
                          TableCellData(text: a.numeroSerie, alignment: TextAlign.left),
                          TableCellData(text: equipamento.nome, alignment: TextAlign.left),
                          TableCellData(text: a.departamento ?? '', alignment: TextAlign.left),
                          TableCellData(text: a.tipoAvaria ?? '', alignment: TextAlign.left),
                          TableCellData(text: a.descricaoAvaria ?? '', alignment: TextAlign.left),
                          TableCellData(text: a.gravidade ?? '', alignment: TextAlign.left),
                          TableCellData(text: a.data != null ? a.data!.toIso8601String().substring(0, 10) : '', alignment: TextAlign.center),
                          TableCellData(
                            alignment: TextAlign.center,
                            widget: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DropdownButton<String>(
                                value: () {
                                  final statusBanco = (a.status ?? '').trim().toLowerCase().replaceAll('ç', 'c').replaceAll('ã', 'a').replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u');
                                  if (statusBanco == 'avariado') return 'Avariado';
                                  if (statusBanco == 'em analise' || statusBanco == 'em análise') return 'Em análise';
                                  if (statusBanco == 'consertado') return 'Consertado';
                                  if (statusBanco == 'danificado') return 'Danificado';
                                  if (statusBanco == 'concluido' || statusBanco == 'concluído') return 'Concluído';
                                  return 'Avariado';
                                }(),
                                items: const [
                                  DropdownMenuItem(value: 'Avariado', child: Text('Avariado')),
                                  DropdownMenuItem(value: 'Em análise', child: Text('Em análise')),
                                  DropdownMenuItem(value: 'Consertado', child: Text('Consertado')),
                                  DropdownMenuItem(value: 'Danificado', child: Text('Danificado')),
                                  DropdownMenuItem(value: 'Concluído', child: Text('Concluído')),
                                ],
                                onChanged: (String? newStatus) async {
                                  if (newStatus != null && newStatus != a.status) {
                                    final provider = Provider.of<AvariaProvider>(context, listen: false);
                                    final atualizado = AvariaDTO(
                                      numeroSerie: a.numeroSerie,
                                      departamento: a.departamento,
                                      data: a.data,
                                      tipoAvaria: a.tipoAvaria,
                                      descricaoAvaria: a.descricaoAvaria,
                                      gravidade: a.gravidade,
                                      status: newStatus,
                                    );
                                    await provider.atualizarAvariaDTO(atualizado);
                                  }
                                },
                              ),
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
                                  onPressed: () => _confirmEdit(context, a),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Remover',
                                  onPressed: () => _confirmDelete(context, a),
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
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                        elevation: 4,
                      ),
                      onPressed: () => _showForm(),
                      child: const Text('Nova Avaria', style: TextStyle(fontSize: 16)),
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
