import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_itooth/waiting_dentist.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Detail extends StatelessWidget {
  final dynamic userData;
  final String uidDentista;

  Detail({required this.userData, required this.uidDentista});

  Future<void> acceptDentist(BuildContext context) async {
    try {
      String uidDentista = '';
      String myUid = '';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('emergencies').get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = querySnapshot.docs.first;
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          uidDentista = data['usersaccepted'];
          myUid = data['uid'];
        }
      }

      if (uidDentista.isNotEmpty && myUid.isNotEmpty) {
        Map<String, dynamic> acceptanceData = {
          'uid_dentista': uidDentista,
          'uid_usuario': myUid,
          'loc': '',
        };

        CollectionReference acceptances = FirebaseFirestore.instance.collection('acceptances');
        await acceptances.doc(uidDentista).set(acceptanceData);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingDentist(uidDentista: uidDentista),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text('Falha ao obter os dados do dentista.'),
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
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Ocorreu um erro ao processar sua solicitação.'),
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
  Future<String> getDentistPhotoUrl() async {
    final ref = FirebaseStorage.instance.ref().child('dentista/$uidDentista');
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    String name = userData['name'] ?? 'Nome desconhecido';
    String phone = userData['phone'] ?? 'Telefone desconhecido';
    String addressOne = userData['addressone'] ?? 'Endereço desconhecido';
    String addressTwo = userData['addresstwo'] ?? 'Endereço 2 desconhecido';
    String addressThree = userData['addressthree'] ?? 'Endereço 3 desconhecido';
    String resume = userData['resume'] ?? '';

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<String>(
                future: getDentistPhotoUrl(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // or some other placeholder
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data ?? ''),
                      radius: 80.0,
                    );
                  }
                },
              ),
              SizedBox(height: 20.0),
              Text(
                name,
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Text(
                phone,
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Text(
                addressOne.replaceAll(':', ': '),
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Text(
                addressTwo.replaceAll(':', ': '),
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Text(
                addressThree.replaceAll(':', ': '),
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Text(
                'Currículo:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Text(
                resume,
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    acceptDentist(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF389BA6)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'ESCOLHER',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}