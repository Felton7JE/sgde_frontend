import 'package:cetic_sgde_front/restrict/pages/componets/cards.dart';
// import 'package:cetic_sgde_front/componets/sidebar.dart'; // Removido

import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/tables.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/equipamento_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cetic_sgde_front/restrict/service/emprestimo_provider.dart';
import 'package:cetic_sgde_front/restrict/service/equipamento_provider.dart';
import 'package:cetic_sgde_front/restrict/models/emprestimo_dto.dart';
import 'package:cetic_sgde_front/restrict/models/modelEquipamento.dart';

class EmprestimoEquipamentoScreen extends StatefulWidget {
  const EmprestimoEquipamentoScreen({Key? key}) : super(key: key);

  @override
  _EmprestimoEquipamentoScreenState createState() => _EmprestimoEquipamentoScreenState();
}

class _EmprestimoEquipamentoScreenState extends State<EmprestimoEquipamentoScreen> {
  String? _filtroStatus;
  DateTime? _filtroDataInicio;
  DateTime? _filtroDataFim;
  String _buscaTexto = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<EmprestimoProvider>(context, listen: false).carregarEmprestimos();
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

  void _showForm({EmprestimoDTO? emprestimo}) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController numeroSerieController = TextEditingController(text: emprestimo?.numeroSerie ?? '');
        final TextEditingController responsavelController = TextEditingController(text: emprestimo?.responsavel ?? '');
        final TextEditingController dataEmprestimoController = TextEditingController(text: emprestimo?.dataEmprestimo?.toIso8601String().substring(0, 10) ?? '');
        final TextEditingController dataDevolucaoController = TextEditingController(text: emprestimo?.dataDevolucao?.toIso8601String().substring(0, 10) ?? '');
        final TextEditingController quantidadeController = TextEditingController(text: emprestimo?.quantidade?.toString() ?? '');
        final TextEditingController justificativaController = TextEditingController(text: emprestimo?.justificativaEmprestimo ?? '');
        final TextEditingController quemFezEmprestimoController = TextEditingController(text: emprestimo?.quemFezEmprestimo ?? '');
        final TextEditingController statusController = TextEditingController(text: emprestimo?.status ?? '');
        final TextEditingController status2Controller = TextEditingController(text: emprestimo?.status2 ?? '');
        bool _isLoadingDialog = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(emprestimo == null ? 'Novo Empréstimo' : 'Editar Empréstimo'),
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
                                  tipoOperacao: TipoOperacaoEquipamento.emprestimo,
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
                    TextField(controller: responsavelController, decoration: InputDecoration(labelText: 'Responsável')),
                    TextField(
                      controller: dataEmprestimoController,
                      decoration: InputDecoration(labelText: 'Data Empréstimo'),
                      readOnly: true,
                      onTap: () async {
                        final data = await showDatePicker(
                          context: context,
                          initialDate: emprestimo?.dataEmprestimo ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (data != null) {
                          setState(() {
                            dataEmprestimoController.text = data.toIso8601String().substring(0, 10);
                          });
                        }
                      },
                    ),
                    TextField(controller: quantidadeController, decoration: InputDecoration(labelText: 'Quantidade'), keyboardType: TextInputType.number),
                    TextField(
                      controller: dataDevolucaoController,
                      decoration: InputDecoration(labelText: 'Data Devolução'),
                      readOnly: true,
                      onTap: () async {
                        final data = await showDatePicker(
                          context: context,
                          initialDate: emprestimo?.dataDevolucao ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (data != null) {
                          setState(() {
                            dataDevolucaoController.text = data.toIso8601String().substring(0, 10);
                          });
                        }
                      },
                    ),
                    TextField(controller: justificativaController, decoration: InputDecoration(labelText: 'Justificativa do Empréstimo')),
                    TextField(controller: quemFezEmprestimoController, decoration: InputDecoration(labelText: 'Quem fez o Empréstimo')),
                    if (emprestimo != null)
                      TextField(controller: statusController, decoration: InputDecoration(labelText: 'Status')),
                    if (emprestimo != null)
                      DropdownButtonFormField<String>(
                        value: () {
                          final status2Banco = (status2Controller.text).trim().toLowerCase();
                          if (status2Banco == 'emprestado') return 'Emprestado';
                          if (status2Banco == 'devolvido') return 'Devolvido';
                          if (status2Banco == 'atradaso') return 'Atradaso';
                          if (status2Banco == 'extraviado') return 'Extraviado';
                          return 'Emprestado';
                        }(),
                        decoration: const InputDecoration(labelText: 'Status 2'),
                        items: const [
                          DropdownMenuItem(value: 'Emprestado', child: Text('Emprestado')),
                          DropdownMenuItem(value: 'Devolvido', child: Text('Devolvido')),
                          DropdownMenuItem(value: 'Atradaso', child: Text('Atradaso')),
                          DropdownMenuItem(value: 'Extraviado', child: Text('Extraviado')),
                        ],
                        onChanged: (String? newStatus2) {
                          if (newStatus2 != null) status2Controller.text = newStatus2;
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isLoadingDialog
                      ? null
                      : () async {
                          setState(() => _isLoadingDialog = true);
                          bool success = true;
                          String errorMsg = '';
                          try {
                            final provider = Provider.of<EmprestimoProvider>(context, listen: false);
                            final dto = EmprestimoDTO(
                              numeroSerie: numeroSerieController.text,
                              responsavel: responsavelController.text,
                              dataEmprestimo: dataEmprestimoController.text.isNotEmpty ? DateTime.tryParse(dataEmprestimoController.text) : null,
                              dataDevolucao: dataDevolucaoController.text.isNotEmpty ? DateTime.tryParse(dataDevolucaoController.text) : null,
                              quantidade: quantidadeController.text.isNotEmpty ? int.tryParse(quantidadeController.text) : null,
                              justificativaEmprestimo: justificativaController.text,
                              quemFezEmprestimo: quemFezEmprestimoController.text,
                              status: statusController.text,
                              status2: status2Controller.text,
                            );
                            if (emprestimo == null) {
                              await provider.criarEmprestimoDTO(dto);
                            } else {
                              await provider.atualizarEmprestimoDTO(dto);
                            }
                          } catch (e) {
                            success = false;
                            errorMsg = 'Erro ao salvar empréstimo.';
                          }
                          Navigator.of(context).pop();
                          if (success) {
                            _showSnackBar(emprestimo == null ? 'Empréstimo salvo com sucesso!' : 'Empréstimo editado com sucesso!');
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

  void _confirmDelete(BuildContext context, EmprestimoDTO emprestimo) {
    showDialog(
      context: context,
      builder: (context) {
        bool _isLoadingDialog = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Deseja apagar o empréstimo do equipamento ${emprestimo.numeroSerie}?'),
              content: const Text('Esta ação não poderá ser desfeita.'),
              actions: [
                TextButton(
                  onPressed: _isLoadingDialog ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: _isLoadingDialog
                      ? null
                      : () async {
                          setState(() => _isLoadingDialog = true);
                          bool success = true;
                          String errorMsg = '';
                          try {
                            await Provider.of<EmprestimoProvider>(context, listen: false)
                                .removerEmprestimoDTO(emprestimo);
                          } catch (e) {
                            success = false;
                            errorMsg = 'Erro ao remover empréstimo.';
                          }
                          Navigator.of(context).pop();
                          if (success) {
                            _showSnackBar('Empréstimo removido com sucesso!');
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

  void _confirmEdit(BuildContext context, EmprestimoDTO emprestimo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Deseja editar o empréstimo do equipamento ${emprestimo.numeroSerie}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showForm(emprestimo: emprestimo);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  void _aplicarFiltros(BuildContext context) async {
    final provider = Provider.of<EmprestimoProvider>(context, listen: false);
    // Exemplo: busca combinada (ajuste conforme métodos disponíveis no provider)
    if (_buscaTexto.isNotEmpty) {
      await provider.pesquisarEmprestimosMultiCampo(_buscaTexto);
    } else if (_filtroStatus != null && _filtroStatus!.isNotEmpty) {
      await provider.buscarEmprestimosPorStatus(_filtroStatus!);
    } else {
      await provider.carregarEmprestimos();
    }
    // Filtro por data pode ser implementado no provider ou localmente, conforme necessidade
    // Para simplificação, só filtra localmente se datas forem selecionadas
    if (_filtroDataInicio != null || _filtroDataFim != null) {
      provider.filtrarPorData(_filtroDataInicio, _filtroDataFim);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<EmprestimoProvider, EquipamentoProvider>(
      builder: (context, emprestimoProvider, equipamentoProvider, child) {
        if (emprestimoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (emprestimoProvider.erro != null) {
          return Center(child: Text('Erro: ${emprestimoProvider.erro}'));
        }
        // Contagens por status reais conforme valores existentes no banco
        final statusList = emprestimoProvider.emprestimos.map((e) => (e.status2 ?? '').toLowerCase()).toList();
        final total = emprestimoProvider.emprestimos.length;
        final emprestado = statusList.where((s) => s == 'emprestado').length;
        final devolvido = statusList.where((s) => s == 'devolvido').length;
        final atrasado = statusList.where((s) => s == 'atradaso' || s == 'atrasado').length;
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
                        title: 'Total de Empréstimos',
                        value: total.toString(),
                        icon: Icons.devices_other,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Emprestado',
                        value: emprestado.toString(),
                        icon: Icons.assignment,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Devolvido',
                        value: devolvido.toString(),
                        icon: Icons.assignment_return,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Atrasado',
                        value: atrasado.toString(),
                        icon: Icons.warning,
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
                              DropdownMenuItem(value: 'Emprestado', child: Text('Emprestado')),
                              DropdownMenuItem(value: 'Devolvido', child: Text('Devolvido')),
                              DropdownMenuItem(value: 'Atradaso', child: Text('Atradaso')),
                              DropdownMenuItem(value: 'Extraviado', child: Text('Extraviado')),
                            ],
                            onChanged: (v) => setState(() => _filtroStatus = v),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _filtroDataInicio ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) setState(() => _filtroDataInicio = picked);
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Data início',
                                  hintText: 'YYYY-MM-DD',
                                ),
                                controller: TextEditingController(
                                  text: _filtroDataInicio != null ? _filtroDataInicio!.toIso8601String().substring(0, 10) : '',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _filtroDataFim ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) setState(() => _filtroDataFim = picked);
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Data fim',
                                  hintText: 'YYYY-MM-DD',
                                ),
                                controller: TextEditingController(
                                  text: _filtroDataFim != null ? _filtroDataFim!.toIso8601String().substring(0, 10) : '',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Busca textual',
                              hintText: 'Nome, número de série, etc',
                            ),
                            onChanged: (v) => setState(() => _buscaTexto = v),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.filter_alt),
                          label: const Text('Aplicar Filtros'),
                          onPressed: () => _aplicarFiltros(context),
                        ),
                        if (_filtroStatus != null || _filtroDataInicio != null || _filtroDataFim != null || _buscaTexto.isNotEmpty)
                          TextButton.icon(
                            icon: const Icon(Icons.clear),
                            label: const Text('Limpar'),
                            onPressed: () {
                              setState(() {
                                _filtroStatus = null;
                                _filtroDataInicio = null;
                                _filtroDataFim = null;
                                _buscaTexto = '';
                              });
                              Provider.of<EmprestimoProvider>(context, listen: false).carregarEmprestimos();
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
                        TableHeader(text: 'Responsável', alignment: TextAlign.left),
                        TableHeader(text: 'Data Empréstimo', alignment: TextAlign.center),
                        TableHeader(text: 'Quantidade', alignment: TextAlign.center),
                        TableHeader(text: 'Data Devolução', alignment: TextAlign.center),
                        TableHeader(text: 'Justificativa', alignment: TextAlign.left),
                        TableHeader(text: 'Quem Fez', alignment: TextAlign.left),
                        TableHeader(text: 'Status', alignment: TextAlign.center),
                        TableHeader(text: 'Status 2', alignment: TextAlign.center),
                        TableHeader(text: 'Ações', alignment: TextAlign.center),
                      ],
                      allRows: emprestimoProvider.emprestimos.whereType<EmprestimoDTO>().map((e) {
                        final equipamento = equipamentoProvider.equipamentos.firstWhere(
                          (eq) => eq.numeroSerie == e.numeroSerie,
                          orElse: () => Equipamento(nome: '-', numeroSerie: e.numeroSerie),
                        );
                        return TableRowData(cells: [
                          TableCellData(text: e.numeroSerie, alignment: TextAlign.left),
                          TableCellData(text: equipamento.nome, alignment: TextAlign.left),
                          TableCellData(text: e.responsavel ?? '', alignment: TextAlign.left),
                          TableCellData(text: e.dataEmprestimo != null ? e.dataEmprestimo!.toIso8601String().substring(0, 10) : '', alignment: TextAlign.center),
                          TableCellData(text: e.quantidade?.toString() ?? '', alignment: TextAlign.center),
                          TableCellData(text: e.dataDevolucao != null ? e.dataDevolucao!.toIso8601String().substring(0, 10) : '', alignment: TextAlign.center),
                          TableCellData(text: e.justificativaEmprestimo ?? '', alignment: TextAlign.left),
                          TableCellData(text: e.quemFezEmprestimo ?? '', alignment: TextAlign.left),
                          TableCellData(text: e.status ?? '', alignment: TextAlign.center),
                          TableCellData(
                            alignment: TextAlign.center,
                            widget: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DropdownButton<String>(
                                value: () {
                                  final status2Banco = (e.status2 ?? '').trim().toLowerCase();
                                  if (status2Banco == 'emprestado') return 'Emprestado';
                                  if (status2Banco == 'devolvido') return 'Devolvido';
                                  if (status2Banco == 'atradaso') return 'Atradaso';
                                  if (status2Banco == 'extraviado') return 'Extraviado';
                                  return 'Emprestado';
                                }(),
                                items: const [
                                  DropdownMenuItem(value: 'Emprestado', child: Text('Emprestado')),
                                  DropdownMenuItem(value: 'Devolvido', child: Text('Devolvido')),
                                  DropdownMenuItem(value: 'Atradaso', child: Text('Atradaso')),
                                  DropdownMenuItem(value: 'Extraviado', child: Text('Extraviado')),
                                ],
                                onChanged: (String? newStatus2) async {
                                  if (newStatus2 != null && newStatus2 != e.status2) {
                                    final provider = Provider.of<EmprestimoProvider>(context, listen: false);
                                    final atualizado = EmprestimoDTO(
                                      numeroSerie: e.numeroSerie,
                                      responsavel: e.responsavel,
                                      dataEmprestimo: e.dataEmprestimo,
                                      dataDevolucao: e.dataDevolucao,
                                      quantidade: e.quantidade,
                                      justificativaEmprestimo: e.justificativaEmprestimo,
                                      quemFezEmprestimo: e.quemFezEmprestimo,
                                      status: e.status,
                                      status2: newStatus2,
                                    );
                                    await provider.atualizarEmprestimoDTO(atualizado);
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
                                  onPressed: () => _confirmEdit(context, e),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'Remover',
                                  onPressed: () => _confirmDelete(context, e),
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
                      child: const Text('Novo Empréstimo', style: TextStyle(fontSize: 16)),
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
