import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchBranchNames() async {
  // Replace with your API URL
  final response = await http.get(Uri.parse('http://localhost/3gx_inventory/get_branches.php'));

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON
    List<dynamic> data = jsonDecode(response.body); 
    List<String> branchNames = [];
    
    // Loop through the response and extract branch names
    for (var item in data) {
      branchNames.add(item['BranchName']);
    }
    
    return branchNames;
  } else {
    // If the server did not return a 200 OK response, throw an error
    throw Exception('Failed to load branches');
  }
}
