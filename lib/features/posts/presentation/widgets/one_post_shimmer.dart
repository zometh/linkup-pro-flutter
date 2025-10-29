import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:shimmer/shimmer.dart';

class OnePostShimmer extends StatelessWidget {
  const OnePostShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDarkMode ? const Color(0xFF121212) : Colors.white,

      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,


          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      children: [
                        Container(
                          width: 120.0,
                          height: 10.0,
                          color: Colors.white,
                        ),
                        Container(
                          width: 120.0,
                          height: 10.0,
                          color: Colors.white,
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 400.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 4.0),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 20.0,
                  color: Colors.white,
                ),
              ],
            ),
          )),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
