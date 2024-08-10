import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:vikn/utils/constants.dart';

login_api(String username,String password) async {
  print("login----");
  var request2 = http.MultipartRequest(
      "POST", Uri.parse("https://api.accounts.vikncodes.com/api/v1/users/login"));
  print(request2);
  request2.fields["username"] = username.toString();
  request2.fields["password"] = password.toString();

  var response2 = await request2.send();
  var responseData2 = await response2.stream.toBytes();
  var responseString2 = String.fromCharCodes(responseData2);
  print(responseString2);
  return jsonDecode(responseString2);
}


fetchSalesData(int branchID, String companyID, String createdUserID, int priceRounding, int pageNumber, int itemsPerPage, String type, int warehouseID) async {

  final url = Uri.parse('https://www.api.vikncodes.com/api/v10/sales/sale-list-page/');

  var request = http.MultipartRequest('POST', url)
    ..fields['BranchID'] = branchID.toString()
    ..fields['CompanyID'] = companyID
    ..fields['CreatedUserID'] = createdUserID
    ..fields['PriceRounding'] = priceRounding.toString()
    ..fields['page_no'] = pageNumber.toString()
    ..fields['items_per_page'] = itemsPerPage.toString()
    ..fields['type'] = type
    ..fields['WarehouseID'] = warehouseID.toString();

  print(request);

  var response = await request.send();
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);
  print(responseString);
  return jsonDecode(responseString);
}

Future<Map<String, dynamic>> fetchUserData() async {
  final userID = GetStorage().read('user_id') ?? '';

  if (userID.isEmpty) {
    throw Exception('User ID is missing');
  }

  final url = Uri.parse('https://www.api.viknbooks.com/api/v10/users/user-view/'+userID);
  print(url);

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching user data: $e');
  }
}