import '../pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../repository/report_repository.dart';
import 'package:get/get.dart';

class MonthReportPage extends StatefulWidget {
  MonthReportPage({Key? key}) : super(key: key);

  @override
  ReportPageState createState() => ReportPageState();
}

class ReportPageState extends State<MonthReportPage> {
  late List<_Data> _countData = [];

  String _selectedRange = 'currentWeek'; // Default selection

  @override
  void initState() {
    super.initState();
    _loadCountByMonth();
  }



  final _formKey = GlobalKey<FormState>();
  final _yearController = TextEditingController();
  final _monthController = TextEditingController();

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  void _loadCountByMonth() async {
    final controller = ReportRepository();
    final countMap = await controller.getCountByMonth();
    setState(() {
      _countData = countMap.entries
          .map((entry) => _Data(entry.key, entry.value))
          .toList();
    }); // Update the UI after loading the data
  }

  void _getMonthData(int year , int month) async {
    final controller = ReportRepository();
    final countMap = await controller.getMonth(year, month);
    setState(() {
      _countData = countMap.entries
          .map((entry) => _Data(entry.key, entry.value))
          .toList();
    }); // Update the UI after loading the data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Report'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Button bar for selecting the time range
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _yearController,
                          decoration: InputDecoration(
                            labelText: 'Year',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a year';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Flexible(
                        child: TextFormField(
                          controller: _monthController,
                          decoration: InputDecoration(
                            labelText: 'Month',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a month';
                            }
                            int? month = int.tryParse(value);
                            if (month == null || month < 1 || month > 12) {
                              return 'Please enter a valid month (1-12)';
                            }

                            int currentYear = DateTime.now().year;
                            int currentMonth = DateTime.now().month;
                            int? enteredYear = int.tryParse(_yearController.text);

                            if (enteredYear != null && (enteredYear > currentYear || (enteredYear == currentYear && month > currentMonth))) {
                              return 'Month cannot be after the current month';
                            }

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        int year = int.parse(_yearController.text);
                        int month = int.parse(_monthController.text);
                        _getMonthData(year, month);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
          // Initialize the chart widget
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: const ChartTitle(text: 'Monthly Focus Time Analysis'),
              // Enable legend
              legend: const Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_Data, String>>[
                LineSeries<_Data, String>(
                  dataSource: _countData,
                  xValueMapper: (_Data data, _) =>
                      DateFormat('dd/MM/yy').format(data.date),
                  yValueMapper: (_Data data, _) => data.count,
                  name: 'Number of Pomodoro Sessions',
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
          // List of data
          Expanded(
            child: ListView.builder(
              itemCount: _countData.length,
              itemBuilder: (context, index) {
                final data = _countData[index];
                final focusTime = data.count * 25; // Calculate focus time
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Date:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${DateFormat('dd/MM/yy').format(data.date)} - ${DateFormat('dd/MM/yy').format(data.date.add(Duration(days: 6)))}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text(
                            'Completed Pomodoro Session:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${data.count}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Focus Time:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$focusTime min',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],

      ),
    );
  }
}

class _Data {
  final DateTime date;
  final int count;

  _Data(this.date, this.count);
}
