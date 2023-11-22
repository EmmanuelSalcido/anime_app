import 'package:anime_app/screen/Login_Screens/recuperacion.dart';
import 'package:anime_app/screen/Login_Screens/registrar.dart';
import 'package:anime_app/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:anime_app/providers/auth_provider.dart' as MyAppAuthProvider;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                      .login(
                    _emailController.text,
                    _passwordController.text,
                  );

                  // Verifica si el usuario está autenticado
                  if (Provider.of<MyAppAuthProvider.AuthProvider>(context, listen: false).isAuthenticated) {
                    // Si está autenticado, muestra un SnackBar y redirige a la pantalla de inicio
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Inicio de sesión exitoso'),
                      ),
                    );

                    // Redirige al usuario a la pantalla de inicio (HomeScreen)
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  } else {
                    // Si no está autenticado, muestra un SnackBar con un mensaje de advertencia
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Credenciales inválidas'),
                      ),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  // Manejo de excepciones específicas de FirebaseAuth
                  // Puedes mostrar mensajes de error más específicos según la excepción

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error durante el inicio de sesión: ${e.message}'),
                    ),
                  );
                } catch (e) {
                  // Manejo de errores generales
                  // Puedes mostrar un mensaje genérico o hacer algo más según el tipo de error

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error durante el inicio de sesión: $e'),
                    ),
                  );
                }
              },
              child: Text('Iniciar sesión'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Navegar a la pantalla de registro
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('¿No tienes cuenta? Regístrate'),
            ),
            TextButton(
              onPressed: () {
                // Navegar a la pantalla de recuperación de contraseña
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                );
              },
              child: Text('¿Olvidaste tu contraseña?'),
            ),
          ],
        ),
      ),
    );
  }
}
