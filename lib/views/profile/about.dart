import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';

class AboutScreen extends StatefulWidget {
  static const routeName = '/profile-about';

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffafafa),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24)),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Despre Aplicație',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Această aplicație vă permite să descoperiți locurile minunate din Republica Moldova. Indiferent dacă sunteți localnic sau vizitator, veți găsi informații utile despre atracțiile turistice, monumente istorice, gastronomie și multe altele.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Descoperiți frumusețea și bogăția culturală a Republicii Moldova alături de noi!',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 50),
            Center(
                child: Image.asset(
              'assets/3787309.png', // Replace with your image asset path
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
              fit: BoxFit.cover, // Adjust the fit as needed
            )),
            // const TopScreenImage(screenImageName: '3787309.png'),
          ],
        ),
      ),
    );
  }
}
