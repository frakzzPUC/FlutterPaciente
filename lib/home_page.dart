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

  void _onAddPhotoButtonPressed() async {
    final XFile? imagemTemporaria =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (imagemTemporaria != null) {
      setState(() {
        imagemSelecionada = File(imagemTemporaria.path);
      });
    }
  }

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
        MaterialPageRoute(builder: (context) => SecondScreen(image: imagemSelecionada!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itooth'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                onPressed: _onAddPhotoButtonPressed,
                icon: Icon(Icons.add_photo_alternate_outlined),
              ),
              IconButton(
                onPressed: _onTakePhotoButtonPressed,
                icon: Icon(Icons.photo_camera_outlined),
              ),
            ],
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
