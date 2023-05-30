import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:convert'; // Importante para o jsonDecode.

class DentistaView extends StatefulWidget {
  @override
  _DentistaViewState createState() => _DentistaViewState();
}

class _DentistaViewState extends State<DentistaView> {
  // Variável para guardar os dados do Firebase.
  List<dynamic> _firebaseData = [];

  @override
  void initState() {
    super.initState();

    // Buscar os dados do Firebase.
    _getFirebaseData();
  }

  // Função para buscar os dados do Firebase.
  _getFirebaseData() async {
    // Vamos chamar a função getEmergencyAcceptedUsers ao invés de buscar diretamente do Firestore.
    HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'southamerica-east1').httpsCallable('getEmergencyAcceptedUsers');
    try {
      final results = await callable();
      print('Dados recebidos do Firebase: ${results.data}');
      // Parse the JSON string into a dynamic object.
      dynamic response = jsonDecode(results.data);

      // Check the 'status' field to make sure the request was successful.
      if (response['status'] == 'SUCCESS') {
        // Decode the 'payload' field, which is already a list.
        List<dynamic> users = response['payload'];

        // Use setState to tell Flutter to rebuild the UI with the new data.
        setState(() {
          _firebaseData = users;
        });
      } else {
        // Handle the error.
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
            'assets/images/itooth.png', // Caminho para a imagem da logo do seu app
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.2,
            alignment: Alignment.center,
          ),
          Expanded(
            child: _firebaseData.isNotEmpty ?
            ListView.builder(
              itemCount: _firebaseData.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.all(10.0), // Espaçamento de um usuário para o outro.
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        // Aqui está a imagem do usuário.
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/images/default_user.png'), // Aqui é onde você colocaria o URL da foto do usuário.
                          radius: 30.0,
                        ),
                        SizedBox(width: 10.0), // Espaço entre a imagem e as informações do usuário.
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nome: ${_firebaseData[index]['name'] ?? 'Nome desconhecido'}', // Aqui estão os nomes dos usuários.
                                style: TextStyle(fontSize: 24.0),
                              ),
                              Text(
                                'Telefone: ${_firebaseData[index]['phone'] ?? 'Telefone desconhecido'}', // Aqui estão os telefones dos usuários.
                                style: TextStyle(fontSize: 24.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ) :
            Center(
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
