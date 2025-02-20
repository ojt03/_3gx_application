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

