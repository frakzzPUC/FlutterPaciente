import 'package:flutter/material.dart';
import 'package:flutter_itooth/camera_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class EmergencyPage extends StatefulWidget {
  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  Future<void> saveData(String fcmToken) async {
    String uid = await FirebaseMessaging.instance.getToken() ?? '';

    if (uid.isNotEmpty) {
      CollectionReference emergencies = FirebaseFirestore.instance.collection('emergencies');
      DocumentReference docRef = await emergencies.add({
        'uid': uid,
        'fcmToken': fcmToken,
        'status': 'draft',
        'name': '',
        'phoneNumber':'',
      });

      String documentId = docRef.id;  // Aqui é onde você salva o ID do documento

      // Salvando o documentId no Firestore
      CollectionReference users = FirebaseFirestore.instance.collection('documentID');
      await users.doc(uid).set({
        'documentId': documentId,
      });

      // Navegar para HomePage após a operação bem-sucedida
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraPage()),
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
  }

  void _validateInputs(String fcmToken) async {
    if (fcmToken.isNotEmpty) {
      await saveData(fcmToken);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Por favor, forneça um FCM Token válido.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String? fcmToken = await FirebaseMessaging.instance.getToken();
            _validateInputs(fcmToken ?? '');
          },
          child: Text('EMERGÊNCIA'),
        ),
      ),
    );
  }
}
