import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_itooth/loc_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DentistaView extends StatefulWidget {
  @override
  _DentistaViewState createState() => _DentistaViewState();
}

class _DentistaViewState extends State<DentistaView> {
  List<dynamic> _firebaseData = [];

  @override
  void initState() {
    super.initState();
    _getFirebaseData();
  }

  _getFirebaseData() async {
    HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'southamerica-east1').httpsCallable('getEmergencyAcceptedUsers');
    try {
      final results = await callable();
      dynamic response = jsonDecode(results.data);
      if (response['status'] == 'SUCCESS') {
        List<dynamic> users = response['payload'];
        setState(() {
          _firebaseData = users;
        });
      } else {
        print('Error getting data: ${response['message']}');
      }
    } catch (e) {
      print('Error getting data from Firebase: $e');
    }
  }

  Future<LatLng> _getLatLngFromAddress(String address) async {
    String url = "https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=AIzaSyBHlil8AXJQ4viK9A1y8pam7LUVfYorroM";
    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> responseJson = jsonDecode(response.body);

    if (responseJson['status'] == 'OK') {
      double lat = responseJson['results'][0]['geometry']['location']['lat'];
      double lng = responseJson['results'][0]['geometry']['location']['lng'];
      return LatLng(lat, lng);
    } else {
      throw Exception('Failed to get LatLng from address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            'assets/images/itooth.png',
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.2,
            alignment: Alignment.center,
          ),
          Expanded(
            child: _firebaseData.isNotEmpty
                ? ListView.builder(
              itemCount: _firebaseData.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    bool confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirmação'),
                        content: Text('Deseja obter a localização deste dentista?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('NÃO'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text('SIM'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      try {
                        LatLng dentistLocation = await _getLatLngFromAddress(_firebaseData[index]['addressone']);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LocView(
                              center: dentistLocation,
                            ),
                          ),
                        );
                      } catch (e) {
                        print('Error getting LatLng from address: $e');
                      }
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/default_user.png'),
                            radius: 30.0,
                          ),
                          SizedBox(width: 10.0),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nome: ${_firebaseData[index]['name'] ?? 'Nome desconhecido'}',
                                  style: TextStyle(fontSize: 24.0),
                                ),
                                Text(
                                  'Telefone: ${_firebaseData[index]['phone'] ?? 'Telefone desconhecido'}',
                                  style: TextStyle(fontSize: 24.0),
                                ),
                                Text(
                                  'Endereço: ${_firebaseData[index]['addressone'] ?? 'Endereço desconhecido'}',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
                : Center(
              child: Text(
                'Aguarde...',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
