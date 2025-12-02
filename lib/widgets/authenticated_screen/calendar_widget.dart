import 'package:bazi_app_frontend/constants/constants.dart';
import 'package:bazi_app_frontend/widgets/luck_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:bazi_app_frontend/configs/theme.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final month = thaiMonth.values.toList();
  final monthValue = thaiMonth.keys.toList();
  int selectedMonth = DateTime.now().month - 1;

  @override
  Widget build(BuildContext context) {
    // final List<DropdownMenuItem<String>> items = List.generate(
    //     thaiMonth.length,
    //     (index) => DropdownMenuItem(
    //           value: monthValue[index],
    //           child: Text(month[index]),
    //         ));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "ปฏิทินวันดีประจำปี ${DateTime.now().year + 543}",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton(
                  underline: const SizedBox(),
                  isExpanded: true,
                  iconEnabledColor: Colors.white,
                  value: monthValue[selectedMonth],
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                  selectedItemBuilder: (BuildContext context) {
                    return monthValue.map<Widget>((String i) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          thaiMonth[i] ?? '',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: wColor),
                        ),
                      );
                    }).toList();
                  },
                  items: monthValue.map<DropdownMenuItem<String>>((String i) {
                    return DropdownMenuItem<String>(
                      value: i,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          thaiMonth[i] ?? '',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = int.parse(value!) - 1;
                    });
                  },
                ),
              ),
              const SizedBox(height: 35),
              LuckCalendarWidget(selectedMonth: selectedMonth),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('วันนี้'),
                    const SizedBox(width: 20),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color(0xFF316141),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('วันดี'),
                    const SizedBox(width: 20),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('วันอริ'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
