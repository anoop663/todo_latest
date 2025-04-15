// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application_1/register/controller/register_provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final passwordController = TextEditingController();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: screenHeight * 0.3,
                color: const Color.fromRGBO(13, 13, 13, 1),
              ),
              Expanded(
                child: Container(
                  color: const Color.fromRGBO(26, 26, 26, 1),
                ),
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.3 - 30,
            left: 16,
            right: 16,
            child: Consumer<RegisterProvider>(
              builder: (context, provider, _) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(38, 38, 38, 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextField(emailController, '📧 Email'),
                      const SizedBox(height: 12),
                      _buildTextField(nameController, '👤 Name'),
                      const SizedBox(height: 12),
                      _buildTextField(passwordController, '🔐 Password', obscureText: true),
                      const SizedBox(height: 16),
                      provider.isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                onPressed: () async {
                                  final result = await provider.register(
                                    emailController.text.trim(),
                                    nameController.text.trim(),
                                    passwordController.text.trim(),
                                  );

                                  if (result == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Registration Successful")),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(result)),
                                    );
                                  }
                                },
                                child: const Text('Register', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromRGBO(48, 48, 48, 1),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
