import 'package:http/http.dart' as http;
import 'dart:convert';

Future<int> fetchBranchCount(String itemNo, String branchNo) async {
  // Construct the URL with parameters
  var url = Uri.parse('http://localhost/3gx_inventory/fetch_count.php');

  // Make the GET request with the parameters
  var response = await http.get(url);

  if (response.statusCode == 200) {
    // Parse the response body
    var data = jsonDecode(response.body);

    // Check if inventory counts exist and match the item and branch
    for (var item in data['inventory_counts']) {
      if (item['Item_No'] == itemNo && item['Bra_No'] == branchNo) {
        return item['Count']; // Return the count
      }
    }

    // If no matching item found, return 0
    return 0;
  } else {
    throw Exception('Failed to fetch count');
  }
}
