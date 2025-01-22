import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'shoeproctdetail.dart';

class showproductype extends StatefulWidget {
  final String category;

  showproductype({required this.category});

  @override
  State<showproductype> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<showproductype> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProductsByCategory() async {
    try {
      final query = dbRef.orderByChild('category').equalTo(widget.category);
      final snapshot = await query.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] = child.key;
          loadedProducts.add(product);
        });

        setState(() {
          products = loadedProducts;
        });

        print(
            "สินค้าในหมวดหมู่ '${widget.category}': ${products.length} รายการ");
      } else {
        print("ไม่มีสินค้าในหมวดหมู่ '${widget.category}'");
      }
    } catch (e) {
      print("Error loading products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สินค้าในหมวดหมู่: ${widget.category}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0077FF),
      ),
      body: products.isEmpty
          ? Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetail(product: product),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? 'ไม่มีชื่อสินค้า',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          Text('ราคา: ${product['price']} บาท'),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Text('จำนวน:'),
                              const SizedBox(width: 8.0),
                              Text(
                                  '${product['quantity'] ?? 1} ชิ้น'), // แสดงจำนวนสินค้า
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
