import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? _nick;

  String? get nick => _nick;
  bool get isAuthenticated => _auth.currentUser != null;

  Future<void> register(BuildContext context, String nick, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verificar si el usuario se registró correctamente
      if (userCredential.user != null) {
        // Enviar correo de verificación
        await userCredential.user!.sendEmailVerification();

        // Actualizar el nombre del usuario (esto es opcional)
        await userCredential.user!.updateDisplayName(nick);

        // Actualizar el objeto User en FirebaseAuth
        User? updatedUser = _auth.currentUser;
        if (updatedUser != null) {
          _nick = nick;
          notifyListeners();
        }

        // Muestra un SnackBar indicando que el registro fue exitoso y se envió un correo de verificación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registro exitoso. Se envió un correo de verificación.'),
          ),
        );
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _nick = null;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
