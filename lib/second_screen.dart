import 'package:flutter/material.dart';
import 'package:flutter_itooth/third_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> updateData(String name, String phoneNumber) async {
    final String uid = await FirebaseMessaging.instance.getToken() ?? '';

    CollectionReference users = FirebaseFirestore.instance.collection('documentID'); // Define a referência
    DocumentSnapshot docSnapshot = await users.doc(uid).get();
    Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?; //
    String? documentId = data?['documentId'];

    // Atualiza os campos de nome e telefone no Firestore usando o documentId
    CollectionReference emergencies = FirebaseFirestore.instance.collection('emergencies');
    await emergencies.doc(documentId).update({
      'name': name,
      'phoneNumber': phoneNumber,
      'status': 'new',
    });
  }

  Future<void> uploadFile(String uid, File file) async {
    try {
      var uuid = Uuid();
      // Substitui o nome do arquivo conforme necessário
      await FirebaseStorage.instance
          .ref('uploads/$uid/${uuid.v1()}.png')
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
      String? uid = await FirebaseMessaging.instance.getToken();
      if (uid != null && uid.isNotEmpty) {
        await updateData(fullName, phoneNumber);
        await uploadFile(uid, widget.image); // Chama a função uploadFile aqui
        setState(() {
          _nameErrorMessage = '';
          _phoneNumberErrorMessage = '';
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ThirdScreen()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text('Falha ao obter o UID do usuário.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
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
      body: Container(
        padding: EdgeInsets.all(16.0),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/itooth.png', // Caminho para a imagem da logo
              width: 150.0,
              height: 150.0,
            ),
            SizedBox(height: 32.0),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
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
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _validateInputs,
              child: Text(
                'Chamar Emergência',
                style: TextStyle(fontSize: 18.0),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF389BA6),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
