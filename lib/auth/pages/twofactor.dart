import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cetic_sgde_front/auth/service/auth_provider.dart';
import 'package:cetic_sgde_front/auth/models/twofactor.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:url_launcher/url_launcher.dart';

class TwoFactorPage extends StatefulWidget {
  const TwoFactorPage({Key? key}) : super(key: key);

  @override
  State<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
  final _formKey = GlobalKey<FormState>();
  final _2faController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _2faController.dispose();
    super.dispose();
  }

  Future<void> _verificar2FA() async {
    if (_formKey.currentState!.validate()) {
      if (_2faController.text.trim() != 'sgde123') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('O código informado está incorreto. Use sgde123.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<AuthProvider>(context, listen: false).verificar2FA(
          TwoFactorAuthModel(codigo2FA: _2faController.text),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SidebarXExampleApp()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: canvasColor,
        title: const Text('Autenticação em Duas Etapas', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                const Text(
                  '© 2025 Felton da Silva',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                IconButton(
                  icon: const Icon(Icons.web, color: Colors.white, size: 20),
                  tooltip: 'Website',
                  onPressed: () {
                    launchUrl('https://felton.dev');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.code, color: Colors.white, size: 20),
                  tooltip: 'GitHub',
                  onPressed: () {
                    launchUrl('https://github.com/feltonds');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.business, color: Colors.white, size: 20),
                  tooltip: 'LinkedIn',
                  onPressed: () {
                    launchUrl('https://www.linkedin.com/in/feltonds/');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: isWide
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(), // Espaço vazio para simetria
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: _isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Digite sgde123 como código de autenticação',
                                          style: TextStyle(fontSize: 16, color: Colors.black87),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: _2faController,
                                          decoration: const InputDecoration(
                                            labelText: 'Código 2FA',
                                            prefixIcon: Icon(Icons.security),
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Informe o código 2FA';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 24),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: _isLoading ? null : _verificar2FA,
                                            child: _isLoading
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<Color>(
                                                              Colors.white),
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : const Text('Verificar'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(), // Espaço vazio para simetria
                      ),
                    ],
                  )
                : ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Digite 010203 como código de autenticação',
                                      style: TextStyle(fontSize: 16, color: Colors.black87),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _2faController,
                                      decoration: const InputDecoration(
                                        labelText: 'Código 2FA',
                                        prefixIcon: Icon(Icons.security),
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Informe o código 2FA';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _verificar2FA,
                                        child: _isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<Color>(
                                                          Colors.white),
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Text('Verificar'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// Adicione esta função utilitária no arquivo:
void launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    launchUrl(uri as String);
  }
}
