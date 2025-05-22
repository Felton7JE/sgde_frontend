import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/auth/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:cetic_sgde_front/auth/service/auth_provider.dart';
import 'package:cetic_sgde_front/restrict/service/alocacao_provider.dart';
import 'package:cetic_sgde_front/restrict/service/avaria_provider.dart';
import 'package:cetic_sgde_front/restrict/service/emprestimo_provider.dart';
import 'package:cetic_sgde_front/restrict/service/manutencao_provider.dart';
import 'package:cetic_sgde_front/restrict/service/equipamento_provider.dart';
import 'package:cetic_sgde_front/restrict/service/requisicao_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AlocacaoProvider()),
        ChangeNotifierProvider(create: (_) => AvariaProvider()),
        ChangeNotifierProvider(create: (_) => EmprestimoProvider()),
        ChangeNotifierProvider(create: (_) => ManutencaoProvider()),
        ChangeNotifierProvider(create: (_) => EquipamentoProvider()),
        ChangeNotifierProvider(create: (_) => RequisicaoProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CETIC SGDE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // Inicia com a página de login
    );
  }
}