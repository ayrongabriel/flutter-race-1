import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TestData extends StatelessWidget {
  const TestData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String data = "21/12/2021";
    final d = data.substring(0, 2);
    final m = data.substring(3, 5);
    final a = data.substring(6, 10);
    final parseData = "${a}-${m}-${d}";

    // DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);
    // DateTime data = DateTime.parse("2021-/12/21");
    final dateWithT = DateFormat("yMd");
    // final dateTime = dateWithT.parse(date.toString());
    return Container(
      child: Center(
        child: Text(parseData),
      ),
    );
  }
}
