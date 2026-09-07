import 'package:flutter/material.dart';

/// Mount on first visit and retain form/scroll state and disable animations on hidden pages.
class LazyPageStack extends StatefulWidget {
  const LazyPageStack({super.key, required this.index, required this.children});

  final int index;
  final List<Widget> children;

  @override
  State<LazyPageStack> createState() => _LazyPageStackState();
}

class _LazyPageStackState extends State<LazyPageStack> {
  final _visited = <int>{};

  @override
  Widget build(BuildContext context) {
    _visited.add(widget.index);
    return Stack(
      fit: StackFit.expand,
      children: [
        for (var i = 0; i < widget.children.length; i++)
          if (_visited.contains(i))
            Visibility(
              key: ValueKey(i),
              visible: i == widget.index,
              maintainState: true,
              child: TickerMode(
                enabled: i == widget.index,
                child: RepaintBoundary(child: widget.children[i]),
              ),
            ),
      ],
    );
  }
}
