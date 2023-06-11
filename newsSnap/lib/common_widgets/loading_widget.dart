import 'package:flutter/material.dart';
import 'package:newssnap/home_screen/constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: fourthColor,
      ),
    );
  }
}
