import 'package:drinks_water/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddWaterScreen extends StatefulWidget {
  const AddWaterScreen({super.key});

  @override
  State<AddWaterScreen> createState() => _AddWaterScreenState();
}

class _AddWaterScreenState extends State<AddWaterScreen> {
  final formKey = GlobalKey<FormState>();
  // จำนวนลิตรของน้ำที่ต้องการกิน
  final waterAmountController = TextEditingController();
  SizedBox box = const SizedBox(height: 20,);
  OutlineInputBorder border = const OutlineInputBorder();
  // FormFild text size
  double formfildTextSize = 15.0;
  // FormFild text color
  Color? formfildTextColor = Colors.grey[700];
  Color backgroundColor = Colors.lightBlue;
  // สีของตัวหนังสือในปุ่ม
  Color buttonTextColor = Colors.black;
  // ขนาดตัวหนังสือ
  double textSize = 16.0;

  void setWater(double water) async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    sharedpreferences.setDouble('userWater', water);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                box,
                box,
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: waterAmountController,
                  validator: RequiredValidator(errorText: 'กรุณาใส่จำนวนน้ำที่ต้องการดื่ม'),
                  decoration: InputDecoration(
                    border: border,
                    labelText: 'ดื่มน้ำกี่ลิตรต่อวัน',
                    labelStyle: TextStyle(fontSize: formfildTextSize, color: formfildTextColor,),
                  ),
                ),
                box,
                SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
                    onPressed: () async {
                      if(formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        // เรียกค่าที่ใส่ใน textformfield มาทำงาน
                        var water = double.parse(waterAmountController.text);

                        // แจ้งเตือนผู้ใช้ว่าจะลบข้อมูลอาหารหรือไม่
                        // ignore: use_build_context_synchronously
                        await showDialog<String>(
                          context: context,
                          // ป้องกันผู้ใช้กดออกจากหน้าโหลดโดยคลิ้กข้างๆ showdialog
                          barrierDismissible: false,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('ต้องการเพิ่มการดื่มน้ำหรือไม่'),
                            content: const Text("ถ้าดำเนินการต่อไปจะเป็นการเพิ่มการดื่มน้ำ"),
                            actions: <Widget>[
                              IconButton(
                                onPressed: () {
                                  setWater(water);
                                  Fluttertoast.showToast(
                                    msg: "การดื่มน้ำเป็น $water ลิตร",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                  ); 
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                    builder: (context) {
                                        return const MainScreen();
                                      },
                                    )
                                  );
                                },
                                icon: const Icon(Icons.check),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context, 'ยกเลิก'),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text('เพิ่มน้ำ', style: TextStyle(fontSize: textSize, color: buttonTextColor,),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}