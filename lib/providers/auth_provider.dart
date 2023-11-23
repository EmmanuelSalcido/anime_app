import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? _nick;

  String? get nick => _nick;
  bool get isAuthenticated => _auth.currentUser != null;

  // Registro de usuario
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

        // Actualizar la información del usuario en Firestore
        await _updateUserInfo(userCredential.user!.uid, nick);

        // Actualizar el objeto User en FirebaseAuth
        User? updatedUser = _auth.currentUser;
        if (updatedUser != null) {
          _nick = nick;
          notifyListeners();
        }

        // Mostrar un SnackBar indicando que el registro fue exitoso y se envió un correo de verificación
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

  // Actualizar la información del usuario en Firestore
  Future<void> _updateUserInfo(String uid, String nick) async {
    try {
      // Actualizar el campo "nick" en Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'nick': nick,
        'uid': uid,
        'favoriteAnimes': [], // Inicializar la lista de animes favoritos
      });
    } catch (error) {
      print(error.toString());
    }
  }

  // Inicio de sesión de usuario
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Actualizar el nick localmente después de iniciar sesión
      await _updateLocalNick();
    } on FirebaseAuthException catch (e) {
      print(e);
      throw e;
    }
  }

  // Actualizar el nick localmente desde Firestore
  Future<void> _updateLocalNick() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Obtener el nick desde Firestore y actualizar el valor localmente
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        _nick = userDoc['nick'];
        notifyListeners();
      }
    }
  }

  // Cierre de sesión de usuario
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

  // Envío de correo electrónico para restablecer la contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // Método para agregar o quitar de favoritos
  Future<void> toggleFavoriteAnime(String animeId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Obtener la lista de animes favoritos del usuario
        List<String> favoriteAnimes = List<String>.from((await userRef.get())['favoriteAnimes']);

        // Verificar si el anime ya está en la lista
        if (favoriteAnimes.contains(animeId)) {
          // Quitar el anime de la lista si ya está presente
          favoriteAnimes.remove(animeId);
        } else {
          // Agregar el anime a la lista si no está presente
          favoriteAnimes.add(animeId);
        }

        // Actualizar la lista de animes favoritos en Firestore
        await userRef.update({'favoriteAnimes': favoriteAnimes});
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  // Obtener la lista de animes favoritos del usuario
  Future<List<String>> getFavoriteAnimes() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return List<String>.from(userDoc['favoriteAnimes']);
        }
      }
      return []; // Devuelve una lista vacía si no hay animes favoritos o hay algún error
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

}
