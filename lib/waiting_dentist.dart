import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_itooth/loc_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class WaitingDentist extends StatefulWidget {
  final String uidDentista;

  WaitingDentist({required this.uidDentista});

  @override
  _WaitingDentistState createState() => _WaitingDentistState();
}

class _WaitingDentistState extends State<WaitingDentist> {
  StreamSubscription<DocumentSnapshot>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribeToUpdates();
  }

  @override
  void dispose() {
    _unsubscribeFromUpdates();
    super.dispose();
  }

  void _subscribeToUpdates() {
    _subscription = FirebaseFirestore.instance
        .collection('acceptances')
        .doc(widget.uidDentista)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('loc')) {
          String loc = data['loc'] as String;
          if (loc.isNotEmpty) {
            List<String> latLng = loc.split(',');
            double latitude = double.parse(latLng[0]);
            double longitude = double.parse(latLng[1]);
            LatLng center = LatLng(latitude, longitude);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocView(center: center),
              ),
            );
          }
        }
      }
    });
  }

  void _unsubscribeFromUpdates() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20.0),
            Text(
              'Aguarde',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Buscando Localização...',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
