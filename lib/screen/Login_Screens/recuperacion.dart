import 'package:anime_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Contraseña', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/goku.jpg', // Reemplaza con la ruta correcta de tu imagen de fondo
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ingresa tu correo electrónico para recibir un enlace de restablecimiento de contraseña.',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Provider.of<AuthProvider>(context, listen: false)
                          .sendPasswordResetEmail(_emailController.text);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Correo de restablecimiento enviado. Revisa tu bandeja de entrada.'),
                        ),
                      );

                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al enviar el correo de restablecimiento: $e'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Enviar Correo de Restablecimiento'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
