import 'package:cetic_sgde_front/main.dart';
import 'package:flutter/material.dart';
import 'package:cetic_sgde_front/restrict/pages/componets/sidebar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cetic_sgde_front/src/src.dart';
import 'package:cetic_sgde_front/auth/models/cadastro.dart';
import 'package:cetic_sgde_front/auth/service/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _contatoController = TextEditingController();
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _contatoController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility(bool isPassword) {
    setState(() {
      if (isPassword) {
        _obscureTextPassword = !_obscureTextPassword;
      } else {
        _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
      }
    });
  }

  void launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrlString(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: canvasColor,
        title: const Text('SGDE Cadastro', style: TextStyle(color: Colors.white)),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isWide
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Card(
                    elevation: 5,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            color: canvasColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/logo.png', // Caminho corrigido do logo
                                  height: 80,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "SGDE - Crie sua Conta", // Adjusted Text
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    controller: _nomeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Nome',
                                      prefixIcon: Icon(Icons.person_outline),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Informe seu nome';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email_outlined),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Informe seu email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscureTextPassword,
                                    decoration: InputDecoration(
                                      labelText: 'Senha',
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: Icon(_obscureTextPassword ? Icons.visibility : Icons.visibility_off),
                                        onPressed: () => _togglePasswordVisibility(true),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Informe sua senha';
                                      }
                                      if (value.length < 6) {
                                        return 'A senha deve ter pelo menos 6 caracteres';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: _obscureTextConfirmPassword,
                                    decoration: InputDecoration(
                                      labelText: 'Confirmar Senha',
                                      prefixIcon: const Icon(Icons.lock_outline),
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: Icon(_obscureTextConfirmPassword ? Icons.visibility : Icons.visibility_off),
                                        onPressed: () => _togglePasswordVisibility(false),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Confirme sua senha';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'As senhas não coincidem';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _contatoController,
                                    decoration: const InputDecoration(
                                      labelText: 'Contato (opcional)',
                                      prefixIcon: Icon(Icons.phone),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : () async {
                                              if (_formKey.currentState!.validate()) {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                final usuario = UsuarioCadastroModel(
                                                  nome: _nomeController.text,
                                                  email: _emailController.text,
                                                  senha: _passwordController.text,
                                                  contato: _contatoController.text,
                                                );
                                                try {
                                                  // Salva dados no cache local
                                                  final prefs = await SharedPreferences.getInstance();
                                                  await prefs.setString('usuario_nome', _nomeController.text);
                                                  await prefs.setString('usuario_email', _emailController.text);
                                                  await prefs.setString('usuario_contato', _contatoController.text);
                                                  await prefs.setString('usuario_senha', _passwordController.text); // Salva a senha também
                                                  final msg = await Provider.of<AuthProvider>(context, listen: false).registrarUsuario(usuario);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(msg), backgroundColor: Colors.green),
                                                  );
                                                  Navigator.pop(context); // Volta para login
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
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: canvasColor,
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text('Cadastrar', style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 5,
                      child: Container(
                        width: double.infinity,
                        color: canvasColor,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 80,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "SGDE - Crie sua Conta",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: _nomeController,
                                decoration: const InputDecoration(
                                  labelText: 'Nome',
                                  prefixIcon: Icon(Icons.person_outline),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Informe seu nome';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Informe seu email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscureTextPassword,
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureTextPassword ? Icons.visibility : Icons.visibility_off),
                                    onPressed: () => _togglePasswordVisibility(true),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Informe sua senha';
                                  }
                                  if (value.length < 6) {
                                    return 'A senha deve ter pelo menos 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureTextConfirmPassword,
                                decoration: InputDecoration(
                                  labelText: 'Confirmar Senha',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureTextConfirmPassword ? Icons.visibility : Icons.visibility_off),
                                    onPressed: () => _togglePasswordVisibility(false),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Confirme sua senha';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'As senhas não coincidem';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _contatoController,
                                decoration: const InputDecoration(
                                  labelText: 'Contato (opcional)',
                                  prefixIcon: Icon(Icons.phone),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!.validate()) {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            final usuario = UsuarioCadastroModel(
                                              nome: _nomeController.text,
                                              email: _emailController.text,
                                              senha: _passwordController.text,
                                              contato: _contatoController.text,
                                            );
                                            try {
                                              // Salva dados no cache local
                                              final prefs = await SharedPreferences.getInstance();
                                              await prefs.setString('usuario_nome', _nomeController.text);
                                              await prefs.setString('usuario_email', _emailController.text);
                                              await prefs.setString('usuario_contato', _contatoController.text);
                                              await prefs.setString('usuario_senha', _passwordController.text); // Salva a senha também
                                              final msg = await Provider.of<AuthProvider>(context, listen: false).registrarUsuario(usuario);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(msg), backgroundColor: Colors.green),
                                              );
                                              Navigator.pop(context); // Volta para login
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
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: canvasColor,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Cadastrar', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}