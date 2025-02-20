import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemScreenPage extends StatefulWidget {
  const ItemScreenPage({super.key});

  @override
  _ItemScreenPageState createState() => _ItemScreenPageState();
}

class _ItemScreenPageState extends State<ItemScreenPage> {
  String? selectedLocation;
  final TextEditingController _skuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Branch Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Branch",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: DropdownButtonFormField<String>(
                        value: selectedLocation,
                        items: ["Naga", "Tabaco", "Legazpi", "Sorsogon"]
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: GoogleFonts.poppins(),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16),

                // SKU/Item No. input
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SKU/Item No.",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _skuController,
                          decoration: InputDecoration(
                            hintText: "Enter Item No.",
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),

                // GET Button
                Column(
                  children: [
                    SizedBox(height: 25),
                    SizedBox(
                      height: 50,
                      width: 225,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          "GET",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Bottom Line
            SizedBox(height: 25),
            Divider(thickness: 1, color: Colors.black),
            SizedBox(height: 25),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/image.png',
                    fit: BoxFit.cover,
                  ),
                ),
                 SizedBox(width: 16),

                 //information
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item Description
                      Text(
                        "Item Description",
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: 700, 
                        child: Text(
                          "Asus TUF Gaming F15 2022 FX507ZC4-HN081W | 15.6\" FHD | i5-12500H | GeForce RTX 3050 | 8GB RAM | 512GB SSD | WIN 11",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign
                              .justify, 
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(height: 16),

                      // Counts Section
                      buildCountDisplay("Database Count", "10"),
                      SizedBox(height: 16),
                      buildCountDisplay("Current Count", "8"),
                      SizedBox(height: 16),
                      _buildCountBox("Your count", isEditable: true),
                      SizedBox(height: 16),

                      // Add Button
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Add",
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                SizedBox(width: 16), // Adjust if needed
                
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCountDisplay(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
        SizedBox(height: 4),
        Container(
          width: 200,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            value,
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCountBox(String label, {bool isEditable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
        SizedBox(height: 4),
        SizedBox(
          width: 200,
          height: 40,
          child: TextField(
            enabled: isEditable,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              border: OutlineInputBorder(),
            ),
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
// Container(
//                   width: 250,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Image.asset(
//                     'assets/image.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
