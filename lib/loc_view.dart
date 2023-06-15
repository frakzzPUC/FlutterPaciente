import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    if (uid != null && uid.isNotEmpty) {
      CollectionReference emergencies = FirebaseFirestore.instance.collection('emergencies');
      QuerySnapshot querySnapshot = await emergencies.where('uid', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        String documentId = docSnapshot.id;

        await emergencies.doc(documentId).update({'status': status});
      }
    }
  }

  void _finalizeSession() async {
    await updateStatus('done');

    CollectionReference acceptances = FirebaseFirestore.instance.collection('acceptances');
    QuerySnapshot querySnapshot = await acceptances.get();

    for (DocumentSnapshot document in querySnapshot.docs) {
      await document.reference.delete();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RatingDentist(uidDentista: widget.uidDentista),
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
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Finalizar Atendimento',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
