import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GokuScreen extends StatefulWidget {
  @override
  _GokuScreenState createState() => _GokuScreenState();
}

class _GokuScreenState extends State<GokuScreen> {
  final audioPlayer = AudioPlayer();
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();

    // Inicia la reproducción de audio al cargar la pantalla
    _startAudio();
  }

  Future<void> _startAudio() async {
    if (_isPlaying) {
      await audioPlayer.setAsset('assets/uiTheme.mp3'); 
      await audioPlayer.play();
    }
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // Función para abrir el enlace a tu repositorio de GitHub
  Future<void> _launchRepositoryURL() async {
    const url = 'https://github.com/EmmanuelSalcido/anime_app'; // Reemplaza con la URL de tu repositorio
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se puede abrir $url';
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, 
        title: Text('Welcome to the hell', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft), // Cambia el ícono aquí
          onPressed: () {
            audioPlayer.stop(); // Detiene la música al salir de la pantalla
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/gokugod.gif', 
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill, 
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.all(24),
              child: IconButton(
                onPressed: _toggleAudio,
                icon: Image.asset(
                  _isPlaying ? 'assets/mute.jpg' : 'assets/play.jpg',
                  width: 24, 
                  height: 24, 
                ),
              ),
            ),
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'En China Las Puertas ReCHINAN',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
              ],
            ),
          ),
          // Enlace al repositorio de GitHub (parte inferior derecha)
          Positioned(
            bottom: 64, // Ajusta la posición vertical aquí
            right: 24,
            child: InkWell(
              onTap: _launchRepositoryURL,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/github.png', // Reemplaza con la ruta de tu imagen de GitHub
                    width: 40,
                    height: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Texto de la versión (parte inferior derecha)
          Positioned(
            bottom: 35, // Ajusta la posición vertical aquí
            right: 24,
            child: Text(
              'Version: 1.1.2',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Powered by JIKAN API',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}