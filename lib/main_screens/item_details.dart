import 'package:_3gx_application/backend/fetch_inventory_count.dart';
import 'package:_3gx_application/backend/get_item_details.dart';
import 'package:_3gx_application/backend/insert_inventory_count.dart';
import 'package:flutter/material.dart';
import 'package:_3gx_application/backend/inventory_item.dart';
import 'package:_3gx_application/backend/get_branches.dart';

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
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Branch Dropdown & SKU
            _buildBranchAndSKU(),

            SizedBox(height: 24),
            Divider(color: Colors.grey[400]),

            // Item Description & Price
            Text("Item Description",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black87)),
            Text(widget.item.itemDesc,
                style: TextStyle(fontSize: 18, color: Colors.black87)),

            SizedBox(height: 8),
            Text("Price",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black87)),
            Text("${widget.item.itemPrice}",
                style: TextStyle(fontSize: 16, color: Colors.black87)),

            SizedBox(height: 16),

            // Counts Section
            _buildCountSection(),

            SizedBox(height: 16),

            // User Count Input
            Text("Your Count",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black87)),
            SizedBox(
              width: 200, // Adjusted width for the TextField
              child: TextField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: 'Enter item count',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Add Button - This calls _buildAddButton() in the UI
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  // Branch dropdown and SKU input display
  Widget _buildBranchAndSKU() {
  return Row(
    children: [
      // Branch Dropdown
      Container(
        width: 300, // Smaller width for the branch dropdown
        child: FutureBuilder<List<Map<String, String>>>(
          future: fetchBranchNames(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error loading branches', style: TextStyle(color: Colors.red));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              // Ensure selectedBranch is valid (branch name and branch code)
              if (selectedBranch == null || !snapshot.data!.any((branch) => branch['BranchName'] == selectedBranch)) {
                selectedBranch = null;
              }

              return DropdownButtonFormField<Map<String, String>>(
                value: selectedBranch != null 
                    ? snapshot.data!.firstWhere((branch) => branch['BranchName'] == selectedBranch) 
                    : null,
                hint: Text('Select Branch'),
                items: snapshot.data!.map((branch) {
                  return DropdownMenuItem<Map<String, String>>(
                    value: branch,
                    child: Text('${branch['BranchName']} - ${branch['BranchCode']}', style: TextStyle(color: Colors.black87)),
                  );
                }).toList(),
                onChanged: (Map<String, String>? value) {
                  setState(() {
                    selectedBranch = value?['BranchName'];  // Store only branch name
                    selectedBranchCode = value?['BranchCode'];
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              );
            } else {
              return Text('No branches available');
            }
          },
        ),
      ),

      SizedBox(width: 16),

      // SKU/Item No.
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("SKU/Item No.", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
            Text(widget.item.itemNo, style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    ],
  );
}

  // Count Section: DB Count and Current Count
  Widget _buildCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDBCount(),
        SizedBox(height: 16),
        _buildCurrentCount(),
      ],
    );
  }

  // Display DB Count
  Widget _buildDBCount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("DB Count", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        SizedBox(
          width: 200, // Adjusted width for the container
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(widget.item.qty.toString(),
                style: TextStyle(fontSize: 16, color: Colors.black87)),
          ),
        ),
      ],
    );
  }

  // Display Current Count
  Widget _buildCurrentCount() {
    return FutureBuilder<int>(
      future: fetchBranchCount(widget.item.itemNo, selectedBranchCode ?? ''), // Fetch count from API
      builder: (context, snapshot) {
        String displayText;

        if (snapshot.connectionState == ConnectionState.waiting) {
          displayText = "Loading..."; // Show loading state
        } else if (snapshot.hasError) {
          displayText = "Error"; // Show error state
        } else {
          displayText = snapshot.data?.toString() ?? "0"; // Show fetched count, default to 0
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Count", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
            SizedBox(
              width: 200, // Adjusted width for the container
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  displayText,
                  style: TextStyle(
                    fontSize: 16,
                    color: snapshot.hasError ? Colors.red : Colors.black87, // Show error in red
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Add Button
  Widget _buildAddButton() {
    return SizedBox(
      height: 45,
      width: 200, // Adjusted to a smaller, more compact width
      child: ElevatedButton(
        onPressed: () async {
          if (selectedBranch != null && countController.text.isNotEmpty) {
            // Extract the values from the fields
            String itemNo = widget.item.itemNo; // Ensure this matches the field
            String braNo = selectedBranch!; // Branch name
            double count = double.tryParse(countController.text) ?? 0.0; // Ensure count is a double
            String user = 'current_user'; // You can replace this with the actual user if you have it

            // Call the function to add the inventory count
            await addInventoryCount(itemNo, braNo, count, user);
          } else {
            // Show a message if the required fields are empty
            print('Please select a branch and enter a count');
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text('Add',
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
