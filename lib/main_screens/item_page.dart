import 'package:_3gx_application/backend/get_item_details.dart';
import 'package:_3gx_application/main_screens/item_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemlistPage extends StatefulWidget {
  @override
  _ItemlistPageState createState() => _ItemlistPageState();
}

class _ItemlistPageState extends State<ItemlistPage> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Item> _allItems = [];
  List<Item> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    fetchItems().then((items) {
      setState(() {
        _allItems = items;
        _filteredItems = items;
      });
    }).catchError((error) {
      print("Error fetching items: $error");
    });
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _allItems;
      } else {
        _filteredItems = _allItems.where((item) {
          return item.itemDesc.toLowerCase().contains(query.toLowerCase()) ||
              item.itemNo.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  double getTotalUnitsAll() {
    return _allItems.fold(0.0, (sum, item) => sum + (item.qty ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search by item name or number...',
                    border: InputBorder.none,
                    hintStyle:
                        GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                  ),
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                  onChanged: _filterItems,
                )
              : Text(
                  'Inventory List',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
          actions: [
            IconButton(
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _filterItems('');
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.qr_code,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                // Scanner functionality
              },
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Section
              Text(
                'Summary',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10),
              // Helper function to sum the total units from _allItems

// Summary container in your widget tree:
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Total Items",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${_allItems.length}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Container(
                      height: 40,
                      width: 2,
                      color: Colors.white,
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Total Units",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${getTotalUnitsAll()}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Items',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Divider(),
              Expanded(
                child: _filteredItems.isEmpty
                    ? Center(child: Text('No items available'))
                    : ListView.builder(
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          Item item = _filteredItems[index];
                          return ListTile(
                            title: Text(
                              item.itemDesc,
                              style: GoogleFonts.poppins(),
                            ),
                            subtitle: Text(
                              'Item No: ${item.itemNo}\nPrice: ${item.itemPrice} | Qty: ${item.qty}',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ItemDetailsPage(item: item),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
