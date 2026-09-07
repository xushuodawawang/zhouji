import 'package:flutter/material.dart';

import '../utils/timeline_position_calculator.dart';

class DetailZoomToolbar extends StatelessWidget {
  const DetailZoomToolbar({
    super.key,
    required this.hourHeight,
    required this.onZoomOut,
    required this.onZoomIn,
    required this.onFitDay,
  });

  final double hourHeight;
  final VoidCallback onZoomOut;
  final VoidCallback onZoomIn;
  final VoidCallback onFitDay;

  @override
  Widget build(BuildContext context) {
    final percentage = TimelinePositionCalculator.zoomPercentage(hourHeight);
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          IconButton.outlined(
            key: const ValueKey('detail-zoom-out'),
            tooltip: '缩小时间表',
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            padding: EdgeInsets.zero,
            onPressed:
                hourHeight > TimelinePositionCalculator.minHourHeight
                    ? onZoomOut
                    : null,
            icon: const Icon(Icons.remove, size: 20),
          ),
          SizedBox(
            width: 64,
            child: Text(
              '$percentage%',
              key: const ValueKey('detail-zoom-percentage'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton.outlined(
            key: const ValueKey('detail-zoom-in'),
            tooltip: '放大时间表',
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            padding: EdgeInsets.zero,
            onPressed:
                hourHeight < TimelinePositionCalculator.maxHourHeight
                    ? onZoomIn
                    : null,
            icon: const Icon(Icons.add, size: 20),
          ),
          const Spacer(),
          TextButton.icon(
            key: const ValueKey('detail-zoom-fit-day'),
            onPressed: onFitDay,
            style: TextButton.styleFrom(
              minimumSize: const Size(44, 44),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            icon: const Icon(Icons.fit_screen_outlined, size: 18),
            label: const Text('适配整天'),
          ),
        ],
      ),
    );
  }
}
