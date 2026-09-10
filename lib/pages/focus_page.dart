import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../models/focus_session.dart';
import '../models/plan_task.dart';
import '../providers/app_providers.dart';
import '../providers/focus_timer_controller.dart';
import '../services/focus_music_service.dart';
import '../utils/date_time_utils.dart';
import '../widgets/page_heading.dart';
import '../widgets/focus_preset_cards.dart';

final _focusScrollProvider = Provider.autoDispose<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(controller.dispose);
  return controller;
});

class FocusPage extends ConsumerWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(currentMinuteProvider);
    // Only phase/control changes rebuild the form and history; seconds belong to the dial.
    ref.watch(
      focusTimerProvider.select(
        (s) => (
          s.status,
          s.phase,
          s.taskId,
          s.cycleCount,
          s.restoring,
          s.title,
          s.totalSeconds,
          s.musicPlaying,
        ),
      ),
    );
    final timer = ref.read(focusTimerProvider);
    final settings =
        ref.watch(appSettingsProvider).valueOrNull ?? const AppSettings();
    final focusPlaylist = FocusMusicService.decodePlaylist(
      settings.focusPlaylistJson,
    );
    final tasks =
        ref.watch(focusCandidateTasksProvider).valueOrNull ?? const [];
    final sessions =
        ref.watch(todayFocusSessionsProvider).valueOrNull ?? const [];
    final recommendation = _recommendedTask(tasks);
    final selectedTask =
        tasks.where((task) => task.id == timer.taskId).firstOrNull;

    return Scaffold(
      body: ListView(
        controller: ref.watch(_focusScrollProvider),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        children: [
          PageHeading(
            title: '专注',
            subtitle: '一次只做一件事，让时间更有分量',
            trailing: Chip(
              avatar: const Icon(
                Icons.local_fire_department_outlined,
                size: 18,
              ),
              label: Text('${timer.cycleCount} 个番茄'),
            ),
          ),
          const SizedBox(height: 14),
          if (!timer.isActive && !timer.isBreak) ...[
            FocusPresetCards(
              enabled: !timer.restoring,
              onStart:
                  (preset) => _startPresetFocus(
                    context,
                    ref,
                    tasks,
                    title: preset.title,
                    minutes: preset.minutes,
                  ),
            ),
            const SizedBox(height: 16),
          ],
          if (recommendation != null && !timer.isActive && !timer.isBreak)
            _RecommendationCard(
              task: recommendation,
              onStart: () {
                _startFocus(ref, recommendation, settings);
              },
            ),
          if (recommendation != null && !timer.isActive && !timer.isBreak)
            const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Column(
                children: [
                  SegmentedButton<int>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: 25, label: Text('25 + 5')),
                      ButtonSegment(value: 50, label: Text('50 + 10')),
                      ButtonSegment(value: 0, label: Text('自定义')),
                    ],
                    selected: {
                      settings.pomodoroFocusMinutes == 25 &&
                              settings.shortBreakMinutes == 5
                          ? 25
                          : settings.pomodoroFocusMinutes == 50 &&
                              settings.shortBreakMinutes == 10
                          ? 50
                          : 0,
                    },
                    onSelectionChanged:
                        timer.isActive
                            ? null
                            : (value) => _changePreset(
                              context,
                              ref,
                              value.first,
                              settings,
                            ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    initialValue: selectedTask?.id ?? 0,
                    decoration: const InputDecoration(
                      labelText: '当前专注任务',
                      prefixIcon: Icon(Icons.link),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: 0,
                        child: Text('自动使用此刻的计划'),
                      ),
                      for (final task in tasks.where((task) => !task.isAllDay))
                        DropdownMenuItem(
                          value: task.id,
                          child: Text(
                            '${task.title}  '
                            '${AppDateUtils.formatMinutes(task.startMinutes)}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged:
                        timer.isActive
                            ? null
                            : (value) {
                              final task =
                                  tasks
                                      .where((item) => item.id == value)
                                      .firstOrNull;
                              ref
                                  .read(focusTimerProvider.notifier)
                                  .selectTask(
                                    taskId: task?.id,
                                    title: task?.title ?? '',
                                    categoryId: task?.categoryId,
                                    focusMinutes:
                                        task?.focusMinutes ??
                                        settings.pomodoroFocusMinutes,
                                  );
                            },
                  ),
                  const SizedBox(height: 22),
                  const RepaintBoundary(child: _LiveTimerDial()),
                  const SizedBox(height: 18),
                  Text(
                    timer.isBreak
                        ? timer.phase == TimerPhase.longBreak
                            ? '长休息'
                            : '短休息'
                        : timer.title.isNotEmpty
                        ? timer.title
                        : selectedTask?.title ??
                            recommendation?.title ??
                            '自由专注',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _TimerActions(
                    state: timer,
                    onStart:
                        () => _startFocus(
                          ref,
                          selectedTask ??
                              _recommendedTask(
                                ref
                                        .read(focusCandidateTasksProvider)
                                        .valueOrNull ??
                                    [],
                              ),
                          settings,
                        ),
                    onPause:
                        () => ref.read(focusTimerProvider.notifier).pause(),
                    onResume:
                        () => ref.read(focusTimerProvider.notifier).resume(),
                    onComplete: () => _complete(context, ref, timer.taskId),
                    onEarlyEnd:
                        () => ref.read(focusTimerProvider.notifier).endEarly(),
                    onSkip:
                        () => ref.read(focusTimerProvider.notifier).skipBreak(),
                    onReset:
                        () => ref.read(focusTimerProvider.notifier).reset(),
                    showMusicControl:
                        settings.focusMusicEnabled &&
                        settings.focusMusicUri.isNotEmpty,
                    onToggleMusic:
                        () =>
                            ref
                                .read(focusTimerProvider.notifier)
                                .toggleMusicPlayback(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              title: const Text('计时完成提醒'),
              subtitle: const Text('时间到了，轻轻提醒你'),
              secondary: const Icon(Icons.notifications_outlined),
              value: settings.notificationEnabled,
              onChanged:
                  (value) => _setNotifications(context, ref, settings, value),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('完成专注后完成计划'),
                  subtitle: const Text('整段专注完成时，计划状态自动同步'),
                  secondary: const Icon(Icons.sync_alt_rounded),
                  value: settings.autoCompleteTaskOnFocus,
                  onChanged:
                      (value) => ref
                          .read(settingsRepositoryProvider)
                          .save(
                            settings.copyWith(autoCompleteTaskOnFocus: value),
                          ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: const Text('专注时锁定手机'),
                  subtitle: Text(
                    timer.isActive &&
                            !timer.isBreak &&
                            settings.focusLockEnabled
                        ? '正在使用系统屏幕固定，结束专注后自动解除'
                        : '开始专注时进入系统屏幕固定，减少切换应用',
                  ),
                  secondary: const Icon(Icons.phonelink_lock_rounded),
                  value: settings.focusLockEnabled,
                  onChanged:
                      (value) => ref
                          .read(settingsRepositoryProvider)
                          .save(settings.copyWith(focusLockEnabled: value)),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: const Text('番茄完成铃声'),
                  subtitle: const Text('完成一段专注时播放轻柔双音铃声'),
                  secondary: const Icon(Icons.notifications_active_outlined),
                  value: settings.completionSoundEnabled,
                  onChanged:
                      (value) => ref
                          .read(settingsRepositoryProvider)
                          .save(
                            settings.copyWith(completionSoundEnabled: value),
                          ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: const Text('专注背景音乐'),
                  subtitle: Text(
                    focusPlaylist.length > 1
                        ? '本地歌单 · ${focusPlaylist.length} 首（顺序循环）'
                        : settings.focusMusicName.isEmpty
                        ? '选择手机里的音频，专注时循环播放'
                        : settings.focusMusicName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondary: const Icon(Icons.music_note_rounded),
                  value: settings.focusMusicEnabled,
                  onChanged: (value) async {
                    if (value && settings.focusMusicUri.isEmpty) {
                      await _pickFocusMusic(context, ref, settings);
                      return;
                    }
                    await ref
                        .read(settingsRepositoryProvider)
                        .save(settings.copyWith(focusMusicEnabled: value));
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 6,
                      children: [
                        if (settings.focusMusicUri.isNotEmpty &&
                            !timer.isActive)
                          TextButton.icon(
                            onPressed:
                                () =>
                                    _previewFocusMusic(context, ref, settings),
                            icon: const Icon(Icons.play_circle_outline_rounded),
                            label: const Text('试听'),
                          ),
                        TextButton.icon(
                          onPressed:
                              () => _pickFocusMusic(context, ref, settings),
                          icon: const Icon(Icons.audio_file_outlined),
                          label: Text(
                            settings.focusMusicUri.isEmpty ? '选择音乐' : '更换音乐',
                          ),
                        ),
                        TextButton.icon(
                          onPressed:
                              () => _pickFocusPlaylist(context, ref, settings),
                          icon: const Icon(Icons.playlist_add_rounded),
                          label: const Text('导入本地歌单'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '支持一次选择多首 MP3、FLAC、AAC 等可访问音频；网易云、QQ 音乐的在线歌单需要平台授权。',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '今日专注记录',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          if (sessions.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Center(child: Text('还没有专注记录，开始第一个番茄吧')),
              ),
            )
          else
            Card(
              child: Column(
                children: [
                  for (var index = 0; index < sessions.length; index++) ...[
                    ListTile(
                      leading: Icon(
                        sessions[index].completed
                            ? Icons.check_circle_outline
                            : Icons.timelapse,
                      ),
                      title: Text(
                        sessions[index].note.isNotEmpty
                            ? sessions[index].note
                            : sessions[index].taskId == null
                            ? '临时专注'
                            : tasks
                                    .where(
                                      (task) =>
                                          task.id == sessions[index].taskId,
                                    )
                                    .firstOrNull
                                    ?.title ??
                                '关联任务',
                      ),
                      subtitle: Text(
                        '${_clock(sessions[index].startedAt)}－'
                        '${_clock(sessions[index].endedAt)}',
                      ),
                      trailing: Text('${sessions[index].actualMinutes} 分钟'),
                    ),
                    if (index != sessions.length - 1) const Divider(height: 1),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  PlanTask? _recommendedTask(List<PlanTask> tasks) {
    final now = DateTime.now();
    final candidates =
        tasks
            .where(
              (task) =>
                  !task.isAllDay &&
                  !task.isCompleted &&
                  !AppDateUtils.atMinutes(
                    task.taskDate,
                    task.startMinutes,
                  ).isAfter(now) &&
                  AppDateUtils.atMinutes(
                    task.taskDate,
                    task.endMinutes,
                  ).isAfter(now),
            )
            .toList()
          ..sort((a, b) {
            return a.startMinutes.compareTo(b.startMinutes);
          });
    return candidates.firstOrNull;
  }

  Future<void> _startPresetFocus(
    BuildContext context,
    WidgetRef ref,
    List<PlanTask> tasks, {
    required String title,
    required int minutes,
  }) async {
    final currentPlan = _recommendedTask(tasks);
    final sameCurrentTask =
        currentPlan != null &&
        _normalizedTitle(currentPlan.title) == _normalizedTitle(title);
    try {
      final taskId =
          sameCurrentTask
              ? currentPlan.id
              : await ref
                  .read(planTaskRepositoryProvider)
                  .placeFocusTask(
                    title: title,
                    startedAt: DateTime.now(),
                    plannedMinutes: minutes,
                  );
      final controller = ref.read(focusTimerProvider.notifier);
      controller.selectTask(
        taskId: taskId,
        categoryId: sameCurrentTask ? currentPlan.categoryId : null,
        focusMinutes: minutes,
        title: title,
      );
      await controller.start();
      final scroll = ref.read(_focusScrollProvider);
      if (scroll.hasClients) scroll.jumpTo(0);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  String _normalizedTitle(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  Future<void> _startFocus(
    WidgetRef ref,
    PlanTask? task,
    AppSettings settings,
  ) async {
    final controller = ref.read(focusTimerProvider.notifier);
    final current = ref.read(focusTimerProvider);
    if (!current.isActive && !current.isBreak && task != null) {
      controller.selectTask(
        taskId: task.id,
        title: task.title,
        categoryId: task.categoryId,
        focusMinutes: task.focusMinutes ?? settings.pomodoroFocusMinutes,
      );
    }
    await controller.start();
    final scroll = ref.read(_focusScrollProvider);
    if (scroll.hasClients) scroll.jumpTo(0);
  }

  Future<void> _pickFocusMusic(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final selection = await ref.read(focusMusicServiceProvider).pickAudio();
    if (selection == null) return;
    await ref
        .read(settingsRepositoryProvider)
        .save(
          settings.copyWith(
            focusMusicUri: selection.uri,
            focusMusicName: selection.name,
            focusPlaylistJson: '',
            focusMusicEnabled: true,
          ),
        );
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('已选择 ${selection.name}')));
    }
  }

  Future<void> _pickFocusPlaylist(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final playlist = await ref.read(focusMusicServiceProvider).pickPlaylist();
    if (playlist.isEmpty) return;
    await ref
        .read(settingsRepositoryProvider)
        .save(
          settings.copyWith(
            focusMusicUri: playlist.first.uri,
            focusMusicName: playlist.first.name,
            focusPlaylistJson: FocusMusicService.encodePlaylist(playlist),
            focusMusicEnabled: true,
          ),
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已导入 ${playlist.length} 首音乐，将按顺序循环播放')),
      );
    }
  }

  Future<void> _previewFocusMusic(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final started = await ref
        .read(focusMusicServiceProvider)
        .preview(settings.focusMusicUri);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(started ? '正在试听所选音乐（10 秒）' : '音乐无法播放，请重新选择文件')),
    );
  }

  Future<void> _changePreset(
    BuildContext context,
    WidgetRef ref,
    int preset,
    AppSettings settings,
  ) async {
    var focus = preset;
    var rest = preset == 25 ? 5 : 10;
    if (preset == 0) {
      final result = await _customDurationDialog(
        context,
        settings.pomodoroFocusMinutes,
        settings.shortBreakMinutes,
      );
      if (result == null) return;
      focus = result.$1;
      rest = result.$2;
    }
    final next = settings.copyWith(
      pomodoroFocusMinutes: focus,
      shortBreakMinutes: rest,
    );
    await ref.read(settingsRepositoryProvider).save(next);
    ref
        .read(focusTimerProvider.notifier)
        .configure(focusMinutes: focus, breakMinutes: rest);
  }

  Future<(int, int)?> _customDurationDialog(
    BuildContext context,
    int focus,
    int rest,
  ) async {
    final focusController = TextEditingController(text: '$focus');
    final restController = TextEditingController(text: '$rest');
    final result = await showDialog<(int, int)>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('自定义番茄时长'),
            content: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: focusController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '专注分钟'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: restController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: '休息分钟'),
                  ),
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
                  final focusValue = int.tryParse(focusController.text);
                  final restValue = int.tryParse(restController.text);
                  if (focusValue == null ||
                      restValue == null ||
                      focusValue < 1 ||
                      restValue < 1 ||
                      focusValue > 180 ||
                      restValue > 60) {
                    return;
                  }
                  Navigator.pop(context, (focusValue, restValue));
                },
                child: const Text('保存'),
              ),
            ],
          ),
    );
    focusController.dispose();
    restController.dispose();
    return result;
  }

  Future<void> _setNotifications(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
    bool enabled,
  ) async {
    var value = enabled;
    if (enabled) {
      value = await ref.read(notificationServiceProvider).requestPermission();
      if (!value && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('未获得通知权限，计时功能仍可正常使用')));
      }
    }
    await ref
        .read(settingsRepositoryProvider)
        .save(settings.copyWith(notificationEnabled: value));
  }

  Future<void> _complete(
    BuildContext context,
    WidgetRef ref,
    int? taskId,
  ) async {
    await ref.read(focusTimerProvider.notifier).completeCurrent();
    if (!context.mounted) return;
    if (ref.read(appSettingsProvider).valueOrNull?.autoCompleteTaskOnFocus ==
        true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(taskId == null ? '已保存专注记录' : '已保存记录并完成计划')),
      );
      return;
    }
    final markDone = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('专注完成'),
            content: Text(
              taskId == null ? '已保存本次专注记录。' : '已保存记录，要同时标记关联任务完成吗？',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(taskId == null ? '好的' : '稍后'),
              ),
              if (taskId != null)
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('标记完成'),
                ),
            ],
          ),
    );
    if (markDone == true && taskId != null) {
      await ref.read(planTaskRepositoryProvider).setCompleted(taskId, true);
    }
  }

  String _clock(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.task, required this.onStart});

  final PlanTask task;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 6,
          height: 38,
          decoration: BoxDecoration(
            color: Color(task.colorValue),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text('此刻计划：${task.title}'),
        subtitle: Text(
          '${AppDateUtils.formatMinutes(task.startMinutes)}－'
          '${AppDateUtils.formatMinutes(task.endMinutes)}',
        ),
        trailing: FilledButton(onPressed: onStart, child: const Text('开始')),
      ),
    );
  }
}

class _LiveTimerDial extends ConsumerWidget {
  const _LiveTimerDial();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(bottomNavigationIndexProvider) == 1;
    ref.watch(focusTimerProvider.select((state) => visible ? state : null));
    var state = ref.read(focusTimerProvider);
    if (!state.isActive &&
        !state.isBreak &&
        state.taskId == null &&
        state.title.isEmpty) {
      final task = const FocusPage()._recommendedTask(
        ref.watch(focusCandidateTasksProvider).valueOrNull ?? [],
      );
      if (task != null) {
        final minutes =
            task.focusMinutes ??
            ref.watch(appSettingsProvider).valueOrNull?.pomodoroFocusMinutes ??
            25;
        state = state.copyWith(
          totalSeconds: minutes * 60,
          remainingSeconds: minutes * 60,
        );
      }
    }
    return _TimerDial(state: state);
  }
}

class _TimerDial extends StatelessWidget {
  const _TimerDial({required this.state});

  final FocusTimerState state;

  @override
  Widget build(BuildContext context) {
    final minutes = state.remainingSeconds ~/ 60;
    final seconds = state.remainingSeconds % 60;
    return SizedBox.square(
      dimension: 228,
      child: CustomPaint(
        painter: _TimerPainter(
          progress: state.progress,
          background: Theme.of(context).colorScheme.surfaceContainerHighest,
          foreground:
              state.isBreak
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$minutes:${seconds.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: -2,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Text(switch (state.status) {
                FocusTimerStatus.idle => '准备开始',
                FocusTimerStatus.running => '进行中',
                FocusTimerStatus.paused => '已暂停',
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerActions extends StatelessWidget {
  const _TimerActions({
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
    required this.onEarlyEnd,
    required this.onSkip,
    required this.onReset,
    required this.showMusicControl,
    required this.onToggleMusic,
  });

  final FocusTimerState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onComplete;
  final VoidCallback onEarlyEnd;
  final VoidCallback onSkip;
  final VoidCallback onReset;
  final bool showMusicControl;
  final VoidCallback onToggleMusic;

  @override
  Widget build(BuildContext context) {
    if (state.restoring) {
      return const CircularProgressIndicator();
    }
    if (state.status == FocusTimerStatus.idle) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: [
          FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow),
            label: Text(state.isBreak ? '开始休息' : '开始专注'),
          ),
          if (state.isBreak)
            TextButton(onPressed: onSkip, child: const Text('跳过休息')),
        ],
      );
    }
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.tonalIcon(
          onPressed:
              state.status == FocusTimerStatus.running ? onPause : onResume,
          icon: Icon(
            state.status == FocusTimerStatus.running
                ? Icons.pause
                : Icons.play_arrow,
          ),
          label: Text(state.status == FocusTimerStatus.running ? '暂停' : '继续'),
        ),
        if (state.isBreak)
          OutlinedButton(onPressed: onSkip, child: const Text('跳过休息'))
        else
          FilledButton(onPressed: onComplete, child: const Text('完成当前番茄')),
        if (!state.isBreak && showMusicControl)
          OutlinedButton.icon(
            onPressed: onToggleMusic,
            icon: Icon(
              state.musicPlaying
                  ? Icons.music_off_rounded
                  : Icons.music_note_rounded,
            ),
            label: Text(state.musicPlaying ? '暂停音乐' : '播放音乐'),
          ),
        TextButton(onPressed: onEarlyEnd, child: const Text('提前结束')),
        IconButton(
          tooltip: '重置计时',
          onPressed: onReset,
          icon: const Icon(Icons.restart_alt),
        ),
      ],
    );
  }
}

class _TimerPainter extends CustomPainter {
  const _TimerPainter({
    required this.progress,
    required this.background,
    required this.foreground,
  });

  final double progress;
  final Color background;
  final Color foreground;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawArc(
      rect.deflate(8),
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = background
        ..style = PaintingStyle.stroke
        ..strokeWidth = 11,
    );
    canvas.drawArc(
      rect.deflate(8),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      Paint()
        ..color = foreground
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 11,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.background != background ||
      oldDelegate.foreground != foreground;
}
