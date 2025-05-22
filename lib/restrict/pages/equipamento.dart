import 'package:cetic_sgde_front/restrict/pages/componets/cards.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/tables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cetic_sgde_front/restrict/service/equipamento_provider.dart';
import 'package:cetic_sgde_front/restrict/models/modelEquipamento.dart';

class EquipamentoScreen extends StatefulWidget {
  const EquipamentoScreen({Key? key}) : super(key: key);

  @override
  _EquipamentoScreenState createState() => _EquipamentoScreenState();
}

class _EquipamentoScreenState extends State<EquipamentoScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<EquipamentoProvider>(context, listen: false).carregarEquipamentos());
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

  void _showForm({Equipamento? equipamento}) {
    showDialog(
      context: context,
      builder: (context) {
        // Lista de controladores para cada equipamento
        List<Map<String, TextEditingController>> equipamentosControllers = [
          {
            'nome': TextEditingController(text: equipamento?.nome ?? ''),
            'numeroSerie': TextEditingController(text: equipamento?.numeroSerie ?? ''),
            'categoria': TextEditingController(text: equipamento?.categoria ?? ''),
            'marca': TextEditingController(text: equipamento?.marca ?? ''),
            'modelo': TextEditingController(text: equipamento?.modelo ?? ''),
            'descricaoTecnica': TextEditingController(text: equipamento?.descricaoTecnica ?? ''),
            'dataAquisicao': TextEditingController(text: equipamento?.dataAquisicao != null ? equipamento!.dataAquisicao!.toIso8601String().substring(0, 10) : ''),
            'fornecedor': TextEditingController(text: equipamento?.fornecedor ?? ''),
            'quantidade': TextEditingController(text: equipamento?.quantidade?.toString() ?? ''),
            'status': TextEditingController(text: equipamento?.status ?? ''),
            'status2': TextEditingController(text: equipamento?.status2 ?? ''),
          }
        ];
        bool _isLoadingDialog = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(equipamento == null ? 'Novo(s) Equipamento(s)' : 'Editar Equipamento'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...equipamentosControllers.asMap().entries.map((entry) {
                      int idx = entry.key;
                      var ctrls = entry.value;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('Equipamento ${idx + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              TextField(
                                controller: ctrls['nome'],
                                decoration: const InputDecoration(labelText: 'Nome'),
                              ),
                              TextField(
                                controller: ctrls['numeroSerie'],
                                decoration: const InputDecoration(labelText: 'Número de Série'),
                              ),
                              DropdownButtonFormField<String>(
                                value: ctrls['categoria']!.text.isNotEmpty ? ctrls['categoria']!.text : null,
                                decoration: const InputDecoration(labelText: 'Categoria'),
                                items: const [
                                  DropdownMenuItem(value: 'Notebook', child: Text('Notebook')),
                                  DropdownMenuItem(value: 'Desktop', child: Text('Desktop')),
                                  DropdownMenuItem(value: 'Monitor', child: Text('Monitor')),
                                  DropdownMenuItem(value: 'Impressora', child: Text('Impressora')),
                                  DropdownMenuItem(value: 'Scanner', child: Text('Scanner')),
                                  DropdownMenuItem(value: 'Servidor', child: Text('Servidor')),
                                  DropdownMenuItem(value: 'Roteador', child: Text('Roteador')),
                                  DropdownMenuItem(value: 'Switch', child: Text('Switch')),
                                  DropdownMenuItem(value: 'Projetor', child: Text('Projetor')),
                                  DropdownMenuItem(value: 'Nobreak', child: Text('Nobreak')),
                                  DropdownMenuItem(value: 'Tablet', child: Text('Tablet')),
                                  DropdownMenuItem(value: 'Smartphone', child: Text('Smartphone')),
                                  DropdownMenuItem(value: 'Outro', child: Text('Outro')),
                                ],
                                onChanged: (String? value) {
                                  if (value != null) ctrls['categoria']!.text = value;
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: ctrls['marca']!.text.isNotEmpty ? ctrls['marca']!.text : null,
                                decoration: const InputDecoration(labelText: 'Marca'),
                                items: const [
                                  DropdownMenuItem(value: 'Dell', child: Text('Dell')),
                                  DropdownMenuItem(value: 'HP', child: Text('HP')),
                                  DropdownMenuItem(value: 'Lenovo', child: Text('Lenovo')),
                                  DropdownMenuItem(value: 'Acer', child: Text('Acer')),
                                  DropdownMenuItem(value: 'Asus', child: Text('Asus')),
                                  DropdownMenuItem(value: 'Apple', child: Text('Apple')),
                                  DropdownMenuItem(value: 'Samsung', child: Text('Samsung')),
                                  DropdownMenuItem(value: 'Brother', child: Text('Brother')),
                                  DropdownMenuItem(value: 'Epson', child: Text('Epson')),
                                  DropdownMenuItem(value: 'Canon', child: Text('Canon')),
                                  DropdownMenuItem(value: 'LG', child: Text('LG')),
                                  DropdownMenuItem(value: 'Positivo', child: Text('Positivo')),
                                  DropdownMenuItem(value: 'Multilaser', child: Text('Multilaser')),
                                  DropdownMenuItem(value: '3Com', child: Text('3Com')),
                                  DropdownMenuItem(value: 'Cisco', child: Text('Cisco')),
                                  DropdownMenuItem(value: 'TP-Link', child: Text('TP-Link')),
                                  DropdownMenuItem(value: 'Huawei', child: Text('Huawei')),
                                  DropdownMenuItem(value: 'Outro', child: Text('Outro')),
                                ],
                                onChanged: (String? value) {
                                  if (value != null) ctrls['marca']!.text = value;
                                },
                              ),
                              TextField(
                                controller: ctrls['modelo'],
                                decoration: const InputDecoration(labelText: 'Modelo'),
                              ),
                              TextField(
                                controller: ctrls['descricaoTecnica'],
                                decoration: const InputDecoration(labelText: 'Descrição Técnica'),
                              ),
                              TextField(
                                controller: ctrls['fornecedor'],
                                decoration: const InputDecoration(labelText: 'Fornecedor'),
                              ),
                              TextField(
                                controller: ctrls['quantidade'],
                                decoration: const InputDecoration(labelText: 'Quantidade'),
                                keyboardType: TextInputType.number,
                              ),
                              if (equipamento != null) ...[
                                TextField(
                                  controller: ctrls['status'],
                                  decoration: const InputDecoration(labelText: 'Status'),
                                ),
                                TextField(
                                  controller: ctrls['status2'],
                                  decoration: const InputDecoration(labelText: 'Status 2'),
                                ),
                              ],
                              const SizedBox(height: 10),
                              TextField(
                                controller: ctrls['dataAquisicao'],
                                decoration: const InputDecoration(labelText: 'Data de Aquisição'),
                                readOnly: true,
                                onTap: () async {
                                  final data = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.tryParse(ctrls['dataAquisicao']!.text) ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                  );
                                  if (data != null) {
                                    setState(() {
                                      ctrls['dataAquisicao']!.text = data.toIso8601String().substring(0, 10);
                                    });
                                  }
                                },
                              ),
                              if (equipamentosControllers.length > 1)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    tooltip: 'Remover este equipamento',
                                    onPressed: () {
                                      setState(() {
                                        equipamentosControllers.removeAt(idx);
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar outro equipamento'),
                        onPressed: () {
                          setState(() {
                            equipamentosControllers.add({
                              'nome': TextEditingController(),
                              'numeroSerie': TextEditingController(),
                              'categoria': TextEditingController(),
                              'marca': TextEditingController(),
                              'modelo': TextEditingController(),
                              'descricaoTecnica': TextEditingController(),
                              'dataAquisicao': TextEditingController(),
                              'fornecedor': TextEditingController(),
                              'quantidade': TextEditingController(),
                              'status': TextEditingController(),
                              'status2': TextEditingController(),
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
                          final provider = Provider.of<EquipamentoProvider>(context, listen: false);
                          bool success = true;
                          String errorMsg = '';
                          try {
                            for (var ctrls in equipamentosControllers) {
                              final novoEquipamento = Equipamento(
                                id: equipamento?.id,
                                nome: ctrls['nome']!.text,
                                numeroSerie: ctrls['numeroSerie']!.text,
                                categoria: ctrls['categoria']!.text,
                                marca: ctrls['marca']!.text,
                                modelo: ctrls['modelo']!.text,
                                descricaoTecnica: ctrls['descricaoTecnica']!.text,
                                dataAquisicao: ctrls['dataAquisicao']!.text.isNotEmpty ? DateTime.tryParse(ctrls['dataAquisicao']!.text) : null,
                                fornecedor: ctrls['fornecedor']!.text,
                                quantidade: ctrls['quantidade']!.text.isNotEmpty ? int.tryParse(ctrls['quantidade']!.text) : null,
                                status: ctrls['status']!.text,
                                status2: ctrls['status2']!.text,
                              );
                              if (equipamento == null) {
                                await provider.adicionarEquipamento(novoEquipamento);
                              } else {
                                await provider.atualizarEquipamento(novoEquipamento);
                              }
                            }
                          } catch (e) {
                            success = false;
                            errorMsg = 'Erro ao salvar equipamento(s).';
                          }
                          Navigator.of(context).pop();
                          if (success) {
                            _showSnackBar(equipamento == null ? 'Equipamento(s) salvo(s) com sucesso!' : 'Equipamento editado com sucesso!');
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
                      : const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Equipamento equipamento) {
    showDialog(
      context: context,
      builder: (context) {
        bool _isLoadingDialog = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Deseja apagar o equipamento ${equipamento.nome}?'),
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
                            await Provider.of<EquipamentoProvider>(context, listen: false)
                                .removerEquipamento(equipamento);
                          } catch (e) {
                            success = false;
                            errorMsg = 'Erro ao remover equipamento.';
                          }
                          Navigator.of(context).pop();
                          if (success) {
                            _showSnackBar('Equipamento removido com sucesso!');
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

  void _confirmEdit(BuildContext context, Equipamento equipamento) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Deseja editar o equipamento ${equipamento.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showForm(equipamento: equipamento);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EquipamentoProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.erro != null) {
          return Center(child: Text('Erro: ${provider.erro}'));
        }
        // Contagens por status reais conforme valores existentes no banco
        final statusList = provider.equipamentos.map((e) => (e.status ?? '').trim().toLowerCase()).toList();
        final total = provider.equipamentos.length;
        final recebido = statusList.where((s) => s == 'recebido').length;
        final emAnalise = statusList.where((s) => s == 'em analise' || s == 'em análise').length;
        final cadastrado = statusList.where((s) => s == 'cadastrado').length;
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
                        title: 'Total de Equipamentos',
                        value: total.toString(),
                        icon: Icons.devices_other,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Recebido',
                        value: recebido.toString(),
                        icon: Icons.inbox,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Em Análise',
                        value: emAnalise.toString(),
                        icon: Icons.search,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                      child: Cards(
                        title: 'Cadastrado',
                        value: cadastrado.toString(),
                        icon: Icons.app_registration,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: CustomTable(
                      headers: [
                        TableHeader(text: 'Número de Série', alignment: TextAlign.left),
                        TableHeader(text: 'Nome', alignment: TextAlign.left),
                        TableHeader(text: 'Categoria', alignment: TextAlign.center),
                        TableHeader(text: 'Marca', alignment: TextAlign.center),
                        TableHeader(text: 'Modelo', alignment: TextAlign.center),
                        TableHeader(text: 'Status', alignment: TextAlign.center),
                        TableHeader(text: 'Status 2', alignment: TextAlign.center),
                        TableHeader(text: 'Ações', alignment: TextAlign.center),
                      ],
                      allRows: provider.equipamentos.map((eq) => TableRowData(cells: [
                        TableCellData(text: eq.numeroSerie.isNotEmpty ? eq.numeroSerie : 'N/A', alignment: TextAlign.left),
                        TableCellData(text: eq.nome.isNotEmpty ? eq.nome : 'N/A', alignment: TextAlign.left),
                        TableCellData(text: (eq.categoria?.isNotEmpty ?? false) ? eq.categoria! : 'N/A', alignment: TextAlign.center),
                        TableCellData(text: (eq.marca?.isNotEmpty ?? false) ? eq.marca! : 'N/A', alignment: TextAlign.center),
                        TableCellData(text: (eq.modelo?.isNotEmpty ?? false) ? eq.modelo! : 'N/A', alignment: TextAlign.center),
                        TableCellData(
                          alignment: TextAlign.center,
                          widget: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DropdownButton<String>(
                              value: () {
                                final statusBanco = (eq.status ?? '').trim().toLowerCase();
                                if (statusBanco == 'recebido') return 'RECEBIDO';
                                if (statusBanco == 'em analise' || statusBanco == 'em análise') return 'EM ANALISE';
                                if (statusBanco == 'com pendencias') return 'COM PENDENCIAS';
                                if (statusBanco == 'devolvido') return 'DEVOLVIDO';
                                if (statusBanco == 'cadastrado') return 'CADASTRADO';
                                return 'RECEBIDO';
                              }(),
                              items: const [
                                DropdownMenuItem(value: 'RECEBIDO', child: Text('RECEBIDO')),
                                DropdownMenuItem(value: 'EM ANALISE', child: Text('EM ANALISE')),
                                DropdownMenuItem(value: 'COM PENDENCIAS', child: Text('COM PENDENCIAS')),
                                DropdownMenuItem(value: 'DEVOLVIDO', child: Text('DEVOLVIDO')),
                                DropdownMenuItem(value: 'CADASTRADO', child: Text('CADASTRADO')),
                              ],
                              onChanged: (String? newStatus) async {
                                if (newStatus != null && newStatus != eq.status) {
                                  final provider = Provider.of<EquipamentoProvider>(context, listen: false);
                                  final atualizado = Equipamento(
                                    id: eq.id,
                                    nome: eq.nome,
                                    numeroSerie: eq.numeroSerie,
                                    categoria: eq.categoria,
                                    marca: eq.marca,
                                    modelo: eq.modelo,
                                    descricaoTecnica: eq.descricaoTecnica,
                                    dataAquisicao: eq.dataAquisicao,
                                    fornecedor: eq.fornecedor,
                                    quantidade: eq.quantidade,
                                    status: newStatus,
                                    status2: eq.status2,
                                  );
                                  await provider.atualizarEquipamento(atualizado);
                                }
                              },
                            ),
                          ),
                        ),
                        TableCellData(text: (eq.status2?.isNotEmpty ?? false) ? eq.status2! : 'N/A', alignment: TextAlign.center),
                        TableCellData(
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'Editar',
                                onPressed: () => _confirmEdit(context, eq),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Apagar',
                                onPressed: () => _confirmDelete(context, eq),
                              ),
                            ],
                          ),
                          alignment: TextAlign.center,
                        ),
                      ])).toList(),
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
                      child: const Text('Adicionar Equipamento', style: TextStyle(fontSize: 16, color: Colors.white)),
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