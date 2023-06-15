import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_itooth/rating_dentist.dart';

class LocView extends StatefulWidget {
  final LatLng center;
  final String uidDentista;

  LocView({required this.center, required this.uidDentista});

  @override
  _LocViewState createState() => _LocViewState();
}

class _LocViewState extends State<LocView> {

  Future<void> updateStatus(String status) async {
    final String uid = await FirebaseMessaging.instance.getToken() ?? '';

    CollectionReference users = FirebaseFirestore.instance.collection('documentID');
    DocumentSnapshot docSnapshot = await users.doc(uid).get();
    Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?; //
    String? documentId = data?['documentId'];

    CollectionReference emergencies = FirebaseFirestore.instance.collection('emergencies');
    await emergencies.doc(documentId).update({'status': 'done'});
  }


  void _finalizeSession() async {
    // Atualizar status para "done"
    await updateStatus('done');

    // Excluir documento de "acceptances"
    CollectionReference acceptances = FirebaseFirestore.instance.collection('acceptances');
    acceptances.doc(widget.uidDentista).delete();

    // Navegar para a tela de avaliação (RatingDentist)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RatingDentist(uidDentista: widget.uidDentista,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.center,
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('dentist_location'),
                  position: widget.center,
                ),
              },
            ),
          ),
          Container(
            height: 60.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _finalizeSession,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Define a cor vermelha
              ),
              child: Text(
                'Finalizar Atendimento',
                style: TextStyle(
                  color: Colors.white, // Define a cor do texto como branco
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
