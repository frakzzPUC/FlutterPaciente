import 'package:flutter/material.dart';
import 'package:flutter_itooth/third_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';


class SecondScreen extends StatefulWidget {
  final File image; // Adicione um campo para a imagem

  // Modifique o construtor para aceitar a imagem como argumento
  SecondScreen({required this.image});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String _nameErrorMessage = '';
  String _phoneNumberErrorMessage = '';

  Future<void> saveData(String name, String phoneNumber) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .add({
      'name': name, // Nome
      'phoneNumber': phoneNumber, // Número de telefone
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> uploadFile(File file) async {
    try {
      var uuid = Uuid();
      // Substitua o nome do arquivo conforme necessário
      await FirebaseStorage.instance
          .ref('uploads/${uuid.v1()}.png')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
    }
  }

  void _validateInputs() async {
    final fullName = _nameController.text;
    final phoneNumber = _phoneNumberController.text;

    if (fullName.length >= 7 && phoneNumber.length >= 11) {
      await saveData(fullName, phoneNumber);
      await uploadFile(widget.image); // Chame a função uploadFile aqui
      setState(() {
        _nameErrorMessage = '';
        _phoneNumberErrorMessage = '';
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ThirdScreen()),
      );
    } else {
      setState(() {
        _nameErrorMessage = fullName.length < 7 ? 'O nome deve ter pelo menos 7 letras' : '';
        _phoneNumberErrorMessage = phoneNumber.length < 11 ? 'O número de telefone deve ter pelo menos 11 dígitos' : '';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF389BA6)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Digite seu nome completo',
                    labelText: 'Digite seu nome completo',
                    labelStyle: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF389BA6),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (_nameErrorMessage.isNotEmpty)
                Text(
                  _nameErrorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 8.0),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF389BA6)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    hintText: 'Digite seu número de telefone',
                    labelText: 'Digite seu número de telefone',
                    labelStyle: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF389BA6),
                    ),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              if (_phoneNumberErrorMessage.isNotEmpty)
                Text(
                  _phoneNumberErrorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: _validateInputs,
                child: Text('Validar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
