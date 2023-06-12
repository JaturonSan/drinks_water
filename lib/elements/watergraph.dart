import 'package:flutter/material.dart';

class WaterGraph extends StatelessWidget {
  double width;
  double height;
  double myWater;
  Color bgColor;
  Color graphColor;
  Color txtColor;
  // ค่าปริมาณน้ำที่มาจากหลังบ้าน จะมีวันที่ , ปริมาณน้ำ
  List waterHistory;

  WaterGraph({
    super.key, 
    this.width = 400,
    this.height = 175,
    required this.myWater,
    required this.bgColor,
    required this.graphColor,
    required this.txtColor,
    required this.waterHistory,
  });
  // แท่งกราฟบนกราฟ
  List<Widget> graps = [];
  // ค่ากราฟแกน X ค่าปริมาณน้ำหน่วยลิตร
  List<Widget> axisXwater = [];

  void getAxisXvalue(double waters) {
    var d = (waters+1)/6;
    double n = 0;
    for(var i=0;i<6; i++) { 
      n=double.parse((n+d).toStringAsFixed(1));
      axisXwater.insert(0,const SizedBox(height: 8,));
      axisXwater.insert(0,
        Text(n.toString(), style: TextStyle(color: txtColor)),
      );
    } 
    axisXwater.insert(0, Text('ลิตร', style: TextStyle(color: txtColor)));
  }

  void getGraphWater() async {
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
              decoration: BoxDecoration(color: graphColor),
              child: null,
            ),
            Text(value["waters"].toString(), style: TextStyle(color: txtColor)),
            
          ],
        ),
      );
      graps.add(Text('${value["date_BE"].split("-")[2]}', style: TextStyle(color: txtColor)),);
    });
  }

  @override
  Widget build(BuildContext context) {
    getGraphWater();
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: bgColor,
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
    );
  }
}