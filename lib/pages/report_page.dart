import '../pages/month_report_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../repository/report_repository.dart';
import 'package:get/get.dart';

class ReportPage extends StatefulWidget {
  ReportPage({Key? key}) : super(key: key);

  @override
  ReportPageState createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> {
  late List<_Data> _countByWeek = [];

  @override
  void initState() {
    super.initState();
    _loadCountByWeek();
  }

  void _loadCountByWeek() async {
    final controller = ReportRepository();
    final countMap = await controller.getCountByWeek();
    setState(() {
      _countByWeek = countMap.entries
          .map((entry) => _Data(entry.key, entry.value))
          .toList();
    }); // Update the UI after loading the data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: GestureDetector(
              onTap: () {
                Get.to(() =>MonthReportPage());
              },
              child: const Row(
                children: [
                  Icon(Icons.calendar_month, color: Colors.black),
                  Text("Monthly Report")
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Initialize the chart widget
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: const ChartTitle(text: 'Weekly Focus Time Analysis'),
              // Enable legend
              legend: const Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_Data, String>>[
                LineSeries<_Data, String>(
                  dataSource: _countByWeek,
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
              itemCount: _countByWeek.length,
              itemBuilder: (context, index) {
                final data = _countByWeek[index];
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
                            DateFormat('dd/MM/yy').format(data.date),
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
