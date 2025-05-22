import 'package:cetic_sgde_front/restrict/pages/equipamento.dart';
import 'package:cetic_sgde_front/restrict/pages/alocacao_equipamento.dart';
import 'package:cetic_sgde_front/restrict/pages/manutencao_equipamento.dart';
import 'package:cetic_sgde_front/restrict/pages/emprestimo_equipamento.dart';
import 'package:cetic_sgde_front/restrict/pages/avaria_equipamento.dart';
import 'package:cetic_sgde_front/restrict/pages/requisicao_equipamento.dart';
import 'package:cetic_sgde_front/restrict/pages/dashboard.dart';
import 'package:cetic_sgde_front/src/models/models.dart';
import 'package:cetic_sgde_front/src/src.dart';
import 'package:flutter/material.dart';



class SidebarXExampleApp extends StatelessWidget {
  SidebarXExampleApp({Key? key}) : super(key: key);

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SidebarX Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: canvasColor,
                    title: Text(_getTitleByIndex(_controller.selectedIndex)),
                    leading: IconButton(
                      onPressed: () {
                        // if (!Platform.isAndroid && !Platform.isIOS) {
                        //   _controller.setExtended(true);
                        // }
                        _key.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  )
                : null,
            drawer: ExampleSidebarX(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) ExampleSidebarX(controller: _controller),
                Expanded(
                  child: Center(
                    child: _ScreensExample(
                      controller: _controller,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/images/avatar.png'),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Dashboard',
          onTap: () {
            _controller.selectIndex(0);
          },
        ),
        SidebarXItem(
          icon: Icons.devices,
          label: 'Equipamento',
          onTap: () {
            _controller.selectIndex(1);
          },
        ),
        SidebarXItem(
          icon: Icons.swap_horiz,
          label: 'Alocação',
          onTap: () {
            _controller.selectIndex(2);
          },
        ),
        SidebarXItem(
          icon: Icons.build,
          label: 'Manutenção',
          onTap: () {
            _controller.selectIndex(3);
          },
        ),
        SidebarXItem(
          icon: Icons.assignment,
          label: 'Empréstimo',
          onTap: () {
            _controller.selectIndex(4);
          },
        ),
        SidebarXItem(
          icon: Icons.warning,
          label: 'Avaria',
          onTap: () {
            _controller.selectIndex(5);
          },
        ),
        SidebarXItem(
          icon: Icons.request_page,
          label: 'Requisição',
          onTap: () {
            _controller.selectIndex(6);
          },
        ),
      ],
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return const DashboardScreen();
          case 1:
            return const EquipamentoScreen();
          case 2:
            return const AlocacaoEquipamentoScreen();
          case 3:
            return const ManutencaoEquipamentoScreen();
          case 4:
            return const EmprestimoEquipamentoScreen();
          case 5:
            return const AvariaEquipamentoScreen();
          case 6:
            return const RequisicaoEquipamentoScreen();
          default:
            return Text(
              pageTitle,
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Dashboard';
    case 1:
      return 'Equipamento';
    case 2:
      return 'Alocação';
    case 3:
      return 'Manutenção';
    case 4:
      return 'Empréstimo';
    case 5:
      return 'Avaria';
    case 6:
      return 'Requisição';
    default:
      return 'Meu App';
  }
}
// Defina as cores aqui (ou em um arquivo separado)
const primaryColor = Colors.white;
const canvasColor = Color(0xFF204287); // Azul sidebar (mais escuro e profissional)
var scaffoldBackgroundColor = Colors.grey[50]; // Quase branco
const accentCanvasColor = Color(0xFF16305E); // Azul mais escuro para o gradiente
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
