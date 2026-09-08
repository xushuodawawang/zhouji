import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import '../providers/app_providers.dart';
import '../utils/date_time_utils.dart';

Future<void> showTimelineSettings(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => const TimelineSettingsSheet(),
    );

class TimelineSettingsSheet extends ConsumerWidget {
  const TimelineSettingsSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(appSettingsProvider).valueOrNull ?? const AppSettings();
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        Text('时间轴与配色', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const Text('默认显示全天 00:00–24:00。夜间学习可延长到次日；跨天任务会自动展开时间轴。'),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          key: ValueKey('start-${settings.timelineStartMinutes}'),
          initialValue: settings.timelineStartMinutes,
          decoration: const InputDecoration(labelText: '开始时间'),
          items: [
            for (var h = 0; h <= 12; h++)
              DropdownMenuItem(
                value: h * 60,
                child: Text(AppDateUtils.formatMinutes(h * 60)),
              ),
          ],
          onChanged: (v) {
            if (v != null) {
              ref
                  .read(settingsRepositoryProvider)
                  .save(settings.copyWith(timelineStartMinutes: v));
            }
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          key: ValueKey('end-${settings.timelineEndMinutes}'),
          initialValue: settings.timelineEndMinutes,
          decoration: const InputDecoration(labelText: '结束时间'),
          items: [
            for (var h = 18; h <= 30; h++)
              DropdownMenuItem(
                value: h * 60,
                child: Text(AppDateUtils.formatMinutes(h * 60)),
              ),
          ],
          onChanged: (v) {
            if (v != null) {
              ref
                  .read(settingsRepositoryProvider)
                  .save(settings.copyWith(timelineEndMinutes: v));
            }
          },
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('任务自动配色'),
          subtitle: const Text('优先采用分类颜色，同名任务保持相同颜色'),
          value: settings.autoColorEnabled,
          onChanged:
              (v) => ref
                  .read(settingsRepositoryProvider)
                  .save(settings.copyWith(autoColorEnabled: v)),
        ),
        TextButton(
          onPressed:
              () => ref
                  .read(settingsRepositoryProvider)
                  .save(
                    settings.copyWith(
                      timelineStartMinutes: 0,
                      timelineEndMinutes: 1440,
                    ),
                  ),
          child: const Text('恢复全天 24 小时'),
        ),
      ],
    );
  }
}
