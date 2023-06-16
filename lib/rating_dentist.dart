import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingDentist extends StatefulWidget {
  final String uidDentista;

  RatingDentist({required this.uidDentista});

  @override
  _RatingDentistState createState() => _RatingDentistState();
}

class _RatingDentistState extends State<RatingDentist> {
  double _rating = 0.0;
  String _comment = '';
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot emergencySnapshot = await FirebaseFirestore.instance
          .collection('emergencies')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (emergencySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userSnapshot = emergencySnapshot.docs.first;
        setState(() {
          _userName = userSnapshot.get('name');
        });
      }
    }
  }

  void _sendRating() async {
    CollectionReference ratingCollection = FirebaseFirestore.instance.collection('ratings');

    await ratingCollection.add({
      'uid_dentista': widget.uidDentista,
      'rate': _rating,
      'comment': _comment,
      'time':DateTime.timestamp(),
      'name': _userName,
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Avaliação Enviada'),
          content: Text('Obrigado por avaliar o dentista.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }


  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 1; i <= 5; i++)
          IconButton(
            icon: Icon(
              i <= _rating.floor() ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
            onPressed: () {
              setState(() {
                _rating = i.toDouble();
              });
            },
          ),
      ],
    );
  }

  Widget _buildCommentField() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _comment = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Digite um comentário (opcional)',
          border: InputBorder.none,
        ),
        maxLines: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF389BA6),
                Color(0xFF6CCECB),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/itooth.png',
                width: 130,
                height: 130,
              ),
              SizedBox(height: 16.0),
              Text(
                'Avalie o dentista',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              _buildRatingStars(),
              SizedBox(height: 16.0),
              _buildCommentField(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _sendRating,
                child: Text('Enviar Avaliação'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF389BA6),
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  textStyle: TextStyle(
                    fontSize: 18.0,
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
