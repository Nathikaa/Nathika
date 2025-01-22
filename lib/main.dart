import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:onlineddb_nathika/ShowProduct.dart';
import 'package:onlineddb_nathika/showfiltertype.dart';
import 'addproduct.dart';


// Method หลักทีRun
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyA9Ta9HdvxB6zr3QpOHROBEuKR8jdBeQBo",
            authDomain: "studentevents-3533e.firebaseapp.com",
            databaseURL:
                "https://studentevents-3533e-default-rtdb.firebaseio.com",
            projectId: "studentevents-3533e",
            storageBucket: "studentevents-3533e.firebasestorage.app",
            messagingSenderId: "857422157807",
            appId: "1:857422157807:web:d06de58e642e6fd8a8081a",
            measurementId: "G-B9B4RGRKM4"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

// Class stateless สั่ง Run
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

// Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ตั้งค่าภาพพื้นหลัง
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'), // ภาพพื้นหลัง
            fit: BoxFit.cover, // ให้ภาพครอบคลุมพื้นที่ทั้งหมด
          ),
        ),
        child: Center(
          // ใช้ Center เพื่อจัดให้อยู่ตรงกลาง
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // ทำให้ Column อยู่ตรงกลางในแนวแกนหลัก
            children: [
              // โลโก้บริษัท
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  'assets/logo.png', // โลโก้
                  height: 100, // ขนาดโลโก้
                  width: 100,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'โปรดเลือกเมนูที่ท่านต้องการ',
                style: TextStyle(
                  color: Colors.white, // กำหนดสีเป็นสีขาว
                  fontSize: 20, // กำหนดขนาดตัวอักษรเป็น 20
                  fontWeight: FontWeight.bold, // กำหนดความหนาของตัวอักษร
                  fontStyle: FontStyle.italic, // กำหนดให้ตัวอักษรเป็นตัวเอียง
                ),
              ),
              // ปุ่มบันทึกสินค้า
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => addproduct(),
                    ),
                  );
                },
                child: Text('บันทึกสินค้า'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 39, 185, 71),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  elevation: 1,
                ),
              ),
              SizedBox(height: 20),
              // ปุ่มแสดงข้อมูลสินค้า
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowProduct(), // เรียกหน้า GridView
                    ),
                  );
                },
                child: Text('แสดงข้อมูลสินค้า'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 39, 123, 185),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 1,
                ),
              ),
              SizedBox(height: 20),
              // ปุ่มประเภทสินค้า
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ShowProductType(), // เรียกหน้าแสดงประเภทสินค้า
                    ),
                  );
                },
                child: Text('ประเภทสินค้า'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 181, 57, 57),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
