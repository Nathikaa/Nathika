import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetail({required this.product});

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบข้อมูลที่ได้รับ
    print("Received product: $product");

    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดสินค้า'),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['name'] ?? 'ไม่มีชื่อสินค้า',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'ราคา: ${product['price']} บาท',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'รายละเอียด: ${product['description'] ?? 'ไม่มีรายละเอียด'}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            // คุณสามารถเพิ่มส่วนของรูปภาพ, รีวิว หรือข้อมูลเพิ่มเติมที่ต้องการได้
             const SizedBox(height: 8.0),
            Text(
              'จำนวน: ${product['quantity']} ชิ้น',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
