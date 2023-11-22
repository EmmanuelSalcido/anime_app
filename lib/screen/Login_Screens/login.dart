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
                        content: Text('inválido, vuelve a intentarlo :v'),
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
              child: Text('Iniciar sesión'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
               
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('¿No tienes cuenta? Regístrate'),
            ),
            TextButton(
              onPressed: () {
               
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
