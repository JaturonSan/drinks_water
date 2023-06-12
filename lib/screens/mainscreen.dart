import 'package:drinks_water/elements/watergraph.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SizedBox box = const SizedBox(height: 20,width: 20,);
  OutlineInputBorder border = const OutlineInputBorder();
  Color backgroundColor = Colors.lightBlue;
  // สีของตัวหนังสือในปุ่ม
  Color buttonTextColor = Colors.black;
  // ขนาดตัวหนังสือ
  double textSize = 16.0;
  // จำนวนน้ำที่กิน ณ ตอนนี้
  double currentWater = 0;
  // จำนวนน้ำที่ผู้ใช้ต้องได้รับเป็นลิตร
  double myWater = 0;

  // เรียกจำนวนน้ำที่ผู้ใช้ใส่เข้ามาเป็นลิตรโดยใช้ SharedPreferences
  void getMyWater() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    setState(() {
      myWater = sharedpreferences.getDouble('userWater')!;
    });
  }

  @override
  void initState() {
    super.initState();
    getMyWater();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              box,
              box,
              Text('$currentWater ของ $myWater ลิตร'),
              Image.asset('assets/human-body.png'),
              box,
              WaterGraph(
                myWater: myWater,
                bgColor: Colors.green,
                graphColor: Colors.purple,
                txtColor: Colors.yellow,
                waterHistory: const [{'date_BE':'2023-06-01','waters':1.9},{'date_BE':'2023-06-02','waters':1.8},{'date_BE':'2023-06-03','waters':1.8},{'date_BE':'2023-06-05','waters':1.9},{'date_BE':'2023-06-06','waters':2.0}],
              ),
            ],
          ),
        ),
      ),
    );
  }
}