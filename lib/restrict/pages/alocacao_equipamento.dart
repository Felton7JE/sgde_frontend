import 'package:cetic_sgde_front/restrict/pages/componets/cards.dart';
// import 'package:cetic_sgde_front/componets/sidebar.dart';

import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/tables.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/equipamento_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cetic_sgde_front/restrict/service/alocacao_provider.dart';
import 'package:cetic_sgde_front/restrict/service/equipamento_provider.dart';
import 'package:cetic_sgde_front/restrict/models/alocacao_dto.dart';
import 'package:cetic_sgde_front/restrict/models/modelEquipamento.dart';

class AlocacaoEquipamentoScreen extends StatefulWidget {
  const AlocacaoEquipamentoScreen({Key? key}) : super(key: key);

  @override
  _AlocacaoEquipamentoScreenState createState() => _AlocacaoEquipamentoScreenState();
}

class _AlocacaoEquipamentoScreenState extends State<AlocacaoEquipamentoScreen> {
  String? _filtroStatus;
  DateTime? _filtroDataInicio;
  DateTime? _filtroDataFim;
  String _buscaTexto = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AlocacaoProvider>(context, listen: false).carregarAlocacoes();
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

  void _showForm({AlocacaoDTO? alocacao}) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController numeroSerieController = TextEditingController(text: alocacao?.numeroSerie ?? '');
        final TextEditingController localAlocadoController = TextEditingController(text: alocacao?.localAlocado ?? '');
        final TextEditingController usuarioController = TextEditingController(text: alocacao?.usuario ?? '');
        final TextEditingController statusController = TextEditingController(text: alocacao?.status ?? '');
        return StatefulBuilder(
          builder: (context, setState) {
            bool _isLoadingDialog = false;
            return AlertDialog(
              title: Text(alocacao == null ? 'Nova Alocação' : 'Editar Alocação'),
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
                                  tipoOperacao: TipoOperacaoEquipamento.alocacao,
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
                    TextField(controller: localAlocadoController, decoration: InputDecoration(labelText: 'Local Alocado')),
                    TextField(controller: usuarioController, decoration: InputDecoration(labelText: 'Usuário')),
                    if (alocacao != null)
                      TextField(controller: statusController, decoration: InputDecoration(labelText: 'Status')),
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
                      final provider = Provider.of<AlocacaoProvider>(context, listen: false);
                      final dto = AlocacaoDTO(
                        numeroSerie: numeroSerieController.text,
                        localAlocado: localAlocadoController.text,
                        usuario: usuarioController.text,
                        status: alocacao != null ? statusController.text : null,
                      );
                      await provider.atualizarAlocacao(dto);
                    } catch (e) {
                      success = false;
                      errorMsg = 'Erro ao salvar alocação.';
                    }
                    Navigator.of(context).pop();
                    if (success) {
                      _showSnackBar(alocacao == null ? 'Alocação salva com sucesso!' : 'Alocação editada com sucesso!');
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

  void _confirmDelete(BuildContext context, AlocacaoDTO alocacao) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool _isLoadingDialog = false;
            return AlertDialog(
              title: Text('Deseja apagar a alocação do equipamento ${alocacao.numeroSerie}?'),
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
                      await Provider.of<AlocacaoProvider>(context, listen: false)
                          .removerAlocacao(alocacao);
                    } catch (e) {
                      success = false;
                      errorMsg = 'Erro ao remover alocação.';
                    }
                    Navigator.of(context).pop();
                    if (success) {
                      _showSnackBar('Alocação removida com sucesso!');
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

  void _confirmEdit(BuildContext context, AlocacaoDTO alocacao) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Deseja editar a alocação do equipamento ${alocacao.numeroSerie}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showForm(alocacao: alocacao);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  List<AlocacaoDTO> _filtrarAlocacoes(List<AlocacaoDTO> alocacoes) {
    var filtradas = alocacoes;
    if (_filtroStatus != null && _filtroStatus!.isNotEmpty) {
      filtradas = filtradas.where((a) => (a.status ?? '').toLowerCase() == _filtroStatus!.toLowerCase()).toList();
    }
    if (_buscaTexto.isNotEmpty) {
      final busca = _buscaTexto.toLowerCase();
      filtradas = filtradas.where((a) =>
        a.numeroSerie.toLowerCase().contains(busca) ||
        (a.localAlocado?.toLowerCase().contains(busca) ?? false) ||
        (a.usuario?.toLowerCase().contains(busca) ?? false)
      ).toList();
    }
    return filtradas;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AlocacaoProvider, EquipamentoProvider>(
      builder: (context, alocacaoProvider, equipamentoProvider, child) {
        if (alocacaoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (alocacaoProvider.erro != null) {
          return Center(child: Text('Erro: alocacaoProvider.erro}'));
        }
        final total = alocacaoProvider.alocacoes.length;
        final alocado = alocacaoProvider.alocacoes.where((a) => (a.status2 ?? '').trim().toLowerCase() == 'alocado').length;
        final desalocado = alocacaoProvider.alocacoes.where((a) => (a.status2 ?? '').trim().toLowerCase() == 'desalocado').length;
        final alocacoesFiltradas = _filtrarAlocacoes(alocacaoProvider.alocacoes.whereType<AlocacaoDTO>().toList());
        return Scaffold(
          backgroundColor: scaffoldBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cards section moved to the top
                Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Total de Alocações',
                        value: total.toString(),
                        icon: Icons.devices_other,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Alocado',
                        value: alocado.toString(),
                        icon: Icons.assignment_turned_in,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Desalocado',
                        value: desalocado.toString(),
                        icon: Icons.assignment_return,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Filters below cards
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
                          width: 200,
                          child: DropdownButtonFormField<String>(
                            value: _filtroStatus,
                            decoration: const InputDecoration(labelText: 'Status'),
                            items: const [
                              DropdownMenuItem(value: null, child: Text('Todos')),
                              DropdownMenuItem(value: 'Alocado', child: Text('Alocado')),
                              DropdownMenuItem(value: 'Desalocado', child: Text('Desalocado')),
                            ],
                            onChanged: (v) => setState(() => _filtroStatus = v),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Busca textual',
                              hintText: 'Usuário, local, número de série...'
                            ),
                            onChanged: (v) => setState(() => _buscaTexto = v),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.filter_alt),
                          label: const Text('Aplicar Filtros'),
                          onPressed: () => setState(() {}),
                        ),
                        if (_filtroStatus != null || _buscaTexto.isNotEmpty)
                          TextButton.icon(
                            icon: const Icon(Icons.clear),
                            label: const Text('Limpar'),
                            onPressed: () {
                              setState(() {
                                _filtroStatus = null;
                                _buscaTexto = '';
                              });
                            },
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
                        TableHeader(text: 'Local Alocado', alignment: TextAlign.left),
                        TableHeader(text: 'Usuário', alignment: TextAlign.left),
                        TableHeader(text: 'Status', alignment: TextAlign.center),
                        TableHeader(text: 'Status 2', alignment: TextAlign.center),
                        TableHeader(text: 'Ações', alignment: TextAlign.center),
                      ],
                      allRows: alocacoesFiltradas.map((a) {
                        final equipamento = equipamentoProvider.equipamentos.firstWhere(
                          (e) => e.numeroSerie == a.numeroSerie,
                          orElse: () => Equipamento(nome: '-', numeroSerie: a.numeroSerie),
                        );
                        return TableRowData(cells: [
                          TableCellData(text: a.numeroSerie, alignment: TextAlign.left),
                          TableCellData(text: equipamento.nome, alignment: TextAlign.left),
                          TableCellData(text: a.localAlocado ?? '', alignment: TextAlign.left),
                          TableCellData(text: a.usuario ?? '', alignment: TextAlign.left),
                          TableCellData(text: a.status ?? '', alignment: TextAlign.center),
                          TableCellData(text: a.status2 ?? '', alignment: TextAlign.center),
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
                      child: const Text('Nova Alocação', style: TextStyle(fontSize: 16)),
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
