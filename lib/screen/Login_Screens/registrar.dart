import 'package:anime_app/providers/auth_provider.dart';
import 'package:anime_app/screen/Login_Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:anime_app/providers/auth_provider.dart' as MyAppAuthProvider;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nickController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nickController,
              decoration: InputDecoration(labelText: 'Nick'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Provider.of<MyAppAuthProvider.AuthProvider>(context, listen: false)
                      .register(
                    context,
                    _nickController.text,
                    _emailController.text,
                    _passwordController.text,
                  );

                  // Redirige al usuario a la pantalla de inicio de sesión
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  // Manejo de excepciones específicas de FirebaseAuth
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error durante el registro: ${e.message}'),
                    ),
                  );
                } catch (e) {
                  // Manejo de errores generales
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error durante el registro: $e'),
                    ),
                  );
                }
              },
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
