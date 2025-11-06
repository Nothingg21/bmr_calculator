import 'package:flutter/material.dart';

void main() => runApp(BMRCalculator());

class BMRCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  bool isMale = true;
  int height = 160; // tinggi awal
  int weight = 60;  // berat awal
  int age = 20;     // umur awal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0A0E21),
      appBar: AppBar(
        backgroundColor: Color(0xff0A0E21),
        elevation: 0,
        title: Text("BMR CALCULATOR"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                genderCard("MALE", Icons.male, true),
                genderCard("FEMALE", Icons.female, false),
              ],
            ),
          ),
          Expanded(
            child: cardContainer(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("HEIGHT", style: TextStyle(color: Colors.white70)),
                  Text("$height cm",
                      style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white)),
                  Slider(
                    activeColor: Colors.pink,
                    value: height.toDouble(),
                    min: 100,
                    max: 220,
                    onChanged: (value) => setState(() => height = value.toInt()),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                valueCard("WEIGHT", weight, () => setState(() => weight--), () => setState(() => weight++)),
                valueCard("AGE", age, () => setState(() => age--), () => setState(() => age++)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Hitung BMR sesuai gender
              double result = isMale
                  ? 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
                  : 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResultPage(bmrResult: result)),
              );
            },
            child: Container(
              height: 70,
              width: double.infinity,
              color: Colors.pink,
              child: Center(child: Text("CALCULATE", style: TextStyle(fontSize: 25, color: Colors.white))),
            ),
          )
        ],
      ),
    );
  }

  // Widget helper untuk card gender
  Expanded genderCard(String text, IconData icon, bool gender) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isMale = gender),
        child: cardContainer(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isMale == gender ? Colors.pink : Colors.white70, size: 80),
              SizedBox(height: 10),
              Text(text, style: TextStyle(color: Colors.white70, fontSize: 18)),
            ],
          ),
          isActive: isMale == gender,
        ),
      ),
    );
  }

  // Card wrapper
  Widget cardContainer(Widget child, {bool isActive = false}) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isActive ? Color(0xff1D1E33) : Color(0xff111328),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  // Card berat & umur
  Expanded valueCard(String label, int value, Function minus, Function plus) {
    return Expanded(
      child: cardContainer(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(color: Colors.white70)),
            Text("$value", style: TextStyle(fontSize: 45, color: Colors.white, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                floatingRoundButton(Icons.remove, minus),
                SizedBox(width: 15),
                floatingRoundButton(Icons.add, plus),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Tombol bulat
  Widget floatingRoundButton(IconData icon, Function onPressed) {
    return InkWell(
      onTap: () => onPressed(),
      child: CircleAvatar(
        backgroundColor: Colors.white12,
        radius: 22,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final double bmrResult;

  ResultPage({required this.bmrResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0A0E21),
      appBar: AppBar(
        backgroundColor: Color(0xff0A0E21),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your BMR", style: TextStyle(fontSize: 30, color: Colors.white)),
            SizedBox(height: 15),
            Text(bmrResult.toStringAsFixed(1),
                style: TextStyle(fontSize: 80, color: Colors.pink, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Text("Calories/day needed at rest",
                style: TextStyle(color: Colors.white70, fontSize: 18)),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              onPressed: () => Navigator.pop(context),
              child: Text("RE-CALCULATE", style: TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}
