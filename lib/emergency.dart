import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_itooth/camera_page.dart';

class EmergencyPage extends StatefulWidget {
  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  Future<void> saveData() async {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    User? user = userCredential.user;
    String uid = user?.uid ?? '';

    if (uid.isNotEmpty) {
      CollectionReference emergencies = FirebaseFirestore.instance.collection('emergencies');
      DocumentReference docRef = emergencies.doc(uid); // Utilize o UID como ID do documento

      await docRef.set({
        'uid': uid,
        'status': 'draft',
        'name': '',
        'phoneNumber': '',
      });

      // Navegar para a página da câmera após a operação bem-sucedida
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

  void _validateInputs() async {
    await saveData();
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF389BA6),
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: _validateInputs,
              child: Text('EMERGÊNCIA'),
            ),
          ),
        ],
      ),
    );
  }
}
