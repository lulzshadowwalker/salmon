import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/polls/polls_controller.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/models/poll.dart';

import '../../../../theme/salmon_colors.dart';
import '../../chat_indicator/chart_indicator.dart';

class SalmonPollPieChart extends StatefulHookConsumerWidget {
  const SalmonPollPieChart({
    required this.poll,
    super.key,
  });

  final Poll poll;

  @override
  ConsumerState<SalmonPollPieChart> createState() => _SalmonPollPieChartState();
}

class _SalmonPollPieChartState extends ConsumerState<SalmonPollPieChart> {
  int touchedIndex = -1;

  static final colors = <Color>[
    SalmonColors.blue,
    SalmonColors.orange,
    SalmonColors.green,
    SalmonColors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
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
                    sections: showingSections(ref),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
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
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            (context.isEn ? widget.poll.enTitle : widget.poll.arTitle) ??
                context.sl.unknown,
            style: TextStyle(
              color: SalmonColors.muted,
            ),
          ),
        )
      ],
    );
  }

  List<PieChartSectionData> showingSections(WidgetRef ref) {
    return List.generate((widget.poll.options ?? []).length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 50.0 : 16.0;
      final radius = isTouched ? 65.0 : 50.0;

      final opt = widget.poll.options!.elementAt(i);
      final percentage = ref
          .watch(
            pollOptVotePercentageProvider(widget.poll.id ?? '', opt.id ?? ''),
          )
          .toStringAsFixed(1);

      return PieChartSectionData(
        color: colors[i % colors.length],
        value: double.parse(percentage),
        title: '$percentage %',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      );
    });
  }
}
