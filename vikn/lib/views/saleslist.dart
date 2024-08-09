import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vikn/api/api.dart';
import 'package:vikn/utils/constants.dart';
import 'package:vikn/views/filterpage.dart';

class SaleListPage extends StatefulWidget {
  const SaleListPage({super.key});

  @override
  _SaleListPageState createState() => _SaleListPageState();
}

class _SaleListPageState extends State<SaleListPage> {
  List<dynamic> _sales = [];
  List<dynamic> _filteredSales = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    _fetchSales();
    _searchController.addListener(_filterSales);
  }

  Future<void> _fetchSales() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final sales = await fetchSalesData(
        1,
        "1901b825-fe6f-418d-b5f0-7223d0040d08",
        GetStorage().read("user_id").toString(), // Replace with actual userID
        2,
        pageNumber,
        10,
        "Sales",
        1,
      );

      setState(() {
        _sales = sales;
        _filteredSales = _sales;
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterSales() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSales = _sales.where((sale) {
        return sale['itemName'].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Divider(color: secondaryColor,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Color(0xff1C3347),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 50,
                  // Adjust width as needed
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add filter logic here
                      Get.to(() => FilterPage());
                    },
                    icon: Icon(Icons.filter_list,color: primaryColor,),
                    label: Text('Add Filters',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1B2B30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: secondaryColor,),
          Expanded(
            child: _filteredSales.isEmpty
                ? Center(child: Text('No data available', style: TextStyle(color: Colors.white)))
                : ListView.builder(
              itemCount: _filteredSales.length,
              itemBuilder: (context, index) {
                final sale = _filteredSales[index];
                return _buildSaleItem(sale);
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSaleItem(dynamic sale) {
    // Mock data to simulate API response (replace with actual sale data fields)
    String invoiceNo = "#${sale['invoiceNo'] ?? 'Invoice No'}";
    String customerName = sale['customerName'] ?? 'Customer Name';
    String status = sale['status'] ?? 'Pending';
    String amount = sale['amount'] ?? 'SAR 10,000.00';

    Color statusColor;
    switch (status) {
      case 'Invoiced':
        statusColor = Colors.blue;
        break;
      case 'Cancelled':
        statusColor = Colors.grey;
        break;
      case 'Pending':
      default:
        statusColor = Colors.red;
        break;
    }

    return ListTile(
      title: Text(
        invoiceNo,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customerName,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            amount,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
      trailing: Text(
        status,
        style: TextStyle(color: statusColor),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      tileColor: Colors.black,
    );
  }
}