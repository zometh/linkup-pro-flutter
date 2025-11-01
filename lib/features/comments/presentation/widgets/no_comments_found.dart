import 'package:flutter/material.dart';

class NoCommentsFound extends StatelessWidget {
  const NoCommentsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No comments found.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
