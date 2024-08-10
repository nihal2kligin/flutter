import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vikn/views/saleslist.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedDay = 2; // Initially selected day

  // Function to generate random graph data
  List<FlSpot> _generateRandomData() {
    final random = Random();
    return List.generate(7, (index) {
      return FlSpot(index.toDouble() + 1, (1000 + random.nextInt(2000)).toDouble());
    });
  }

  // Mock data for the graph based on selected day
  Map<int, List<FlSpot>> _graphData = {
    1: [],
    2: [],
    3: [],
    4: [],
    5: [],
    6: [],
    7: [],
    8: [],
    9: [],
    10: [],
  };

  @override
  void initState() {
    super.initState();
    // Initialize graph data with random values
    _graphData = Map.fromIterable(
      _graphData.keys,
      value: (_) => _generateRandomData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Image.asset(
          'assets/icons/logo.png',
          width: 120, // Adjust the width
          height: 100, // Adjust the height
          fit: BoxFit.fitWidth, // Adjust this to fit your design
        ),


        actions: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent, // Optional: To give a background color
            ),
            child: ClipOval(
              child: SvgPicture.asset(
                'assets/icons/profile_icon.svg',
                fit: BoxFit.cover,
                width: 50, // Adjust width for SVG icon
                height: 50, // Adjust height for SVG icon
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRevenueCard(),
              const SizedBox(height: 16),
              _buildStatisticsCard("Bookings", "123", "Reserved", 'assets/icons/booking.svg',Color(0xffF4EDEB)),
              const SizedBox(height: 16),
          InkWell(
            onTap: (){
              Get.to(()=>SaleListPage());
            },
              child: _buildStatisticsCard("Invoices", "10,232.00", "Rupees", 'assets/icons/invoice.svg',Color(0xffA5C4C0))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "SAR ",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100,color: Colors.grey),
                      ),
                      Text(
                        " 2,78,000.00",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "+21% ",
                        style: TextStyle(color: Colors.green),
                      ),
                      Text(
                        " than last month.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
              Text("Revenue", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100)),
            ],
          ),
          const SizedBox(height: 26),
          // Chart goes here
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(
                  show: true, // Set this to true to show grid lines
                  drawVerticalLine: false, // If you don't want vertical lines
                  horizontalInterval: 1000, // Adjust the interval for horizontal lines
                ),
                borderData: FlBorderData(
                  border: const Border(
                    bottom: BorderSide(color: Colors.transparent),
                    left: BorderSide(color: Colors.transparent),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(color: Colors.grey, fontSize: 8);
                        return Text(value.toInt().toString(), style: style);
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                minX: 1,
                maxX: 7,
                minY: 0,
                maxY: 4000,
                lineBarsData: [
                  LineChartBarData(
                    spots: _graphData[_selectedDay] ?? [],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 4,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Center(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("September 2023"),
          )),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                10,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _buildDateButton(index + 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(String title, String value, String subtitle, String icon, Color colorvalue) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon,),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: colorvalue),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Container(
              width: 60, // Set the width of the square box
              height: 60, // Set the height of the square box to match the width
              decoration: BoxDecoration(
                color: const Color(0xff151515), // Background color of the box
                borderRadius: BorderRadius.circular(10), // Optional: rounded corners
              ),
          child: const Icon(Icons.arrow_forward_rounded, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDateButton(int day) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _selectedDay == day ? Colors.blue : const Color(0xff151515),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          day.toString().padLeft(2, '0'),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
