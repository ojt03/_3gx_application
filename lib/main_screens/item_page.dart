import 'package:_3gx_application/backend/get_item_details.dart';
import 'package:_3gx_application/backend/inventory_item.dart'; // Import the file where fetchItems is located
import 'package:_3gx_application/main_screens/item_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class ItemlistPage extends StatefulWidget {
  @override
  _ItemlistPageState createState() => _ItemlistPageState();
}

class _ItemlistPageState extends State<ItemlistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Inventory List Title with Poppins font
                Text(
                  'Inventory List',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Scan Item button with Poppins font
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    fixedSize: Size(200, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    // Your scanner functionality goes here
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    size: 24,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Scan barcode',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            Expanded(
              child: FutureBuilder<List<Item>>(
                future: fetchItems(),
                builder: (context, itemSnapshot) {
                  if (itemSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (itemSnapshot.hasError) {
                    return Center(child: Text('Error: ${itemSnapshot.error}'));
                  } else if (itemSnapshot.hasData) {
                    List<Item> items = itemSnapshot.data!;

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        Item item = items[index];
                        return ListTile(
                          title: Text(
                            item.itemDesc,
                            style: GoogleFonts.poppins(),
                          ),
                          subtitle: Text(
                            'Price: ${item.itemPrice} | Qty: ${item.qty}',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailsPage(item: item),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No items available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
