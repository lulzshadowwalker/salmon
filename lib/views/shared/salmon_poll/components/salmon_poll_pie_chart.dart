import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/models/poll.dart';

import '../../../../theme/salmon_colors.dart';
import '../../chat_indicator/chart_indicator.dart';

class SalmonPollPieChart extends StatefulWidget {
  const SalmonPollPieChart({
    required this.poll,
    super.key,
  });

  final Poll poll;

  @override
  State<SalmonPollPieChart> createState() => _SalmonPollPieChartState();
}

class _SalmonPollPieChartState extends State<SalmonPollPieChart> {
  int touchedIndex = -1;

  static final colors = <Color>[
    SalmonColors.blue,
    SalmonColors.orange,
    SalmonColors.green,
    SalmonColors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Transform.scale(
                scale: 1.2,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 25,
                    sections: showingSections(),
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              (widget.poll.options ?? []).length,
              (index) {
                final opt = widget.poll.options!.elementAt(index);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ChartIndicator(
                    color: colors[index % colors.length],
                    text: (context.isEn ? opt.enTitle : opt.arTitle) ??
                        context.sl.unknown,
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate((widget.poll.options ?? []).length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 50.0 : 16.0;
      final radius = isTouched ? 65.0 : 50.0;

      final opt = widget.poll.options!.elementAt(i);

      final totalCount = widget.poll.totalInteractions ?? 1;
      final optionCount = opt.interactionCount ?? 0;

      final percentage = (optionCount * 100 ~/ totalCount).clamp(0, 100);

      return PieChartSectionData(
        color: colors[i % colors.length],
        value: percentage.toDouble(),
        title: '$percentage %',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    });
  }
}
