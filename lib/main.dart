import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Walidator numeru PESEL'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String sex = "Nieznana";
  String birth = "Nieznana";
  Color birthColor;
  String control = "Nieprawidłowa";
  Color controlColor;


  bool checkControlSum(String pesel){
    var providedSum = int.parse(pesel.substring(10, 11));
    var totalsum = 0;
    var values = [1, 3, 7, 9];
    for(var i = 0; i < 10; i++){
      var num = int.parse(pesel.substring(i, i+1));
      totalsum += (num * values[i%values.length]) % 10;
    }

    return providedSum == (10 - totalsum%10);
  }

  bool checkDay(String date){
    var day = int.parse(date.substring(4, 6));
    var month = int.parse(date.substring(2, 4));
    var year = setYear(date);
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    if(year % 4 == 0) daysInMonth[1]++;

    if(day < 1 || day > daysInMonth[((month % 20) % 13) -1]) {
      return false;
    }

    return true;
  }

  int setYear(String date){
    var month = int.parse(date.substring(2, 4));
    var year = 0;
    if(month > 0 && month < 13) year = 1900;
    else if(month > 20 && month < 33) year = 2000;
    else if(month > 40 && month < 53) year = 2100;
    else if(month > 60 && month < 73) year = 2200;
    else if(month > 80 && month < 93) year = 1800;
    else return -1;

    return year + int.parse(date.substring(0, 2));
  }

  String parseDate(String date){

    var month = int.parse(date.substring(2, 4));
    var year = setYear(date);

    if(year < 0 || !checkDay(date)) {
      birthColor = Colors.red;
      return "Nieprawidłowa";
    }

      birthColor = null;
      month = (month % 20) % 13;

      return date.substring(4, 6) + '.'
          + (month < 10 ? '0' : '') + month.toString() + '.'
          + year.toString();
    }

  void checkPesel(String text){
    if(text.length > 5){
      setState(() {
        birth = parseDate(text);
      });
      if(text.length > 9){
        if(int.parse(text.substring(9,10)) % 2 == 0){
          setState(() {
            sex = "Kobieta";
          });
        }
        else{
          setState(() {
            sex = "Mężczyzna";
          });
        }
      }
      else{
        setState(() {
          sex = "Nieznana";
        });
      }
      if(text.length == 11 && checkControlSum(text)){
        setState(() {
          control = "Prawidłowa";
          controlColor = Colors.green;
        });
      }
      else{
        setState(() {
          control = "Nieprawidłowa";
          controlColor = Colors.red;
        });
      }
    }
    else {
      setState(() {
        birth = "Nieznana";
        sex = "Nieznana";
        control = "Nieprawidłowa";
        birthColor = null;
        controlColor = Colors.red;
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20.0),
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
          TextFormField(
                decoration: InputDecoration(
                    labelText: 'Wprowadź PESEL'
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(11)
                ],
                  onChanged: (text) {
                    checkPesel(text);
                  },
              ),
            SizedBox(height: 100),
            Row(
              children: [
                Text('Data urodzenia: ', style: TextStyle(fontSize: 20)),
                Text(birth, style: TextStyle(color: birthColor, fontSize: 20),)
              ],
            ),
            Text('Płeć: $sex', style: TextStyle(fontSize: 20)),
            Row(
              children: [
                Text('Suma kontrolna: ', style: TextStyle(fontSize: 20)),
                Text(control, style: TextStyle(color: controlColor, fontSize: 20),)
              ],
            ),
          ],
        ),
      )
  );
}
}

