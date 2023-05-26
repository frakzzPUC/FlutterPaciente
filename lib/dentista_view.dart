import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore.collection('user').get();

    // Use setState para dizer ao Flutter para reconstruir a interface do usuário com os novos dados.
    setState(() {
      _firebaseData = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
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
                                'Nome: ${_firebaseData[index]['name']}', // Aqui estão os nomes dos usuários.
                                style: TextStyle(fontSize: 24.0),
                              ),
                              Text(
                                'Phone: ${_firebaseData[index]['phone']}', // Aqui estão os telefones dos usuários.
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
