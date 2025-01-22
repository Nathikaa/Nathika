import 'package:flutter/material.dart';
import 'showproducttype.dart';

class ShowProductType extends StatefulWidget {
  @override
  _ShowProductTypeState createState() => _ShowProductTypeState();
}

class _ShowProductTypeState extends State<ShowProductType> {
  List<String> categories = [
    'Electronics',
    'Clothing',
    'Food',
    'Books'
  ]; // List of categories

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 188, 50, 50),
        title: Text('ประเภทสินค้า'),
      ),
      body: Container(
        width: double.infinity, // Ensures the container takes up the full width
        height: MediaQuery.of(context).size.height, // Full height of the screen
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'), // Background image
            fit: BoxFit.cover, // Make the image cover the entire screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Color.fromARGB(255, 87, 147, 112),
                ),
                onPressed: () {
                  // Navigate to ShowProductFormType page and pass the selected category
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          showproductype(category: categories[index]),
                    ),
                  );
                },
                child: Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Ensure text is visible on the button
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
