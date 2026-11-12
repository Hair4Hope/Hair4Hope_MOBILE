import 'package:flutter/material.dart';
import 'package:iam_app/components/login_pop_up.dart';
import 'package:iam_app/services/auth_service.dart';

class RegisterPopUp extends StatefulWidget {
  const RegisterPopUp({super.key});

  @override
  State<RegisterPopUp> createState() => _RegisterPopUpState();
}

class _RegisterPopUpState extends State<RegisterPopUp> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _numeroController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _numeroController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerCadastro() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final numero = _numeroController.text
        .replaceAll(RegExp(r'\D'), '');
    final senha = _senhaController.text.trim();

    if (nome.isEmpty ||
        email.isEmpty ||
        numero.isEmpty ||
        senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, preencha todos os campos.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.registrar(
        nome: nome,
        email: email,
        numero: numero,
        senha: senha,
      );

      if (!mounted) return;

      if (result['success']) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
        // Abre o popup de login após cadastro
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const LoginPopUp();
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro de conexão. Tente novamente.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.person_add_outlined,
              size: 64,
              color: Color(0xFFEC2C8F),
            ),
            const SizedBox(height: 12),
            const Text(
              'Criar Conta',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 24),

            // Campo de Nome
            TextField(
              controller: _nomeController,
              textCapitalization:
                  TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Nome completo',
                labelStyle: TextStyle(
                  color: Colors.grey.shade600,
                ),
                prefixIcon: Icon(
                  Icons.badge_outlined,
                  color: Colors.grey.shade600,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFEC2C8F),
                    width: 2,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 16.0,
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de Email
            TextField(
              controller: _emailController,
              keyboardType:
                  TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.grey.shade600,
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.grey.shade600,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFEC2C8F),
                    width: 2,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 16.0,
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de Número (Telefone)
            TextField(
              controller: _numeroController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter
                    .digitsOnly,
                LengthLimitingTextInputFormatter(
                  11,
                ),
                _PhoneInputFormatter(),
              ],
              decoration: InputDecoration(
                labelText: 'Número de telefone',
                hintText: '(00) 00000-0000',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                ),
                labelStyle: TextStyle(
                  color: Colors.grey.shade600,
                ),
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: Colors.grey.shade600,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFEC2C8F),
                    width: 2,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 16.0,
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de Senha
            TextField(
              controller: _senhaController,
              obscureText: _obscurePassword,
              onSubmitted: (_) => _fazerCadastro(),
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(
                  color: Colors.grey.shade600,
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Colors.grey.shade600,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons
                              .visibility_off_outlined
                        : Icons
                              .visibility_outlined,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword =
                          !_obscurePassword;
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFEC2C8F),
                    width: 2,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 16.0,
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // Botão Cadastrar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFFEC2C8F,
                ),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30.0),
                ),
                padding:
                    const EdgeInsets.symmetric(
                      vertical: 14.0,
                    ),
              ),
              onPressed: _isLoading
                  ? null
                  : _fazerCadastro,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child:
                          CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                    )
                  : const Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // Link para Login
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  'Já tem uma conta? ',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder:
                          (BuildContext context) {
                            return const LoginPopUp();
                          },
                    );
                  },
                  child: const Text(
                    'Faça login',
                    style: TextStyle(
                      color: Color(0xFFEC2C8F),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Formatter para número de telefone brasileiro: (00) 00000-0000
class _PhoneInputFormatter
    extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(
      RegExp(r'\D'),
      '',
    );
    final buffer = StringBuffer();

    for (int i = 0;
        i < digits.length && i < 11;
        i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      if (i == 7) buffer.write('-');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }
}
