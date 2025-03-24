import 'package:_3gx_application/backend/get_item_details.dart';
import 'package:flutter/material.dart';
import 'package:_3gx_application/backend/get_branches.dart';
import 'package:_3gx_application/backend/fetch_inventory_count.dart';
import 'package:_3gx_application/backend/insert_inventory_count.dart';
import 'package:_3gx_application/backend/inventory_item.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

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
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return SafeArea(child:  Scaffold(
      appBar: AppBar(
       
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8), // Adjust padding
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Item Information Section
            _buildSectionHeader("Item Information", icon: Icons.info_outline),
            Text(
              "View the complete details of the item.",
              style:  GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 10),
            _buildInfoCard(
              children: [
                _buildInfoRow("Description", widget.item.itemDesc,
                    icon: Icons.description, isSmallScreen: isSmallScreen),
                _buildInfoRow("SKU/Item No.", widget.item.itemNo,
                    icon: Icons.confirmation_number,
                    isSmallScreen: isSmallScreen),
                _buildInfoRow(
                    "Price", "\$${widget.item.itemPrice.toStringAsFixed(2)}",
                    icon: Icons.attach_money, isSmallScreen: isSmallScreen),
                _buildInfoRow("Initial Count", widget.item.qty.toString(),
                    icon: Icons.format_list_numbered,
                    isSmallScreen: isSmallScreen),
                _buildInfoRow("Barcode", widget.item.barcode,
                    icon: Icons.qr_code, isSmallScreen: isSmallScreen),
                _buildInfoRow(
                    "Last Order Date",
                    widget.item.lastOrderDate != null
                        ? "${widget.item.lastOrderDate!.toLocal().year}-${widget.item.lastOrderDate!.toLocal().month.toString().padLeft(2, '0')}-${widget.item.lastOrderDate!.toLocal().day.toString().padLeft(2, '0')}"
                        : "N/A",
                    icon: Icons.calendar_today,
                    isSmallScreen: isSmallScreen),
                _buildInfoRow(
                    "Date Created",
                    widget.item.dateCreated != null
                        ? "${widget.item.dateCreated!.toLocal().year}-${widget.item.dateCreated!.toLocal().month.toString().padLeft(2, '0')}-${widget.item.dateCreated!.toLocal().day.toString().padLeft(2, '0')}"
                        : "N/A",
                    icon: Icons.date_range,
                    isSmallScreen: isSmallScreen),
                _buildInfoRow(
                    "Date Modified",
                    widget.item.dateModified != null
                        ? "${widget.item.dateModified!.toLocal().year}-${widget.item.dateModified!.toLocal().month.toString().padLeft(2, '0')}-${widget.item.dateModified!.toLocal().day.toString().padLeft(2, '0')}"
                        : "N/A",
                    icon: Icons.edit,
                    isSmallScreen: isSmallScreen),
              ],
            ),

            SizedBox(height: isSmallScreen ? 16 : 24),

            // Branch Selection Section
            _buildSectionHeader("Select Branch", icon: Icons.store),
            Text(
              "Choose a branch to view the item count.",
              style:  GoogleFonts.poppins(fontSize: 12, color: Colors.grey)  ,
            ),
            SizedBox(height: 10),
              FutureBuilder<List<Map<String, String>>>(
                future: fetchBranchNames(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    );
                  }
                  return _buildBranchDropdown(snapshot.data!,
                      isSmallScreen: isSmallScreen);
                },
              ),
            SizedBox(height: isSmallScreen ? 16 : 24),

            // Current Count Section
            _buildSectionHeader("Current Count", icon: Icons.inventory),
            Text(
              "Item count from the selected branch.",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 10),
            FutureBuilder<int>(
              future: fetchBranchCount(
                  widget.item.itemNo, selectedBranchCode ?? ''),
              builder: (context, snapshot) {
                return _buildInfoCard(
                  children: [
                    _buildInfoRow(
                      "Count",
                      snapshot.data?.toString() ?? "0",
                      icon: Icons.format_list_numbered,
                      valueStyle: GoogleFonts.lato(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                      isSmallScreen: isSmallScreen,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),

            // Your Count Section
            _buildSectionHeader("Your Count", icon: Icons.edit),
            Text(
              "Enter your current Count.",
              style:  GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 10,),
            _buildCountInputField(isSmallScreen: isSmallScreen),
            SizedBox(height: isSmallScreen ? 24 : 32),

            // Add Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _addInventoryCount,
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'ADD COUNT',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF40A3EE),

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 32 : 48,
                      vertical: isSmallScreen ? 16 : 20),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    ),
    );
   
  }

  // Helper Methods for UI Components
  Widget _buildSectionHeader(String title,
      {bool isSmallScreen = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 20, color: Colors.black87),
          if (icon != null) SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              // Changed to Poppins
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {TextStyle? valueStyle, bool isSmallScreen = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                if (icon != null) Icon(icon, size: 16, color: Colors.black54),
                if (icon != null) SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.black54,
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: valueStyle ??
                  GoogleFonts.lato(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.black87,
                  ),
              maxLines: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchDropdown(List<Map<String, String>> branches,
      {bool isSmallScreen = false}) {
    return DropdownButtonFormField<String>(
      value: selectedBranch,
      hint: Text(
        'Select Branch',
        style: GoogleFonts.poppins(
          color: Colors.black54,
          fontSize: 16,
        ),
      ),
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade700),
      iconSize: 28,
      items: branches.map((branch) {
        return DropdownMenuItem(
          value: branch['BranchName'],
          child: Text(
            branch['BranchName']!,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 16,
            ),
            maxLines: 5,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedBranch = value;
          selectedBranchCode = branches.firstWhere(
              (branch) => branch['BranchName'] == value)['BranchCode'];
        });
      },
    );
  }

  Widget _buildCountInputField({bool isSmallScreen = false}) {
    return TextField(
      controller: countController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        hintText: 'Enter item count',
        filled: true,
        fillColor: Colors.white,
        hintStyle: GoogleFonts.poppins(),
        prefixIcon: Icon(Icons.format_list_numbered, color: Colors.grey),
      ),
      style: GoogleFonts.poppins(
        fontSize: isSmallScreen ? 14 : 16,
        color: Colors.black87,
      ),
    );
  }

  // Backend Functionality
  void _addInventoryCount() async {
    if (selectedBranch != null && countController.text.isNotEmpty) {
      await addInventoryCount(widget.item.itemNo, selectedBranch!,
          double.tryParse(countController.text) ?? 0.0, 'current_user');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Count added successfully!',
            style: GoogleFonts.lato(),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a branch and enter a count',
            style: GoogleFonts.lato(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
