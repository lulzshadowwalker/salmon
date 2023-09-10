import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/router/salmon_routes.dart';

import '../../helpers/salmon_anims.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.primaryContainer,
      body: Center(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: LottieBuilder.asset(
                      SalmonAnims.notFound,
                      frameRate: FrameRate.max,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SelectableText.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: context.sl.oops,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        TextSpan(
                          text: '\n${context.sl.pageNotFound}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color:
                                    context.cs.onBackground.withOpacity(0.75),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () => context.goNamed(SalmonRoutes.analytics),
                    child: Text(
                      context.sl.goBackHome,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
