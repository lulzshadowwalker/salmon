import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:salmon/views/shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import 'package:video_player/video_player.dart';

class SalmonVideoPlayer extends HookWidget {
  const SalmonVideoPlayer(
    this.controller, {
    this.onInitialized,
    Key? key,
  }) : super(key: key);

  final VideoPlayerController controller;
  final Function(VideoPlayerController controller)? onInitialized;

  @override
  Widget build(BuildContext context) {
    final con = useMemoized(() => controller, [controller.dataSource]);
    final isInit = useState(false);

    useEffect(() {
      con.initialize();

      if (onInitialized != null) onInitialized!(con);

      void listener() {
        isInit.value = con.value.isInitialized;
      }

      con.addListener(listener);

      return () {
        con.removeListener(listener);
        con.dispose();
      };
    }, const []);

    return con.value.isInitialized
        ? AspectRatio(
            aspectRatio: con.value.aspectRatio,
            child: VideoPlayer(con),
          )
        : const Center(
            child: SalmonLoadingIndicator(),
          );
  }
}
