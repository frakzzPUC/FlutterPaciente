import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:convert'; // Importante para o jsonDecode.
import 'package:flutter_itooth/loc_view.dart'; // Importe sua tela loc_view.dart

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
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LocView()),
                      );
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
