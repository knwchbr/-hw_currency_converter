import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:hw_exchange/service/api_client.dart';

import 'package:hw_exchange/widgets/drop_down.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interest Calculator',
      theme:
          ThemeData(primarySwatch: Colors.teal, accentColor: Colors.tealAccent),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiClient client = ApiClient();

  Color mainColor = Color(0x665ac18e);
  Color secondColor = Color(0x995ac18e);
  
  List<String> ?currencies=[];
  String ?from;
  String ?to;
  double ?rate;
  double ?result;

  //Future<List<String>> getCurrencyList() async{
   // return await client.getCurrencies();
 // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    (() async {
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200.0,
                child: Text(
                  'Currency Converter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        onSubmitted: (value) async {
                          rate = await client.getRate(from!, to!);
                          setState(() {
                            result = 
                            (rate! * double.parse(value));
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Input value",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: secondColor,
                          )),
                        ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customDropdown(currencies!, from, (val) {
                            setState(() {
                              from = val;
                            });
                          }),
                          FloatingActionButton(onPressed: (){
                            String ?temp = from;
                            setState(() {
                              from = to;
                              to = temp;
                            });                          
                            },child: Icon(Icons.swap_horiz),
                          elevation: 0.0,
                          backgroundColor: secondColor,
                          ),
                          customDropdown(currencies!, to, (val) {
                            setState(() {
                              to = val;
                            });
                          }),
                        ],
                      ),
                      SizedBox(height: 50),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text("Result",style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),),
                            Text(result.toString(), style: TextStyle(
                              color: secondColor,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),),
                          ],
                        ),

                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      
    );
  }

}


