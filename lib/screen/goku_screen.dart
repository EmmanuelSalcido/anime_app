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

  Future<void> _launchRepositoryURL(BuildContext context) async {
    const url = 'https://github.com/EmmanuelSalcido/anime_app';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content: Text("¿Quieres abrir el enlace a GitHub?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                if (await canLaunch(url)) {
                  await launch(url);
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  throw 'No se puede abrir $url';
                }
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchWebsiteURL(BuildContext context) async {
    const url = 'https://anime-app-snowy.vercel.app/';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Advertencia"),
          content: Text("Este es un sitio web beta. ¿Deseas continuar?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                if (await canLaunch(url)) {
                  await launch(url);
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  throw 'No se puede abrir $url';
                }
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
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
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade800,
            ),
            child: IconButton(
              icon: _isPlaying
                  ? Image.asset('assets/mute.jpg')
                  : Image.asset('assets/play.jpg'),
              onPressed: _toggleAudio,
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft),
          onPressed: () {
            audioPlayer.stop();
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
          Positioned(
            bottom: 35,
            right: 24,
            child: Text(
              'Version: 1.3.1',
              style: TextStyle(fontSize: 21, color: Colors.white),
            ),
          ),
          Positioned(
            top: 525,
            right: 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    _launchRepositoryURL(context);
                  },
                  child: Icon(
                    MdiIcons.github,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    _launchWebsiteURL(context);
                  },
                  child: Icon(
                    Icons.language,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
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
