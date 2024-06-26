import 'package:logger/logger.dart';

class SalmonLogPrinter extends PrettyPrinter {
  SalmonLogPrinter(this.className);

  final String className;

  @override
  List<String> log(LogEvent event) {
    final levelEmjois = PrettyPrinter.levelEmojis
      ..[Level.verbose] = '🫣😶‍🌫️'
      ..[Level.error] = '🤬'
      ..[Level.warning] = '🚧'
      ..[Level.wtf] = '🤦🏼‍♀️'
      ..[Level.debug] = '🐞';

    /// I don't think those colors are supported are supported in the vscode
    /// as stated in the package docs
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = '\t${levelEmjois[event.level]}';

    return [color!('$emoji $className | ${event.message}')];
  }
}
