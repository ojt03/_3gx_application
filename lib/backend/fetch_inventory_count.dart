import 'package:http/http.dart' as http;
import 'dart:convert';

Future<int> fetchBranchCount(String itemNo, String branchNo) async {
  var url = Uri.parse('http://localhost/3gx_inventory/fetch_count.php');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    
    print("🔵 Expected Item_No: '$itemNo', Expected Bra_No: '$branchNo'");

    for (var item in data['inventory_counts']) {
      String apiItemNo = item['Item_No'].toString().trim();
      String apiBranchNo = item['Bra_No'].toString().trim();
      String apiCount = item['Count'].toString();

      print("🟡 Checking API Item_No: '$apiItemNo', API Bra_No: '$apiBranchNo', Count: '$apiCount'");

      if (apiItemNo == itemNo.trim() && apiBranchNo == branchNo.trim()) {
        print("✅ Match Found! Returning Count: $apiCount");
        return int.tryParse(apiCount) ?? 0;
      }
    }

    print("❌ No Match Found, Returning 0");
    return 0;
  } else {
    throw Exception('Failed to fetch count');
  }
}