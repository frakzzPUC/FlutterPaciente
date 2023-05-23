import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'second_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImagePicker imagePicker = ImagePicker();
  File? imagemSelecionada;

  void _onTakePhotoButtonPressed() async {
    final XFile? imagemTemporaria =
    await imagePicker.pickImage(source: ImageSource.camera);
    if (imagemTemporaria != null) {
      setState(() {
        imagemSelecionada = File(imagemTemporaria.path);
      });
    }
  }

  void _navigateToSecondScreen() {
    if (imagemSelecionada != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(image: imagemSelecionada!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF389BA6),
                  Color(0xFF6CCECB),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            left: 0.0,
            right: 0.0,
            child: Image.asset(
              'assets/images/itooth.png',
              width: 130.0,
              height: 130.0,
              alignment: Alignment.center,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imagemSelecionada == null
                    ? Container()
                    : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.file(imagemSelecionada!),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _onTakePhotoButtonPressed,
                      icon: Icon(Icons.photo_camera_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToSecondScreen,
        child: Icon(Icons.arrow_forward),
        backgroundColor: imagemSelecionada != null ? Colors.green : Colors.grey,
      ),
    );
  }
}
