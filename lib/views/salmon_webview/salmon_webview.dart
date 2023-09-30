import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/views/shared/app_bar_divider/app_bar_divider.dart';
import 'package:salmon/views/shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SalmonWebview extends StatefulHookWidget {
  const SalmonWebview({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  State<SalmonWebview> createState() => _SalmonWebviewState();
}

class _SalmonWebviewState extends State<SalmonWebview> {
  late final _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(context.theme.scaffoldBackgroundColor)
    ..loadRequest(
      Uri.parse(widget.url),
    );

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    _controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          isLoading.value = progress <= 80;
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 2,
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(16),
          child: SizedBox.shrink(),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          Visibility(
            visible: isLoading.value,
            child: const SalmonLoadingIndicator(),
          ),
        ],
      ),
    );
  }
}
