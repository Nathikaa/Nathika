import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class ShowProduct extends StatefulWidget {
  @override
  State<ShowProduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ShowProduct> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  // ฟังชั่น
  Future<void> fetchProducts() async {
    try {
      // ดึงข้อมูลจาก Realtime Database
      final query = dbRef.orderByChild('price').startAt(1);

      final snapshot = await query.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        // วนลูปเพื่อแปลงข้อมูลเป็น Map
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สำหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
          loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));
        });
        // อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });
        print(
            "จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ"); // Debugging
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล"); // กรณีไม่มีข้อมูล
      }
    } catch (e) {
      print("Error loading products: $e"); // แสดงข้อผิดพลาดทาง Console
      // แสดง Snackbar เพื่อแจ้งเตือนผู้ใช้
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }
  // จบฟังชั่น

  @override
  void initState() {
    super.initState();
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

//ฟังก์ชันที่ใช้ลบ
  void deleteProduct(String key, BuildContext context) {
//คําสั่งลบโดยอ้างถึงตัวแปร dbRef ที่เชือมต่อตาราง product ไว้
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
      fetchProducts();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  //ฟังก์ชันถามยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิ ด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
// ปุ่ มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ไม่ลบ'),
            ),
// ปุ่ มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
//ข้อความแจ้งว่าลบเรียบร้อย
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  //ฟังก์ชันแสดง AlertDialog หน้าจอเพื่อแก้ไขข้อมูล
  void showEditProductDialog(Map<String, dynamic> product) {
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController discountController =
        TextEditingController(text: product['discoubt']);
    TextEditingController quantityController =
        TextEditingController(text: product['quantity']?.toString() ?? '');
    TextEditingController productionDateController =
        TextEditingController(text: product['productionDate']);
    TextEditingController priceController =
        TextEditingController(text: product['price']?.toString() ?? '');

    // เพิ่มรายการประเภทสินค้า
    List<String> categories = ['Electronics', 'Clothing', 'Food', 'Books'];
    String selectedCategory = product['category'] ?? categories.first;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (newValue) {
                    selectedCategory = newValue!;
                  },
                  decoration: InputDecoration(labelText: 'ประเภทสินค้า'),
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: discountController,
                  decoration: InputDecoration(labelText: 'ส่วนลด'),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
                TextField(
                  controller: productionDateController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(labelText: 'วันที่ผลิต'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                // เตรียมข้อมูลที่แก้ไขแล้ว
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': double.tryParse(priceController.text) ?? 0.0,
                  'quantity': int.tryParse(quantityController.text) ?? 0,
                  'category': selectedCategory,
                  'productionDate': productionDateController.text,
                  'discoubt': discountController.text,
                };
                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts(); // โหลดข้อมูลใหม่
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });

                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  // ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 52, 38, 176),
        title: Text('แสดงข้อมูลสินค้า'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: products.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // จำนวนคอลัมน์ในกริด
                  crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
                  mainAxisSpacing: 10, // ระยะห่างระหว่างแถว
                  childAspectRatio:
                      0.75, // อัตราส่วนของแต่ละกริด (สามารถปรับได้)
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Color.fromARGB(255, 87, 147,
                        112), // เปลี่ยนพื้นหลังของ Card เป็นสีเขียว
                    child: InkWell(
                      onTap: () {
                        // เมื่อกดที่แต่ละรายการจะเกิดอะไรขึ้น
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // แสดงชื่อสินค้า
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .white, // เปลี่ยนสีตัวอักษรให้เป็นสีขาว
                                ),
                              ),
                            ),
                            // แสดงรายละเอียดสินค้า
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'รายละเอียด: ${product['description']}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            // แสดงวันที่ผลิตสินค้า
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'วันที่ผลิต: ${formatDate(product['productionDate'])}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white70),
                              ),
                            ),
                            // แสดงราคา
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'ราคา: ${product['price']} บาท',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'จำนวน: ${product['quantity']} ชิ้น',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // ใช้ขนาดเล็กที่สุดเท่าที่จำเป็น
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.red[50], // พื้นหลังสีแดงอ่อน
                                        shape: BoxShape.circle, // รูปทรงวงกลม
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          // กดปุ่มลบแล้วจะให้เกิดอะไรขึ้น
                                          showDeleteConfirmationDialog(
                                              product['key'], context);
                                        },
                                        icon: Icon(Icons.delete),
                                        color: Colors.red, // สีของไอคอน
                                        iconSize: 20,
                                        tooltip: 'ลบสินค้า',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 2), // ระยะห่างระหว่างไอคอน
                                  SizedBox(
                                    width: 80,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.red[50], // พื้นหลังสีแดงอ่อน
                                        shape: BoxShape.circle, // รูปทรงวงกลม
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          // กดปุ่มแก้ไขแล้วจะให้เกิดอะไรขึ้น
                                          showEditProductDialog(
                                              product); // เปด Dialog แก้ไขสินคา
                                        },
                                        icon: Icon(Icons.edit),
                                        color: const Color.fromARGB(
                                            255, 79, 192, 113), // สีของไอคอน
                                        iconSize: 20,
                                        tooltip: 'แก้ไขสินค้า',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
