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
  // จำนวนน้ำที่ผู้ใช้ต้องได้รับเป็นลิตร
  double myWater = 0;
  // จำนวนน้ำที่กิน ณ ตอนนี้
  double currentWater = 0;

  // แท่งกราฟบนกราฟ
  List<Widget> graps = [];
  // ค่าปริมาณน้ำที่มาจากหลังบ้าน จะมีวันที่ , ปริมาณน้ำ
  List waterHistory = [{'date_BE':'2023-06-01','waters':1.9},{'date_BE':'2023-06-02','waters':1.8},{'date_BE':'2023-06-03','waters':1.8},{'date_BE':'2023-06-05','waters':1.9},{'date_BE':'2023-06-06','waters':2.0}];
  // ค่ากราฟแกน X ค่าปริมาณน้ำหน่วยลิตร
  List<Widget> axisXwater = [];

  void getAxisXvalue(double waters) {
    var d = (waters+1)/6;
    double n = 0;
    for(var i=0;i<6; i++) { 
      n=double.parse((n+d).toStringAsFixed(1));
      axisXwater.insert(0,const SizedBox(height: 8,));
      axisXwater.insert(0,
        Text(n.toString()),
      );
    } 
    axisXwater.insert(0, const Text('ลิตร'));
  }

  void getGraphWater() async {
    myWater = await getMyWater();
    getAxisXvalue(myWater);
    waterHistory.forEach((value){
      graps.add(const SizedBox(height: 10,width: 10,));
      graps.add(
        Stack(
          fit: StackFit.loose,
          children: [ 
            Container(
              width: 20,
              height: (value["waters"]/myWater)*100,
              decoration: const BoxDecoration(color: Colors.blue),
              child: null,
            ),
            Text(value["waters"].toString()),
            
          ],
        ),
      );
      graps.add(Text('${value["date_BE"].split("-")[2]}'),);
    });
  }

  // เรียกจำนวนน้ำที่ผู้ใช้ใส่เข้ามาเป็นลิตรโดยใช้ SharedPreferences
  Future<double> getMyWater() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    setState(() {
      myWater = sharedpreferences.getDouble('userWater')!;
    });
    return myWater;
  }

  @override
  void initState() {
    super.initState();
    getGraphWater();
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
              Container(
                width: 400,
                height: 175,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: axisXwater
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: graps,
                      ),
                    ],
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