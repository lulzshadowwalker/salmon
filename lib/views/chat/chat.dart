import 'package:flutter/material.dart';
import 'package:salmon/views/home/components/home_app_bar.dart';
import 'package:salmon/views/shared/salmon_navigator/salmon_navigator.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return SalmonNavigator(
      child: Builder(builder: (context) {
        return const Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAppBar(),
              Expanded(
                child: Center(
                  child: Text('Chat'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
