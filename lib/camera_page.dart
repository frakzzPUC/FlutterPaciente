import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'cadastro_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
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

  void _navigateToCadastroScreen() {
    if (imagemSelecionada != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroPage(image: imagemSelecionada!),
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
                      iconSize: 40.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCadastroScreen,
        child: Icon(Icons.arrow_forward),
        backgroundColor: imagemSelecionada != null ? Colors.green : Colors.grey,
      ),
    );
  }
}
