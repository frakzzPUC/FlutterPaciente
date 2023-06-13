import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocView extends StatefulWidget {
  final LatLng center;

  LocView({required this.center});

  @override
  _LocViewState createState() => _LocViewState();
}

class _LocViewState extends State<LocView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LocView"),
      ),
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
              onPressed: () {
                // Adicione o que deve acontecer quando o botão for pressionado
              },
              child: Text('Finalizar Atendimento'),
            ),
          ),
        ],
      ),
    );
  }
}
