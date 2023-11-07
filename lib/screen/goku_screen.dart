import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class GokuScreen extends StatefulWidget {
  @override
  _GokuScreenState createState() => _GokuScreenState();
}

class _GokuScreenState extends State<GokuScreen> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();

    // Inicia la reproducción de audio al cargar la pantalla
    _startAudio();
  }

  Future<void> _startAudio() async {
    await audioPlayer.setAsset('assets/uiTheme.mp3'); // Reemplaza con la ubicación de tu archivo de audio
    await audioPlayer.play();
  }

  Future<void> _toggleAudio() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
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
        backgroundColor: Colors.black, // Fondo negro
        title: Text('Goku'),
        actions: [
          IconButton(
            onPressed: _toggleAudio,
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow), // Cambia el icono aquí
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/epicgoku.jpg', // Reemplaza con la ubicación de tu imagen de fondo
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover, // Usa "cover" para que la imagen no se haga zoom
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¡En China Las Puertas reCHINAN!',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
