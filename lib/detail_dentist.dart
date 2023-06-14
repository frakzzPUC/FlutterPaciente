import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_itooth/loc_view.dart';
class Detail extends StatelessWidget {
  final dynamic userData;

  Detail({required this.userData});

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
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/default_user.png'),
                radius: 80.0,
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
                    LatLng center = LatLng(0.0, 0.0); // Substitua pelas coordenadas LatLng desejadas
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocView(center: center),
                      ),
                    );
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
