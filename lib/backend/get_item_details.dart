// Import the file where fetchItems is located

import 'dart:convert';
import 'package:_3gx_application/backend/inventory_item.dart';
import 'package:http/http.dart' as http;

Future<List<Item>> fetchItems() async {
  final response = await http.get(Uri.parse('http://localhost/3gx_inventory/get_item_details.php'));

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (responseData["status"] == "success" && responseData["data"] is List) {
      List<dynamic> itemList = responseData["data"];
      return itemList.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception("No items found or invalid response format");
    }
  } else {
    throw Exception("Failed to load items");
  }
}

class Item {
  final String itemNo;
  final String itemDesc;
  final double itemPrice;
  final double qty;

  Item({required this.itemNo, required this.itemDesc, required this.itemPrice, required this.qty});

factory Item.fromJson(Map<String, dynamic> json) {
  return Item(
    itemNo: json['Item_No'],
    itemDesc: json['Item_Desc'],
    itemPrice: json['Item_Price'] != null ? double.parse(json['Item_Price'].toString()) : 0.0, // Safely parse decimal to double
    qty: json['Qty'] != null ? double.parse(json['Qty'].toString()) : 0.0,  // Safely parse double
    
  );
}
}

