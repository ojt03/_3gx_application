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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by item name or number...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                style: TextStyle(color: Colors.black, fontSize: 14),
                onChanged: _filterItems,
              )
            : Text(
                'Inventory List',
                style: GoogleFonts.poppins(
                  fontSize: 14,
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
          children: [
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
    );
  }
}
