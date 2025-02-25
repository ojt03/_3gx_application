import 'package:flutter/material.dart';
import 'package:_3gx_application/backend/get_item_details.dart';
import 'package:_3gx_application/backend/inventory_item.dart';
import 'package:_3gx_application/backend/get_branches.dart';
import 'package:_3gx_application/backend/fetch_inventory_count.dart';
import 'package:_3gx_application/backend/insert_inventory_count.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemDetailsPage extends StatefulWidget {
  final Item item;

  ItemDetailsPage({required this.item});

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  String? selectedBranch;
  String? selectedBranchCode;
  TextEditingController countController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
       
        child: Column(
          children: [
            
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              width: double.infinity,
              height: 200, // Fixed height
              child: Stack(
                children: [
                  // Back button at the top-left
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  // Item description aligned at the bottom-left with margin
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, bottom: 20.0), // Add margin
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Item Description:",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            widget.item.itemDesc,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
               
                children: [
                  SizedBox(height: 20),

                  _buildBranchDropdown(),

                  SizedBox(height: 20),

                  // SKU and Price
                  _buildItemDetails(),

                  Divider(color: Colors.black),

                  SizedBox(height: 20),

                  // Count Section
                  Row(
                    children: [
                      Expanded(
                          child: _buildCountBox(
                              "DB Count", widget.item.qty.toString())),
                      SizedBox(width: 16),
                      Expanded(child: _buildCurrentCount()),
                    ],
                  ),

                  SizedBox(height: 20),

                  // User Count Input
                  

                  SizedBox(height: 8),
                  _buildCountInput(),

                  SizedBox(height: 16),

                  // Add Button
                  _buildAddButton(),

                  SizedBox(height: 20), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// widget designs 

//dropdown
Widget _buildBranchDropdown() {
  return FutureBuilder<List<Map<String, String>>>(
    future: fetchBranchNames(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text(
          'Error loading branches',
          style: TextStyle(color: Colors.red),
        );
      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        if (selectedBranch == null ||
            !snapshot.data!.any((branch) => branch['BranchName'] == selectedBranch)) {
          selectedBranch = null;
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth > 600 ? 600 : constraints.maxWidth;

            return Center(
              child: Container(
                width: maxWidth,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Map<String, String>>(
                    value: selectedBranch != null
                        ? snapshot.data!.firstWhere(
                            (branch) => branch['BranchName'] == selectedBranch)
                        : null,
                    hint: Text('Select Branch'),
                    isExpanded: true,
                    items: snapshot.data!.map((branch) {
                      return DropdownMenuItem<Map<String, String>>(
                        value: branch,
                        child: Text('${branch['BranchName']}'),
                      );
                    }).toList(),
                    onChanged: (Map<String, String>? value) {
                      setState(() {
                        selectedBranch = value?['BranchName'];
                        selectedBranchCode = value?['BranchCode'];
                      });
                    },
                  ),
                ),
              ),
            );
          },
        );
      } else {
        return Text('No branches available');
      }
    },
  );
}


//item details
  Widget _buildItemDetails() {
  return LayoutBuilder(
    builder: (context, constraints) {
      double maxWidth = constraints.maxWidth > 500 ? 500 : constraints.maxWidth;

      return Center(
        child: Container(
          width: maxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SKU/Item No.",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.item.itemNo,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Price",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "\$${widget.item.itemPrice}",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


//countbox design
  Widget _buildCountBox(String label, String value) {
  return Column(
    
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    ],
  );
}


//current count
  Widget _buildCurrentCount() {
    return FutureBuilder<int>(
      future: fetchBranchCount(widget.item.itemNo, selectedBranchCode ?? ''),
      builder: (context, snapshot) {
        String displayText = snapshot.connectionState == ConnectionState.waiting
            ? "..."
            : snapshot.hasError
                ? "Error"
                : snapshot.data?.toString() ?? "0";

        return _buildCountBox("Current Count", displayText);
      },
    );
  }

//user count
Widget _buildCountInput() {
  return LayoutBuilder(
    builder: (context, constraints) {
      double maxWidth = constraints.maxWidth > 500 ? 500 : constraints.maxWidth;

      return Center(
        child: Container(
          width: maxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your count',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  hintText: 'Enter item count',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(190, 255, 217, 0),
                      width: 2,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.inventory,
                    color: const Color.fromARGB(255, 179, 179, 179),
                  ),
                ),
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      );
    },
  );
}


//add button
 Widget _buildAddButton() {
  return LayoutBuilder(
    builder: (context, constraints) {
      double maxWidth = constraints.maxWidth > 500 ? 500 : constraints.maxWidth;

      return Center(
        child: SizedBox(
          width: maxWidth,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              if (selectedBranch != null && countController.text.isNotEmpty) {
                String itemNo = widget.item.itemNo;
                String braNo = selectedBranch!;
                double count = double.tryParse(countController.text) ?? 0.0;
                String user = 'current_user';

                await addInventoryCount(itemNo, braNo, count, user);
              } else {
                print('Please select a branch and enter a count');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Text(
              'ADD',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    },
  );
}

}
