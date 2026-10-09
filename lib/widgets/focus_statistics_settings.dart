import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../providers/app_providers.dart';
import '../utils/date_time_utils.dart';

class FocusStatisticsSettings extends ConsumerWidget {
  const FocusStatisticsSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(appSettingsProvider).valueOrNull ?? const AppSettings();
    final days = settings.focusStatisticsDays;
    final fromDate = settings.focusStatisticsStartDate;
    final value = fromDate != null ? -1 : days;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InputDecorator(
          decoration: const InputDecoration(
            labelText: '累计专注统计范围',
            prefixIcon: Icon(Icons.date_range_outlined),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              isDense: true,
              items: [
                const DropdownMenuItem(value: 0, child: Text('全部历史')),
                for (final count in [7, 30, 90])
                  DropdownMenuItem(value: count, child: Text('最近 $count 天')),
                if (days > 0 && ![7, 30, 90].contains(days))
                  DropdownMenuItem(value: days, child: Text('最近 $days 天')),
                const DropdownMenuItem(value: -2, child: Text('自定义天数…')),
                const DropdownMenuItem(value: -1, child: Text('从指定日期起…')),
              ],
              onChanged: (selected) async {
                if (selected == null) return;
                if (selected == -1) {
                  await _pickDate(context, ref, settings);
                } else if (selected == -2) {
                  final result = await showDialog<int>(
                    context: context,
                    builder:
                        (context) =>
                            _DaysDialog(initialDays: days > 0 ? days : 30),
                  );
                  if (result == null || !context.mounted) return;
                  await ref
                      .read(settingsRepositoryProvider)
                      .save(
                        settings.copyWith(
                          focusStatisticsDays: result,
                          clearFocusStatisticsStartDate: true,
                        ),
                      );
                } else {
                  await ref
                      .read(settingsRepositoryProvider)
                      .save(
                        settings.copyWith(
                          focusStatisticsDays: selected,
                          clearFocusStatisticsStartDate: true,
                        ),
                      );
                }
              },
            ),
          ),
        ),
        if (fromDate != null)
          TextButton.icon(
            onPressed: () => _pickDate(context, ref, settings),
            icon: const Icon(Icons.edit_calendar_outlined),
            label: Text('${_date(fromDate)} 起（含当天）'),
          ),
        const SizedBox(height: 8),
        Text(
          '仅调整累计次数、时长与日均的显示范围，历史记录继续保留。',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final today = AppDateUtils.dateOnly(DateTime.now());
    final initial = settings.focusStatisticsStartDate ?? today;
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1970),
      lastDate: today,
      initialDate: initial.isAfter(today) ? today : initial,
    );
    if (date == null || !context.mounted) return;
    await ref
        .read(settingsRepositoryProvider)
        .save(
          settings.copyWith(
            focusStatisticsStartDate: date,
            focusStatisticsDays: 0,
          ),
        );
  }

  static String _date(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

class _DaysDialog extends StatefulWidget {
  const _DaysDialog({required this.initialDays});
  final int initialDays;
  @override
  State<_DaysDialog> createState() => _DaysDialogState();
}

class _DaysDialogState extends State<_DaysDialog> {
  late final _input = TextEditingController(text: '${widget.initialDays}');
  String? _error;
  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('累计统计天数'),
    content: TextField(
      controller: _input,
      autofocus: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: '最近多少天（含今天）', errorText: _error),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('取消'),
      ),
      FilledButton(
        onPressed: () {
          final days = int.tryParse(_input.text.trim());
          if (days == null || days < 1 || days > 36500) {
            setState(() => _error = '请输入 1 至 36500 的整数');
            return;
          }
          Navigator.pop(context, days);
        },
        child: const Text('保存'),
      ),
    ],
  );
}
