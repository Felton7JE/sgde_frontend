import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cetic_sgde_front/restrict/models/modelEquipamento.dart';
import 'package:cetic_sgde_front/restrict/service/equipamento_provider.dart';
import 'package:cetic_sgde_front/restrict/service/avaria_provider.dart';

/// Tipo de operação para filtrar equipamentos elegíveis
enum TipoOperacaoEquipamento { alocacao, emprestimo, manutencao, avaria }

class EquipamentoPickerDialog extends StatefulWidget {
  final TipoOperacaoEquipamento tipoOperacao;
  final void Function(Equipamento equipamento) onSelecionar;

  const EquipamentoPickerDialog({
    Key? key,
    required this.tipoOperacao,
    required this.onSelecionar,
  }) : super(key: key);

  @override
  State<EquipamentoPickerDialog> createState() => _EquipamentoPickerDialogState();
}

class _EquipamentoPickerDialogState extends State<EquipamentoPickerDialog> {
  String _busca = '';

  @override
  void initState() {
    super.initState();
    Provider.of<EquipamentoProvider>(context, listen: false).carregarEquipamentos();
  }

  List<Equipamento> _filtrarEquipamentos(List<Equipamento> equipamentos) {
    // Filtro por busca
    final buscaLower = _busca.toLowerCase();
    var filtrados = equipamentos.where((e) {
      return e.nome.toLowerCase().contains(buscaLower) ||
        e.numeroSerie.toLowerCase().contains(buscaLower) ||
        (e.marca?.toLowerCase().contains(buscaLower) ?? false) ||
        (e.modelo?.toLowerCase().contains(buscaLower) ?? false);
    }).toList();

    // Filtro por tipo de operação
    switch (widget.tipoOperacao) {
      case TipoOperacaoEquipamento.alocacao:
        filtrados = filtrados.where((e) => (e.status?.toUpperCase() ?? '') == 'CADASTRADO').toList();
        break;
      case TipoOperacaoEquipamento.emprestimo:
        filtrados = filtrados.where((e) => e.status != 'Emprestado').toList();
        break;
      case TipoOperacaoEquipamento.manutencao:
        // Só permite equipamentos que estão na tabela de avaria com status 'AVARIADO'
        final avariasProvider = Provider.of<AvariaProvider>(context, listen: false);
        final equipamentosAvariados = avariasProvider.avarias
            .where((a) => a.status?.toUpperCase() == 'AVARIADO')
            .map((a) => a.numeroSerie)
            .toSet();
        filtrados = filtrados.where((e) => equipamentosAvariados.contains(e.numeroSerie)).toList();
        break;
      case TipoOperacaoEquipamento.avaria:
        filtrados = filtrados.where((e) => e.status != 'Com Avaria').toList();
        break;
    }
    return filtrados;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecionar Equipamento'),
      content: SizedBox(
        width: 400,
        height: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por nome, número de série, marca ou modelo',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _busca = value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<EquipamentoProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final equipamentos = _filtrarEquipamentos(provider.equipamentos);
                  if (equipamentos.isEmpty) {
                    return const Center(child: Text('Nenhum equipamento disponível.'));
                  }
                  return ListView.builder(
                    itemCount: equipamentos.length,
                    itemBuilder: (context, index) {
                      final eq = equipamentos[index];
                      return ListTile(
                        title: Text(eq.nome),
                        subtitle: Text('Nº Série: ${eq.numeroSerie} | Marca: ${eq.marca ?? '-'} | Modelo: ${eq.modelo ?? '-'}'),
                        onTap: () {
                          // Corrige: só chama o callback, não fecha o dialog aqui!
                          widget.onSelecionar(eq);
                          // Remova o Navigator.of(context).pop() daqui!
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
