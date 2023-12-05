import 'package:flutter/material.dart';
import 'package:anime_app/screen/Login_Screens/recuperacion.dart';
import 'package:anime_app/screen/Login_Screens/registrar.dart';
import 'package:anime_app/screen/home_screen.dart';
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
        title: Text('Inicio de Sesión', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0, // No shadow
        backgroundColor: Colors.black, // Fondo negro
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/goku.jpg', // Reemplaza con la ruta correcta de tu imagen de fondo
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100),
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
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await Provider.of<MyAppAuthProvider.AuthProvider>(context, listen: false).login(
                          _emailController.text,
                          _passwordController.text,
                        );

                        if (Provider.of<MyAppAuthProvider.AuthProvider>(context, listen: false).isAuthenticated) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Inicio de sesión exitoso'),
                            ),
                          );

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Credenciales inválidas, vuelve a intentarlo.'),
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error durante el inicio de sesión: ${e.message}'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error durante el inicio de sesión: $e'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // Color del botón negro
                      onPrimary: Colors.white, // Texto blanco
                    ),
                    child: Text('Iniciar Sesión'),
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [Colors.purpleAccent, Colors.cyan],
                        ).createShader(bounds);
                      },
                      child: Text(
                        '¿No tienes cuenta? Regístrate',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [Colors.purpleAccent, Colors.cyan],
                        ).createShader(bounds);
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
