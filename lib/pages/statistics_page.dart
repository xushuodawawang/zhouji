import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../models/task_category.dart';
import '../providers/app_providers.dart';
import '../services/statistics_service.dart';
import '../utils/app_colors.dart';
import '../utils/date_time_utils.dart';
import '../widgets/page_heading.dart';
import '../widgets/focus_dashboard.dart';
import '../widgets/timeline_settings_sheet.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  StatisticsRange _range = StatisticsRange.week;

  @override
  Widget build(BuildContext context) {
    void refreshStatistics() {
      for (final range in StatisticsRange.values) {
        ref.invalidate(statisticsDataProvider(range));
      }
    }

    ref.listen(todayFocusSessionsProvider, (_, __) => refreshStatistics());
    ref.listen(todayTasksProvider, (_, __) => refreshStatistics());
    ref.listen(todayRecordsProvider, (_, __) => refreshStatistics());
    final data = ref.watch(statisticsDataProvider(_range));
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(statisticsDataProvider(_range));
          await ref.read(statisticsDataProvider(_range).future);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:
                  Theme.of(context).brightness == Brightness.dark
                      ? [
                        const Color(0xFF153D43),
                        Theme.of(context).colorScheme.surface,
                      ]
                      : [const Color(0xFF68DEEA), const Color(0xFFEFF5F5)],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
            children: [
              PageHeading(
                title: '统计数据',
                subtitle: '看见积累，也看见自己的进步',
                trailing: IconButton.filledTonal(
                  tooltip: '设置',
                  onPressed: () => _showSettings(context),
                  icon: const Icon(Icons.settings_outlined),
                ),
              ),
              const SizedBox(height: 8),
              const FocusDashboard(),
              const SizedBox(height: 8),
              Text('计划执行情况', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              SegmentedButton<StatisticsRange>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: StatisticsRange.today,
                    label: Text('今天'),
                  ),
                  ButtonSegment(value: StatisticsRange.week, label: Text('本周')),
                  ButtonSegment(
                    value: StatisticsRange.month,
                    label: Text('本月'),
                  ),
                ],
                selected: {_range},
                onSelectionChanged:
                    (value) => setState(() => _range = value.first),
              ),
              const SizedBox(height: 16),
              data.when(
                data: (value) => _StatisticsContent(data: value, range: _range),
                loading:
                    () => const Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                error:
                    (_, __) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const Text('统计加载失败'),
                            TextButton(
                              onPressed:
                                  () => ref.invalidate(
                                    statisticsDataProvider(_range),
                                  ),
                              child: const Text('重试'),
                            ),
                          ],
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSettings(BuildContext context) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        builder: (context) => const _SettingsSheet(),
      );
}

class _StatisticsContent extends StatelessWidget {
  const _StatisticsContent({required this.data, required this.range});

  final StatisticsData data;
  final StatisticsRange range;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns =
                constraints.maxWidth < 400 ||
                        MediaQuery.textScalerOf(context).scale(14) > 20
                    ? 2
                    : 3;
            final width = (constraints.maxWidth - (columns - 1) * 8) / columns;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Metric(
                  width: width,
                  label: '专注时间',
                  value: AppDateUtils.formatDuration(data.focusMinutes),
                ),
                _Metric(
                  width: width,
                  label: '完整番茄',
                  value: '${data.completedPomodoros}',
                ),
                _Metric(
                  width: width,
                  label: '专注次数',
                  value: '${data.focusCount}',
                ),
                _Metric(
                  width: width,
                  label: '完成任务',
                  value: '${data.completedTaskCount}/${data.taskCount}',
                ),
                _Metric(
                  width: width,
                  label: '计划时长',
                  value: AppDateUtils.formatDuration(data.plannedMinutes),
                ),
                _Metric(
                  width: width,
                  label: '完成率',
                  value: '${(data.completionRate * 100).round()}%',
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          '专注时间分布',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (data.categoryStats.isEmpty)
          const _EmptyChart(text: '还没有专注记录')
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 142,
                    child: CustomPaint(
                      painter: _DonutPainter(data.categoryStats),
                      child: Center(
                        child: Text(
                          AppDateUtils.formatDuration(data.focusMinutes),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        for (final item in data.categoryStats)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                Container(
                                  width: 9,
                                  height: 9,
                                  decoration: BoxDecoration(
                                    color: Color(item.colorValue),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text('${item.minutes} 分'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 20),
        Text(
          range == StatisticsRange.today ? '每次专注' : '每日专注趋势',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (data.trend.isEmpty || data.trend.every((item) => item.minutes == 0))
          const _EmptyChart(text: '暂无趋势数据')
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 10),
              child: SizedBox(
                height: 180,
                child: CustomPaint(
                  painter: _BarPainter(
                    data.trend,
                    color: Theme.of(context).colorScheme.primary,
                    labelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.fact_check_outlined),
            title: const Text('实际完成记录时长'),
            trailing: Text(
              AppDateUtils.formatDuration(data.actualRecordMinutes),
            ),
          ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.width,
    required this.label,
    required this.value,
  });

  final double width;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 3),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(
              Icons.insights_rounded,
              size: 34,
              color: Theme.of(context).colorScheme.primary.withAlpha(150),
            ),
            const SizedBox(height: 12),
            Text(text),
            const SizedBox(height: 4),
            Text(
              '每一次投入，都会在这里留下记录',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.items);

  final List<CategoryStat> items;

  @override
  void paint(Canvas canvas, Size size) {
    final total = items.fold(0, (sum, item) => sum + item.minutes);
    if (total <= 0) return;
    var start = -math.pi / 2;
    final rect = Offset.zero & size;
    for (final item in items) {
      final sweep = math.pi * 2 * item.minutes / total;
      canvas.drawArc(
        rect.deflate(10),
        start,
        sweep,
        false,
        Paint()
          ..color = Color(item.colorValue)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 18,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.items != items;
}

class _BarPainter extends CustomPainter {
  const _BarPainter(
    this.items, {
    required this.color,
    required this.labelColor,
  });

  final List<TrendStat> items;
  final Color color;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = items.fold(1, (max, item) => math.max(max, item.minutes));
    final slot = size.width / items.length;
    final barWidth = math.min(18.0, slot * 0.58);
    final paint = Paint()..color = color.withAlpha(205);
    final labelPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var index = 0; index < items.length; index++) {
      final height = items[index].minutes / maxValue * (size.height - 30);
      final left = index * slot + (slot - barWidth) / 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, size.height - 22 - height, barWidth, height),
          const Radius.circular(4),
        ),
        paint,
      );
      final showLabel =
          items.length <= 12 || index == 0 || index == items.length - 1;
      if (showLabel) {
        labelPainter.text = TextSpan(
          text: items[index].label,
          style: TextStyle(fontSize: 9, color: labelColor),
        );
        labelPainter.layout(maxWidth: slot);
        labelPainter.paint(
          canvas,
          Offset(
            index * slot + (slot - labelPainter.width) / 2,
            size.height - 14,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) =>
      oldDelegate.items != items ||
      oldDelegate.color != color ||
      oldDelegate.labelColor != labelColor;
}

class _SettingsSheet extends ConsumerWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(appSettingsProvider).valueOrNull ?? const AppSettings();
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const [];
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder:
          (context, controller) => ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            children: [
              Text(
                '应用设置',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('时间轴与自动配色'),
                subtitle: const Text('全天 24 小时、跨天显示'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showTimelineSettings(context),
              ),
              DropdownButtonFormField<String>(
                initialValue: settings.themeMode,
                decoration: const InputDecoration(
                  labelText: '外观模式',
                  prefixIcon: Icon(Icons.dark_mode_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'system', child: Text('跟随系统')),
                  DropdownMenuItem(value: 'light', child: Text('浅色')),
                  DropdownMenuItem(value: 'dark', child: Text('深色')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(settingsRepositoryProvider)
                        .save(settings.copyWith(themeMode: value));
                  }
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<WeekViewMode>(
                initialValue: settings.weekViewMode,
                decoration: const InputDecoration(
                  labelText: '默认周视图',
                  prefixIcon: Icon(Icons.view_week_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: WeekViewMode.overview,
                    child: Text('总览模式'),
                  ),
                  DropdownMenuItem(
                    value: WeekViewMode.detail,
                    child: Text('详细模式'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(settingsRepositoryProvider)
                        .save(settings.copyWith(weekViewMode: value));
                  }
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<ScheduleZoom>(
                initialValue: settings.scheduleZoom,
                decoration: const InputDecoration(
                  labelText: '详细模式默认缩放',
                  prefixIcon: Icon(Icons.height),
                ),
                items: const [
                  DropdownMenuItem(
                    value: ScheduleZoom.compact,
                    child: Text('紧凑'),
                  ),
                  DropdownMenuItem(
                    value: ScheduleZoom.standard,
                    child: Text('标准'),
                  ),
                  DropdownMenuItem(
                    value: ScheduleZoom.spacious,
                    child: Text('宽松'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    final hourHeight = switch (value) {
                      ScheduleZoom.compact => 40.0,
                      ScheduleZoom.standard => 56.0,
                      ScheduleZoom.spacious => 88.0,
                    };
                    ref
                        .read(settingsRepositoryProvider)
                        .save(
                          settings.copyWith(
                            scheduleZoom: value,
                            detailHourHeight: hourHeight,
                          ),
                        );
                  }
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: const Text('计时完成通知'),
                subtitle: const Text('开启时才会请求系统权限'),
                value: settings.notificationEnabled,
                onChanged: (value) async {
                  var enabled = value;
                  if (enabled) {
                    enabled =
                        await ref
                            .read(notificationServiceProvider)
                            .requestPermission();
                  }
                  await ref
                      .read(settingsRepositoryProvider)
                      .save(settings.copyWith(notificationEnabled: enabled));
                },
              ),
              const Divider(height: 28),
              Row(
                children: [
                  Text(
                    '任务分类',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: () => _editCategory(context, ref),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('新增'),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              for (final category in categories)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 8,
                    backgroundColor: Color(category.colorValue),
                  ),
                  title: Text(category.name),
                  subtitle: Text(category.isDefault ? '默认分类' : '自定义分类'),
                  trailing:
                      category.isDefault
                          ? null
                          : PopupMenuButton<String>(
                            onSelected: (action) {
                              if (action == 'edit') {
                                _editCategory(context, ref, category: category);
                              } else {
                                _deleteCategory(context, ref, category);
                              }
                            },
                            itemBuilder:
                                (context) => const [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text('编辑'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('删除'),
                                  ),
                                ],
                          ),
                  onTap:
                      category.isDefault
                          ? null
                          : () =>
                              _editCategory(context, ref, category: category),
                ),
            ],
          ),
    );
  }

  Future<void> _editCategory(
    BuildContext context,
    WidgetRef ref, {
    TaskCategory? category,
  }) async {
    final controller = TextEditingController(text: category?.name);
    var color = category?.colorValue ?? AppColors.taskPalette.first.toARGB32();
    final result = await showDialog<(String, int)>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text(category == null ? '新增分类' : '编辑分类'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller,
                        autofocus: true,
                        maxLength: 20,
                        decoration: const InputDecoration(labelText: '分类名称'),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        children: [
                          for (final item in AppColors.taskPalette)
                            InkWell(
                              onTap:
                                  () => setState(() => color = item.toARGB32()),
                              customBorder: const CircleBorder(),
                              child: CircleAvatar(
                                radius: 17,
                                backgroundColor: item,
                                child:
                                    color == item.toARGB32()
                                        ? const Icon(Icons.check, size: 18)
                                        : null,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                    FilledButton(
                      onPressed: () {
                        final name = controller.text.trim();
                        if (name.isNotEmpty) {
                          Navigator.pop(context, (name, color));
                        }
                      },
                      child: const Text('保存'),
                    ),
                  ],
                ),
          ),
    );
    controller.dispose();
    if (result == null) return;
    await ref
        .read(categoryRepositoryProvider)
        .save(id: category?.id, name: result.$1, colorValue: result.$2);
  }

  Future<void> _deleteCategory(
    BuildContext context,
    WidgetRef ref,
    TaskCategory category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('删除分类？'),
            content: const Text('使用该分类的任务会变为未分类，任务本身不会被删除。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('删除'),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      await ref.read(categoryRepositoryProvider).delete(category);
    }
  }
}
