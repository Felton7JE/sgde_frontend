import 'package:cetic_sgde_front/restrict/models/modelEquipamento.dart';
import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:intl/intl.dart';

class EquipmentForm extends StatefulWidget {
  final String? initialNome;
  final String? initialNumeroSerie;
  final String? initialCategoria;
  final String? initialMarca;
  final String? initialModelo;
  final String? initialDescricaoTecnica;
  final DateTime? initialDataAquisicao;
  final String? initialFornecedor;
  final int? initialQuantidade;
  final String? initialStatus;
  final void Function({
    required String nome,
    required String numeroSerie,
    String? categoria,
    String? marca,
    String? modelo,
    String? descricaoTecnica,
    DateTime? dataAquisicao,
    String? fornecedor,
    int? quantidade,
    String? status,
    String? status2,
  }) onSave;
  final Equipamento? initialEquipamento;

  const EquipmentForm({
    Key? key,
    this.initialNome,
    this.initialNumeroSerie,
    this.initialCategoria,
    this.initialMarca,
    this.initialModelo,
    this.initialDescricaoTecnica,
    this.initialDataAquisicao,
    this.initialFornecedor,
    this.initialQuantidade,
    this.initialStatus,
    required this.onSave, required this.initialEquipamento,
  }) : super(key: key);

  @override
  State<EquipmentForm> createState() => _EquipmentFormState();
}

class _EquipmentFormState extends State<EquipmentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _numeroSerieController;
  late TextEditingController _categoriaOutroController;
  late TextEditingController _marcaOutroController;
  late TextEditingController _modeloController;
  late TextEditingController _descricaoTecnicaController;
  late TextEditingController _dataAquisicaoController;
  late TextEditingController _fornecedorController;
  late TextEditingController _quantidadeController;
  late TextEditingController _statusOutroController;
  late TextEditingController _status2Controller;

  // Adicione listas de opções para categoria e marca
  final List<String> _categorias = [
    'Desktop (PC de mesa)',
    'Notebook / Laptop',
    'All-in-One',
    'Mini PC / Thin Client',
    'Workstation (alto desempenho)',
    'Torre',
    'Rack',
    'Blade',
    'Monitor Padrão',
    'Ultrawide',
    'Touchscreen',
    'Switch',
    'Roteador',
    'Access Point',
    'Firewall',
    'Modem',
    'Teclado',
    'Mouse',
    'Headset',
    'Webcam',
    'Leitor de cartão / biométrico',
    'Leitor de código de barras',
    'Impressora (Laser / Jato de tinta / Multifuncional)',
    'Scanner (Mesa / Automático / Rede)',
    'Plotter',
    'HD Externo',
    'SSD Externo',
    'NAS (Armazenamento em rede)',
    'Pendrive / Mídia removível',
    'Nobreak (com bateria)',
    'Estabilizador',
    'Projetor',
    'TV / Painel Digital',
    'Dock station',
    'Hub USB',
    'Cabos e adaptadores',
    'Suportes de monitor / notebook',
    'Suportes ergonômicos',
    'Outro'
  ];

  final List<String> _marcas = [
    'Acer',
    'APC (by Schneider Electric)',
    'Apple',
    'Aruba (da HPE)',
    'Brother',
    'Canon',
    'Cisco',
    'Crucial',
    'Dell',
    'D-Link',
    'Epson',
    'Genius',
    'HP (Hewlett-Packard)',
    'Intelbras',
    'Kingston',
    'Lenovo',
    'Logitech',
    'Microsoft',
    'MikroTik',
    'Multilaser',
    'QNAP (NAS)',
    'Ragtech',
    'Razer',
    'Samsung',
    'Samsung (SSDs)',
    'Seagate',
    'SMS',
    'Synology (NAS)',
    'TP-Link',
    'Ubiquiti (UniFi)',
    'Western Digital (WD)',
    'Outro'
  ];

  final List<String> _statusList = [
    'Recebido',
    'Em inspeção',
    'Cadastrado no sistema',
    'Configurado',
    'Outro'
  ];

  String? _selectedCategoria;
  String? _selectedMarca;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.initialNome ?? '');
    _numeroSerieController = TextEditingController(text: widget.initialNumeroSerie ?? '');
    _categoriaOutroController = TextEditingController();
    _marcaOutroController = TextEditingController();
    _selectedCategoria = widget.initialCategoria != null && _categorias.contains(widget.initialCategoria)
        ? widget.initialCategoria
        : (widget.initialCategoria != null && widget.initialCategoria!.isNotEmpty ? 'Outro' : null);
    if (_selectedCategoria == 'Outro' && widget.initialCategoria != null && widget.initialCategoria?.isNotEmpty == true) {
      _categoriaOutroController.text = widget.initialCategoria!;
    }
    _selectedMarca = widget.initialMarca != null && _marcas.contains(widget.initialMarca)
        ? widget.initialMarca
        : (widget.initialMarca != null && widget.initialMarca?.isNotEmpty == true ? 'Outro' : null);
    if (_selectedMarca == 'Outro' && widget.initialMarca != null && widget.initialMarca?.isNotEmpty == true) {
      _marcaOutroController.text = widget.initialMarca!;
    }
    _modeloController = TextEditingController(text: widget.initialModelo ?? '');
    _descricaoTecnicaController = TextEditingController(text: widget.initialDescricaoTecnica ?? '');
    _dataAquisicaoController = TextEditingController(
      text: widget.initialDataAquisicao != null ? DateFormat('yyyy-MM-dd').format(widget.initialDataAquisicao!) : '',
    );
    _fornecedorController = TextEditingController(text: widget.initialFornecedor ?? '');
    _quantidadeController = TextEditingController(text: widget.initialQuantidade?.toString() ?? '');
    _statusOutroController = TextEditingController();
    _selectedStatus = widget.initialStatus != null && _statusList.contains(widget.initialStatus)
        ? widget.initialStatus
        : (widget.initialStatus != null && widget.initialStatus!.isNotEmpty ? 'Outro' : null);
    if (_selectedStatus == 'Outro' && widget.initialStatus != null && widget.initialStatus?.isNotEmpty == true) {
      _statusOutroController.text = widget.initialStatus!;
    }
    _status2Controller = TextEditingController(text: widget.initialEquipamento?.status2 ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _numeroSerieController.dispose();
    _categoriaOutroController.dispose();
    _marcaOutroController.dispose();
    _modeloController.dispose();
    _descricaoTecnicaController.dispose();
    _dataAquisicaoController.dispose();
    _fornecedorController.dispose();
    _quantidadeController.dispose();
    _statusOutroController.dispose();
    _status2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    color: canvasColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Dados do Equipamento',
                      style: TextStyle(
                        color: white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _numeroSerieController,
                  decoration: const InputDecoration(labelText: 'Número de Série'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Informe o número de série' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCategoria,
                  items: _categorias
                      .map((cat) => DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoria = value;
                      if (value != 'Outro') {
                        _categoriaOutroController.clear();
                      }
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Selecione a categoria' : null,
                ),
                if (_selectedCategoria == 'Outro')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: _categoriaOutroController,
                      decoration: const InputDecoration(labelText: 'Informe a categoria'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Informe a categoria' : null,
                    ),
                  ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedMarca,
                  items: _marcas
                      .map((marca) => DropdownMenuItem<String>(
                            value: marca,
                            child: Text(marca),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMarca = value;
                      if (value != 'Outro') {
                        _marcaOutroController.clear();
                      }
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Marca'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Selecione a marca' : null,
                ),
                if (_selectedMarca == 'Outro')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: _marcaOutroController,
                      decoration: const InputDecoration(labelText: 'Informe a marca'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Informe a marca' : null,
                    ),
                  ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _modeloController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Informe o modelo' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descricaoTecnicaController,
                  decoration: const InputDecoration(labelText: 'Descrição Técnica'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Informe a descrição técnica' : null,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: widget.initialDataAquisicao ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dataAquisicaoController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dataAquisicaoController,
                      decoration: const InputDecoration(labelText: 'Data de Aquisição (YYYY-MM-DD)'),
                      keyboardType: TextInputType.datetime, // tipo de dado data
                      validator: (v) => v == null || v.trim().isEmpty ? 'Informe a data de aquisição' : null,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _fornecedorController,
                  decoration: const InputDecoration(labelText: 'Fornecedor'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Informe o fornecedor' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _quantidadeController,
                  decoration: const InputDecoration(labelText: 'Quantidade'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Informe a quantidade' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  items: _statusList
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                      if (value != 'Outro') {
                        _statusOutroController.clear();
                      }
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Status'),
                  validator: (v) => (v == null || v.isEmpty) ? 'Selecione o status' : null,
                ),
                if (_selectedStatus == 'Outro')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: _statusOutroController,
                      decoration: const InputDecoration(labelText: 'Informe o status'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Informe o status' : null,
                    ),
                  ),
                if (widget.initialEquipamento != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: _status2Controller,
                      decoration: const InputDecoration(labelText: 'Status 2'),
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canvasColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave(
                        nome: _nomeController.text,
                        numeroSerie: _numeroSerieController.text,
                        categoria: _selectedCategoria == 'Outro'
                            ? _categoriaOutroController.text
                            : _selectedCategoria,
                        marca: _selectedMarca == 'Outro'
                            ? _marcaOutroController.text
                            : _selectedMarca,
                        modelo: _modeloController.text.isNotEmpty ? _modeloController.text : null,
                        descricaoTecnica: _descricaoTecnicaController.text.isNotEmpty ? _descricaoTecnicaController.text : null,
                        dataAquisicao: _dataAquisicaoController.text.isNotEmpty ? DateTime.tryParse(_dataAquisicaoController.text) : null,
                        fornecedor: _fornecedorController.text.isNotEmpty ? _fornecedorController.text : null,
                        quantidade: _quantidadeController.text.isNotEmpty ? int.tryParse(_quantidadeController.text) : null,
                        status: _selectedStatus == 'Outro'
                            ? _statusOutroController.text
                            : _selectedStatus,
                        status2: widget.initialEquipamento == null ? 'Pendente' : _status2Controller.text,
                      );
                    }
                  },
                  child: const Text('Adicionar Equipamento', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}