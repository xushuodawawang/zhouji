import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/focus_session.dart';
import '../providers/app_providers.dart';
import '../utils/app_colors.dart';
import '../utils/date_time_utils.dart';

class FocusDashboard extends ConsumerStatefulWidget {
  const FocusDashboard({super.key});
  @override
  ConsumerState<FocusDashboard> createState() => _FocusDashboardState();
}

class _FocusDashboardState extends ConsumerState<FocusDashboard> {
  DateTime _day = AppDateUtils.dateOnly(DateTime.now());
  int _range = 0;
  DateTimeRange? _custom;
  static const _green = Color(0xFF17725F);

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(allFocusSessionsProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (_, __) => TextButton(
                onPressed: () => ref.invalidate(allFocusSessionsProvider),
                child: const Text('专注数据加载失败，重试'),
              ),
          data: (sessions) {
            final now = AppDateUtils.dateOnly(DateTime.now());
            final total = sessions.fold(0, (sum, s) => sum + s.actualMinutes);
            final first =
                sessions.isEmpty
                    ? now
                    : sessions
                        .map((s) => s.sessionDate)
                        .reduce((a, b) => a.isBefore(b) ? a : b);
            final days = math.max(1, now.difference(first).inDays + 1);
            final daily =
                sessions
                    .where((s) => AppDateUtils.isSameDate(s.sessionDate, _day))
                    .toList();
            final start = switch (_range) {
              1 => AppDateUtils.startOfWeek(_day),
              2 => AppDateUtils.startOfMonth(_day),
              3 => _custom?.start ?? _day,
              _ => _day,
            };
            final end = switch (_range) {
              1 => start.add(const Duration(days: 7)),
              2 => DateTime(start.year, start.month + 1),
              3 => (_custom?.end ?? _day).add(const Duration(days: 1)),
              _ => start.add(const Duration(days: 1)),
            };
            final selected =
                sessions
                    .where(
                      (s) =>
                          !s.sessionDate.isBefore(start) &&
                          s.sessionDate.isBefore(end),
                    )
                    .toList();
            final distribution = <String, int>{};
            for (final s in selected) {
              final title = s.note.isEmpty ? '自由专注' : s.note;
              distribution.update(
                title,
                (v) => v + s.actualMinutes,
                ifAbsent: () => s.actualMinutes,
              );
            }
            final entries =
                distribution.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));
            final hours = List<double>.filled(24, 0);
            for (final s in sessions.where(
              (s) =>
                  s.sessionDate.year == _day.year &&
                  s.sessionDate.month == _day.month,
            )) {
              final elapsed = s.endedAt.difference(s.startedAt).inSeconds;
              if (elapsed <= 0) {
                hours[s.startedAt.hour] += s.actualMinutes;
                continue;
              }
              var cursor = s.startedAt;
              while (cursor.isBefore(s.endedAt)) {
                final boundary = DateTime(
                  cursor.year,
                  cursor.month,
                  cursor.day,
                  cursor.hour + 1,
                );
                final stop =
                    boundary.isBefore(s.endedAt) ? boundary : s.endedAt;
                hours[cursor.hour] +=
                    s.actualMinutes *
                    stop.difference(cursor).inSeconds /
                    elapsed;
                cursor = stop;
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _panel(
                  '累计专注',
                  Column(
                    children: [
                      Row(
                        children: [
                          _metric('次数', '${sessions.length}'),
                          _metric('时长', AppDateUtils.formatDuration(total)),
                          _metric(
                            '日均时长',
                            AppDateUtils.formatDuration((total / days).round()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '日均按首次专注至今天的自然日计算',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _panel(
                  '当日专注  ${_date(_day)}',
                  Column(
                    children: [
                      Row(
                        children: [
                          _metric('次数', '${daily.length}'),
                          _metric(
                            '时长',
                            AppDateUtils.formatDuration(
                              daily.fold(0, (v, s) => v + s.actualMinutes),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: '前一天',
                        onPressed:
                            () => setState(
                              () =>
                                  _day = _day.subtract(const Duration(days: 1)),
                            ),
                        icon: const Icon(Icons.chevron_left),
                      ),
                      IconButton(
                        tooltip: '后一天',
                        onPressed:
                            _day.isBefore(now)
                                ? () => setState(
                                  () =>
                                      _day = _day.add(const Duration(days: 1)),
                                )
                                : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
                _panel(
                  '专注时长分布',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SegmentedButton<int>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(value: 0, label: Text('日')),
                          ButtonSegment(value: 1, label: Text('周')),
                          ButtonSegment(value: 2, label: Text('月')),
                          ButtonSegment(value: 3, label: Text('自定义')),
                        ],
                        selected: {_range},
                        onSelectionChanged: (values) async {
                          final value = values.first;
                          if (value == 3) {
                            final result = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              lastDate: now,
                              initialDateRange: _custom,
                            );
                            if (result == null || !mounted) return;
                            setState(() {
                              _range = value;
                              _custom = result;
                            });
                          } else {
                            setState(() => _range = value);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${_date(start)} — ${_date(end.subtract(const Duration(days: 1)))}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (entries.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 55),
                          child: Text(
                            '暂无专注数据，点击专注任务上的“开始”来计时吧',
                            textAlign: TextAlign.center,
                          ),
                        )
                      else ...[
                        const SizedBox(height: 20),
                        Center(
                          child: SizedBox.square(
                            dimension: 160,
                            child: CustomPaint(
                              painter: _FocusRing(entries),
                              child: Center(
                                child: Text(
                                  AppDateUtils.formatDuration(
                                    selected.fold(
                                      0,
                                      (v, s) => v + s.actualMinutes,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        for (var i = 0; i < entries.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: Color(
                                    AppColors.automaticFocusColor(
                                      entries[i].key,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    entries[i].key,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text('${entries[i].value} 分钟'),
                              ],
                            ),
                          ),
                      ],
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => _showRecords(selected),
                        child: const Text('查看专注记录'),
                      ),
                    ],
                  ),
                ),
                _panel(
                  '本月专注时段分布  ${_day.year}/${_day.month}',
                  Column(
                    children: [
                      const Text(
                        '看看自己通常在哪个时段更专注',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 140,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: _HourBars(
                            hours,
                            Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
  }

  Widget _metric(String label, String value) => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: _green, fontSize: 13)),
          const SizedBox(height: 9),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: _green,
                fontSize: 27,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _panel(String title, Widget child, {Widget? trailing}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: _green,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    ),
  );

  String _date(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _showRecords(
    List<FocusSession> sessions,
  ) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    builder:
        (_) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            const Text(
              '专注记录',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            if (sessions.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text('这个时间段还没有记录'),
              ),
            for (final s in sessions)
              ListTile(
                leading: Icon(
                  s.completed ? Icons.check_circle_outline : Icons.timelapse,
                ),
                title: Text(s.note.isEmpty ? '自由专注' : s.note),
                subtitle: Text(
                  '${_date(s.startedAt)}  ${AppDateUtils.formatMinutes(s.startedAt.hour * 60 + s.startedAt.minute)} · ${s.completed ? '已完成' : '提前结束'}',
                ),
                trailing: Text('${s.actualMinutes} 分钟'),
              ),
          ],
        ),
  );
}

class _FocusRing extends CustomPainter {
  _FocusRing(this.entries);
  final List<MapEntry<String, int>> entries;
  @override
  void paint(Canvas canvas, Size size) {
    final values = entries.map((entry) => entry.value).toList();
    final total = values.fold(0, (a, b) => a + b);
    if (total == 0) return;
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = math.pi * 2 * values[i] / total;
      final gap = values.length > 1 ? math.min(0.035, sweep * 0.16) : 0.0;
      canvas.drawArc(
        (Offset.zero & size).deflate(12),
        start + gap / 2,
        sweep - gap,
        false,
        Paint()
          ..color = Color(AppColors.automaticFocusColor(entries[i].key))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20
          ..strokeCap = StrokeCap.round,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _FocusRing old) => old.entries != entries;
}

class _HourBars extends CustomPainter {
  _HourBars(this.hours, this.labelColor);
  final List<double> hours;
  final Color labelColor;
  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = math.max(1.0, hours.reduce(math.max));
    final width = size.width / 24;
    for (var i = 0; i < 24; i++) {
      final h = hours[i] / maxValue * (size.height - 26);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            i * width + 1,
            size.height - 24 - h,
            math.max(1, width - 3),
            math.max(1, h),
          ),
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFF188C78),
      );
      if (i % 6 == 0 || i == 23) {
        final text = TextPainter(
          text: TextSpan(
            text: '${i.toString().padLeft(2, '0')}:00',
            style: TextStyle(fontSize: 9, color: labelColor),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        text.paint(
          canvas,
          Offset(
            math.min(i * width, size.width - text.width),
            size.height - 18,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HourBars old) =>
      old.hours != hours || old.labelColor != labelColor;
}
