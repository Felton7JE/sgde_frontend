import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/auth/service/auth.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RedefinirSenhaPage extends StatefulWidget {
  final String token;
  const RedefinirSenhaPage({Key? key, required this.token}) : super(key: key);

  @override
  State<RedefinirSenhaPage> createState() => _RedefinirSenhaPageState();
}

class _RedefinirSenhaPageState extends State<RedefinirSenhaPage> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _obscureSenha = true;
  bool _obscureConfirmar = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _toggleObscure(bool isSenha) {
    setState(() {
      if (isSenha) {
        _obscureSenha = !_obscureSenha;
      } else {
        _obscureConfirmar = !_obscureConfirmar;
      }
    });
  }

  Future<void> _redefinirSenha() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final authService = AuthService();
      try {
        final msg = await authService.redefinirSenha(widget.token, _senhaController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.green),
        );
        Navigator.of(context).popUntil((route) => route.isFirst); // Volta para tela inicial/login
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
        title: const Text('Redefinir Senha', style: TextStyle(color: Colors.white)),
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
                                        TextFormField(
                                          controller: _senhaController,
                                          obscureText: _obscureSenha,
                                          decoration: InputDecoration(
                                            labelText: 'Nova Senha',
                                            prefixIcon: const Icon(Icons.lock_outline),
                                            border: const OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                              icon: Icon(_obscureSenha ? Icons.visibility : Icons.visibility_off),
                                              onPressed: () => _toggleObscure(true),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Informe a nova senha';
                                            }
                                            if (value.length < 6) {
                                              return 'A senha deve ter pelo menos 6 caracteres';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: _confirmarSenhaController,
                                          obscureText: _obscureConfirmar,
                                          decoration: InputDecoration(
                                            labelText: 'Confirmar Nova Senha',
                                            prefixIcon: const Icon(Icons.lock_outline),
                                            border: const OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                              icon: Icon(_obscureConfirmar ? Icons.visibility : Icons.visibility_off),
                                              onPressed: () => _toggleObscure(false),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Confirme a nova senha';
                                            }
                                            if (value != _senhaController.text) {
                                              return 'As senhas não coincidem';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 24),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: _isLoading
                                                ? null
                                                : _redefinirSenha,
                                            child: _isLoading
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: CircularProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : const Text('Redefinir Senha'),
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
                                    TextFormField(
                                      controller: _senhaController,
                                      obscureText: _obscureSenha,
                                      decoration: InputDecoration(
                                        labelText: 'Nova Senha',
                                        prefixIcon: const Icon(Icons.lock_outline),
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          icon: Icon(_obscureSenha ? Icons.visibility : Icons.visibility_off),
                                          onPressed: () => _toggleObscure(true),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Informe a nova senha';
                                        }
                                        if (value.length < 6) {
                                          return 'A senha deve ter pelo menos 6 caracteres';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _confirmarSenhaController,
                                      obscureText: _obscureConfirmar,
                                      decoration: InputDecoration(
                                        labelText: 'Confirmar Nova Senha',
                                        prefixIcon: const Icon(Icons.lock_outline),
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          icon: Icon(_obscureConfirmar ? Icons.visibility : Icons.visibility_off),
                                          onPressed: () => _toggleObscure(false),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Confirme a nova senha';
                                        }
                                        if (value != _senhaController.text) {
                                          return 'As senhas não coincidem';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _isLoading
                                            ? null
                                            : _redefinirSenha,
                                        child: _isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Text('Redefinir Senha'),
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

void launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrlString(url);
  }
}
