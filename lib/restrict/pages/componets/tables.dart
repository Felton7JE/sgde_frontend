import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class CustomTable extends StatefulWidget {
  final List<TableHeader> headers;
  final List<TableRowData> allRows; // Lista completa de todos os dados
  final int rowsPerPage;

  const CustomTable({
    Key? key,
    required this.headers,
    required this.allRows,
    this.rowsPerPage = 10,
  }) : super(key: key);

  @override
  _CustomTableState createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  int _currentPage = 0;
  String _searchQuery = '';
  List<TableRowData> _filteredRows = []; // Linhas filtradas pela pesquisa

  @override
  void initState() {
    super.initState();
    _filteredRows = widget.allRows; // Inicializa com todos os dados
  }

  // Paginacao
  int get _totalPages => (widget.allRows.length / widget.rowsPerPage).ceil();

  // Pagina as linhas exibidas
  List<TableRowData> get _pagedRows {
    List<TableRowData> rows = _searchQuery.isEmpty ? widget.allRows : _filteredRows;
    int startIndex = _currentPage * widget.rowsPerPage;
    int endIndex = startIndex + widget.rowsPerPage;
    if (startIndex > rows.length) return [];
    if (endIndex > rows.length) endIndex = rows.length;
    return rows.sublist(startIndex, endIndex);
  }

  // Pesquisa
  void _search(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredRows = widget.allRows;
      } else {
        _filteredRows = widget.allRows.where((row) {
          return row.cells.any((cell) =>
            cell.text != null && cell.text!.toLowerCase().contains(query.toLowerCase())
          );
        }).toList();
      }
      _currentPage = 0; // Reseta a paginação ao pesquisar
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double screenWidth = constraints.maxWidth;
        double fontSizeHeader = screenWidth < 300 ? 12 : 14;
        double fontSizeRow = screenWidth < 300 ? 12 : 14;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Campo de pesquisa reduzido
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Pesquisar',
                          prefixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        ),
                        onChanged: _search, // Chama a função de pesquisa ao digitar
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botão Exportar PDF
                  ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Exportar PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), // Bordas retangulares
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    onPressed: _exportToPdf,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Cor de fundo da tabela
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SingleChildScrollView( // Adiciona scroll horizontal
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: screenWidth), // Garante largura mínima
                    child: Table(
                      border: TableBorder.all(color: Colors.grey.shade700, width: 0.5), // Define as bordas da tabela
                      columnWidths: _getColumnWidths(widget.headers.length, screenWidth), // Define as larguras das colunas
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        _buildHeaderRow(widget.headers, fontSizeHeader),
                        ..._buildRows(_pagedRows, fontSizeRow),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildPagination(),
          ],
        );
      },
    );
  }

  // Função separada para construir o PDF, agora com estrutura de documento personalizada
  pw.Document buildPdfDocument() {
    final pdf = pw.Document();

    // Identifica índices das colunas a remover (Ações/Ação, ignorando maiúsculas/minúsculas e acentos)
    List<String> headerTexts = widget.headers.map((h) => h.text.toLowerCase().replaceAll(RegExp(r'[áãâàä]'), 'a').replaceAll(RegExp(r'[ç]'), 'c').replaceAll(RegExp(r'[éèêë]'), 'e').replaceAll(RegExp(r'[íìîï]'), 'i').replaceAll(RegExp(r'[óòôõö]'), 'o').replaceAll(RegExp(r'[úùûü]'), 'u')).toList();
    List<int> indicesToRemove = [];
    for (int i = 0; i < headerTexts.length; i++) {
      if (headerTexts[i] == 'acoes' || headerTexts[i] == 'acao') {
        indicesToRemove.add(i);
      }
    }

    // Filtra headers e linhas
    final headers = [
      for (int i = 0; i < widget.headers.length; i++)
        if (!indicesToRemove.contains(i)) widget.headers[i].text
    ];
    final rows = (_searchQuery.isEmpty ? widget.allRows : _filteredRows)
        .map((row) => [
              for (int i = 0; i < row.cells.length; i++)
                if (!indicesToRemove.contains(i)) row.cells[i].text ?? ''
            ])
        .toList();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 12), // margens menores
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Relatório de Dados',
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.Text('Exportado em: ' + DateTime.now().toString(),
                  style: pw.TextStyle(fontSize: 7, color: PdfColors.grey)),
              pw.Divider(thickness: 0.5),
              pw.SizedBox(height: 6),
              pw.Table.fromTextArray(
                headers: headers,
                data: rows,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
                cellStyle: pw.TextStyle(fontSize: 7.5, color: PdfColors.black),
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: pw.BoxDecoration(color: PdfColors.blue800),
                headerHeight: 18,
                cellHeight: 13,
                border: pw.TableBorder.all(color: PdfColors.blueGrey100, width: 0.3),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 0.5),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('Gerado por CETIC SGDE', style: pw.TextStyle(fontSize: 7, color: PdfColors.grey)),
              ),
            ],
          );
        },
      ),
    );
    return pdf;
  }

  void _exportToPdf() async {
    final pdf = buildPdfDocument();
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'tabela_exportada.pdf',
    );
  }

  Map<int, TableColumnWidth> _getColumnWidths(int columnCount, double screenWidth) {
    final columnWidth = screenWidth / columnCount;
    final widths = <int, TableColumnWidth>{};
    for (int i = 0; i < columnCount; i++) {
      widths[i] = FixedColumnWidth(columnWidth);
    }
    return widths;
  }

  TableRow _buildHeaderRow(List<TableHeader> headers, double fontSize) {
    return TableRow(
      decoration: BoxDecoration(
        color: canvasColor, // Header azul
      ),
      children: headers
          .map((header) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  header.text,
                  style: TextStyle(
                    color: white, // Texto branco no header
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                  textAlign: header.alignment,
                ),
              ))
          .toList(),
    );
  }

  List<TableRow> _buildRows(List<TableRowData> rows, double fontSize) {
    return rows
        .map((rowData) => TableRow(
              children: rowData.cells
                  .map((cellData) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: cellData.widget ?? Text(
                          cellData.text ?? '',
                          style: TextStyle(
                            color: Colors.black, // Texto preto nas linhas
                            fontSize: fontSize,
                          ),
                          textAlign: cellData.alignment,
                        ),
                      ))
                  .toList(),
            ))
        .toList();
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _currentPage > 0 ? () {
              setState(() {
                _currentPage--;
              });
            } : null,
          ),
          Text('Página ${_currentPage + 1} de $_totalPages'),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _currentPage < _totalPages - 1 ? () {
              setState(() {
                _currentPage++;
              });
            } : null,
          ),
        ],
      ),
    );
  }
}

class TableHeader {
  final String text;
  final TextAlign alignment;

  TableHeader({required this.text, this.alignment = TextAlign.center});
}

class TableRowData {
  final List<TableCellData> cells;

  TableRowData({required this.cells});
}

class TableCellData {
  final String? text;
  final Widget? widget;
  final TextAlign alignment;

  TableCellData({this.text, this.widget, this.alignment = TextAlign.center});
}