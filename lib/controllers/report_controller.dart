import 'package:flutter/cupertino.dart';
import '../models/report_model.dart';
import '../repository/report_repository.dart';

class ReportController extends ChangeNotifier {
  final ReportRepository _repository = ReportRepository();
  List<ReportModel> _reports = [];

  List<ReportModel> get reports => _reports;

  void addReport(ReportModel report) async {
    await _repository.addReport(report);
  }

  void updateReport(ReportModel report) async {
    await _repository.updateReport(report);
  }

  void deleteReport(String reportId) async {
    await _repository.deleteReport(reportId);
  }
}
