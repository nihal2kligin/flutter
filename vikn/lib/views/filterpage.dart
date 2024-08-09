import 'package:flutter/material.dart';
import 'package:vikn/utils/constants.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String _selectedPeriod = 'This Month';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _selectedStatus = 'Pending';
  String? _selectedCustomer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        actions: [
          IconButton(
            icon: Icon(Icons.remove_red_eye_outlined,color: Colors.blue,),
            onPressed: () {
              // Implement filter logic here
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0,left: 10.0),
            child: Text('Filter',style: TextStyle(color: primaryColor),),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Divider(color: secondaryColor,),
            SizedBox(height: 10,),
            // Period Dropdown
            Center(
              child: Container(
                width: 150, // Adjust width as needed
                // Adjust height to make it look like a button
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200), // Adjust border radius
                  color: Color(0xff08131E),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedPeriod,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    border: InputBorder.none,
                    // Ensure the dropdown button fits the container
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  items: ['This Month', 'Last Month', 'Custom']
                      .map((period) => DropdownMenuItem(
                    value: period,
                    child: Text(
                      period,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14, // Adjust font size here
                      ),
                    ),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPeriod = value!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16),

            // Date Pickers
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: _buildDatePicker('Start Date', _startDate, (date) {
                    setState(() {
                      _startDate = date!;
                    });
                  }),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: _buildDatePicker('End Date', _endDate, (date) {
                    setState(() {
                      _endDate = date!;
                    });
                  }),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(color: secondaryColor,),

            // Status Toggle Buttons
            Container(
              padding: EdgeInsets.all(10),
              child: ToggleButtons(
                isSelected: [
                  _selectedStatus == 'Pending',
                  _selectedStatus == 'Invoiced',
                  _selectedStatus == 'Cancelled'
                ],
                onPressed: (index) {
                  setState(() {
                    if (index == 0) {
                      _selectedStatus = 'Pending';
                    } else if (index == 1) {
                      _selectedStatus = 'Invoiced';
                    } else if (index == 2) {
                      _selectedStatus = 'Cancelled';
                    }
                  });
                },
                borderRadius: BorderRadius.circular(200), // Border radius for rounded corners
                borderWidth: 0, // Border width to separate buttons
                borderColor: Colors.transparent, // Border color
                selectedBorderColor: primaryColor, // Border color when selected
                selectedColor: Colors.white, // Text color when selected
                fillColor: primaryColor, // Background color when selected
                color: Colors.white, // Text color when not selected
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Pending'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Invoiced'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Cancelled'),
                  ),
                ],
                // Border color for non-selected state
              ),
            ),

            SizedBox(height: 16),

            // Customer Dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding as needed
              decoration: BoxDecoration(
                color: Color(0xff08131E), // Background color of the container
                borderRadius: BorderRadius.circular(10), // Border radius for rounded corners
                border: Border.all(color: Color(0xff1C3347), width: 1), // Border color and width
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedCustomer,
                decoration: InputDecoration(
                  border: InputBorder.none, // Remove default border
                ),
                hint: Text("Customer", style: TextStyle(color: Colors.white)),
                items: ['savad farooque', 'John Doe', 'Jane Doe']
                    .map((customer) => DropdownMenuItem(
                  value: customer,
                  child: Text(
                    customer,
                    style: TextStyle(color: Colors.white), // Text color of the items
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCustomer = value;
                  });
                },
                dropdownColor: Colors.grey[800], // Background color of the dropdown menu
              ),
            ),
            SizedBox(height: 16),
            // Selected Customer Chip
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                backgroundColor: Color(0xff1B2B30),
                label: Text(_selectedCustomer ?? 'None', style: TextStyle(color: Colors.white)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Adjust border radius
                ),
                deleteIconColor: Colors.blue, // Color of the delete icon
                onDeleted: () {
                  setState(() {
                    _selectedCustomer = null;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime date, Function(DateTime?) onDateChanged) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          onDateChanged(pickedDate);
        }
      },
      child: Container(
        width: 120,
        height: 40,// Adjust width as needed
        // Adjust height to make it look like a button
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200), // Adjust border radius
          color: Color(0xff1B2B30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.calendar_month,color: primaryColor,),
            Text('${date.day}/${date.month}/${date.year}'),
          ],
        ),
      ),
    );
  }
}