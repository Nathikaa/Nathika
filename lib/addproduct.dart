import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'ShowProduct.dart';

//Method หลักทีRun
void main() {
  runApp(MyApp());
}

//Class stateless สังแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 41, 174, 52)),
        useMaterial3: true,
      ),
      home: addproduct(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class addproduct extends StatefulWidget {
  @override
  State<addproduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<addproduct> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final categories = ['Electronics', 'Clothing', 'Food', 'Books'];
  int _selectedRadio = 0; //กำหนดค่าเริ่มต้นการเลือก
  String _selectedOption = ''; //กำหนดค่าเริ่มต้นข้อความที่เลือก
  Map<int, String> radioOptions = {
    1: 'ให้ส่วนลด',
    2: 'ไม่ให้ส่วนลด',
  };
  String? selectedCategory;
  DateTime? productionDate;
  Future<void> pickProductionDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: productionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != productionDate) {
      setState(() {
        productionDate = pickedDate;
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> saveProductToDatabase() async {
    try {
// สร้าง reference ไปยัง Firebase Realtime Database
      DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
//ข้อมูลสินค้าที่จะจัดเก็บในรูปแบบ Map
      //ชื่อตัวแปรที่รับค่าที่ผู้ใช้ป้อนจากฟอร์มต้องตรงกับชื่อตัวแปรที่ตั้งตอนสร้างฟอร์มเพื่อรับค่า
      Map<String, dynamic> productData = {
        'name': nameController.text,
        'description': desController.text,
        'category': selectedCategory,
        'productionDate': productionDate?.toIso8601String(),
        'price': double.parse(priceController.text),
        'quantity': int.parse(quantityController.text),
        'discoubt': _selectedOption,
      };
//ใช้คําสั่ง push() เพื่อสร้าง key อัตโนมัติสําหรับสินค้าใหม่
      await dbRef.push().set(productData);
//แจ้งเตือนเมื่อบันทึกสําเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลสําเร็จ')),
      );
      // นําทางไปยังหน้า ShowProduct
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowProduct()),
      );
// รีเซ็ตฟอร์ม
      _formKey.currentState?.reset();
      nameController.clear();
      desController.clear();
      priceController.clear();
      quantityController.clear();
      dateController.clear();
      setState(() {
        selectedCategory = null;
        productionDate = null;
      });
    } catch (e) {
//แจ้งเตือนเมื่อเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'บันทึกสินค้า',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
//ส่วนการออกแบบหน้าจอ
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: 'ชื่อสินค้า*',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: desController,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      labelText: 'รายละเอียดสินค้า*',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรายละเอียดสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                      labelText: 'ประเภทสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  items: categories
                      .map((category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกประเภทสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'วันที่ผลิตสินค้า',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => pickProductionDate(context),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกวันที่ผลิต';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                      labelText: 'ราคาสินค้า*',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกราคาสินค้า';
                    }
                    if (int.tryParse(value) == null) {
                      return 'กรุณากรอกจำนวนสินค้าเป็นตัวเลข';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                      labelText: 'จำนวนสินค้า*',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกจำนวนสินค้า';
                    }
                    if (int.tryParse(value) == null) {
                      return 'กรุณากรอกจำนวนสินค้าเป็นตัวเลข';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: radioOptions.entries.map((entry) {
                    return RadioListTile<int>(
                      title: Text(entry.value),
                      value: entry.key,
                      groupValue: _selectedRadio,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedRadio = value!;
                          _selectedOption = radioOptions[_selectedRadio]!;
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      saveProductToDatabase();
                    }
                  },
                  child: Text('บันทึกสินค้า'),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.reset();
                      nameController.clear();
                      desController.clear();
                      priceController.clear();
                      quantityController.clear();
                      dateController.clear();
                      selectedCategory = null;
                      ();
                    }
                  },
                  child: Text('เคลียร์ข้อมูล'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
