import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/cards.dart';
import 'package:cetic_sgde_front/main.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/tables.dart';
import 'package:provider/provider.dart';
import 'package:cetic_sgde_front/restrict/service/equipamento_provider.dart';
import 'package:cetic_sgde_front/restrict/service/emprestimo_provider.dart';
import 'package:cetic_sgde_front/restrict/service/manutencao_provider.dart';
import 'package:cetic_sgde_front/restrict/service/avaria_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Exemplo de dados recentes (pode ser equipamentos, alocações, etc.)
    final List<TableRowData> _recentes = [
      TableRowData(cells: [
        TableCellData(text: '789', alignment: TextAlign.left),
        TableCellData(text: 'Servidor Dell PowerEdge', alignment: TextAlign.left),
        TableCellData(text: 'Servidor', alignment: TextAlign.center),
        TableCellData(text: 'Manutenção', alignment: TextAlign.center),
      ]),
      TableRowData(cells: [
        TableCellData(text: '201', alignment: TextAlign.left),
        TableCellData(text: 'Monitor LG', alignment: TextAlign.left),
        TableCellData(text: 'Monitor', alignment: TextAlign.center),
        TableCellData(text: 'Alocado', alignment: TextAlign.center),
      ]),
      TableRowData(cells: [
        TableCellData(text: '001', alignment: TextAlign.left),
        TableCellData(text: 'Notebook Lenovo', alignment: TextAlign.left),
        TableCellData(text: 'Notebook', alignment: TextAlign.center),
        TableCellData(text: 'Emprestado', alignment: TextAlign.center),
      ]),
    ];

    return Consumer4<EquipamentoProvider, EmprestimoProvider, ManutencaoProvider, AvariaProvider>(
      builder: (context, equipamentoProvider, emprestimoProvider, manutencaoProvider, avariaProvider, child) {
        return Scaffold(
          backgroundColor: scaffoldBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
                          title: 'Total Equipamentos',
                          value: equipamentoProvider.equipamentos.length.toString(),
                          icon: Icons.devices,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                        child: Cards(
                          title: 'Empréstimos Ativos',
                          value: emprestimoProvider.emprestimos.where((e) => (e.status2 ?? '').toLowerCase() == 'pendente' || (e.status ?? '').toLowerCase() == 'ativo').length.toString(),
                          icon: Icons.assignment,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                        child: Cards(
                          title: 'Manutenções',
                          value: manutencaoProvider.manutencoes.length.toString(),
                          icon: Icons.build,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width > 600 ? 4 : 1),
                        child: Cards(
                          title: 'Avarias',
                          value: avariaProvider.avarias.length.toString(),
                          icon: Icons.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tabela de atualizações recentes com scroll horizontal
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CustomTable(
                        headers: [
                          TableHeader(text: 'ID', alignment: TextAlign.left),
                          TableHeader(text: 'Nome', alignment: TextAlign.left),
                          TableHeader(text: 'Tipo', alignment: TextAlign.center),
                          TableHeader(text: 'Status', alignment: TextAlign.center),
                        ],
                        allRows: _recentes,
                        rowsPerPage: _recentes.length,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botão centralizado no final
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
                        onPressed: () {
                          // ação do botão
                        },
                        child: const Text('Ver Relatórios', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
