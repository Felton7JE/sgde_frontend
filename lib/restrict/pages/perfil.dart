import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cetic_sgde_front/auth/service/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cetic_sgde_front/auth/pages/login.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String? _nome;
  String? _email;
  String? _contato;
  String? _senha;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Exemplo: supondo que os dados do usuário estão salvos no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString('usuario_nome') ?? 'Usuário';
      _email = prefs.getString('usuario_email') ?? 'Email não disponível';
      _contato = prefs.getString('usuario_contato') ?? '-';
      _senha = prefs.getString('usuario_senha') ?? '-';
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    Provider.of<AuthProvider>(context, listen: false).logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: const AssetImage('assets/images/avatar.png'),
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _nome ?? '',
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _email ?? '',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text('Contato: ${_contato ?? '-'}', style: GoogleFonts.poppins(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Senha: ${_senha ?? '-'}', style: GoogleFonts.poppins(fontSize: 16)),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Sair'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
