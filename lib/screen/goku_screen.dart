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
    await audioPlayer.setAsset('assets/uiTheme.mp3'); 
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
        backgroundColor: Colors.black, 
        title: Text('Welcome to the hell'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/epicgoku.jpg', 
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover, // cover para que la imagen no se haga zoom
          ),
          Align(
            alignment: Alignment.topRight, // Alinea el botón en la esquina superior derecha
            child: Container(
              margin: EdgeInsets.all(16),
              child: IconButton(
                onPressed: _toggleAudio,
                icon: Image.asset(
                  isPlaying ? 'assets/mute.jpg' : 'assets/play.jpg', // Ruta de las imágenes de pausa y reproducir con fondo transparente
                  width: 24, 
                  height: 24, 
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¡En China Las Puertas ReCHINAN!',
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
