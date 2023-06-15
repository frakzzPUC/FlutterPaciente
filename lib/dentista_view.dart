import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_itooth/detail_dentist.dart';

class DentistaView extends StatefulWidget {
  @override
  _DentistaViewState createState() => _DentistaViewState();
}

class _DentistaViewState extends State<DentistaView> {
  List<dynamic> _firebaseData = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getFirebaseData();
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      _getFirebaseData();
    });
  }

  _getFirebaseData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot emergenciesSnapshot = await firestore.collection('emergencies').get();

    // Limpa os dados antigos antes de receber os novos
    _firebaseData.clear();

    for (var emergencyDoc in emergenciesSnapshot.docs) {
      dynamic emergencyData = emergencyDoc.data();
      String? userAccepted = emergencyData['usersaccepted'];

      if (userAccepted != null) {
        DocumentSnapshot userDoc = await firestore.collection('user').doc(userAccepted).get();

        if (userDoc.exists) {
          dynamic userData = userDoc.data();
          setState(() {
            _firebaseData.add(userData);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Detail(
                          userData: _firebaseData[index], uidDentista: '',
                        ),
                      ),
                    );
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
