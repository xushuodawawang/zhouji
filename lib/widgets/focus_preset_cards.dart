import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../providers/app_providers.dart';
import '../utils/app_colors.dart';

final focusPresetsProvider = StreamProvider<List<FocusPresetRow>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.focusPresets)
    ..orderBy([(t) => drift.OrderingTerm.asc(t.id)])).watch();
});

class FocusPresetCards extends ConsumerWidget {
  const FocusPresetCards({
    super.key,
    required this.onStart,
    required this.enabled,
  });
  final void Function(FocusPresetRow) onStart;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = ref.watch(focusPresetsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '常用专注',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextButton.icon(
              onPressed: () => _edit(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('新建'),
            ),
          ],
        ),
        presets.when(
          loading: () => const LinearProgressIndicator(),
          error:
              (_, __) => TextButton(
                onPressed: () => ref.invalidate(focusPresetsProvider),
                child: const Text('加载失败，重试'),
              ),
          data:
              (items) => Column(
                children: [
                  if (items.isEmpty)
                    Card(
                      child: ListTile(
                        title: const Text('创建你的第一个专注任务'),
                        subtitle: const Text('例如数学 60 分钟、英语 30 分钟；可反复使用'),
                        onTap: () => _edit(context, ref),
                      ),
                    ),
                  for (final item in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        borderRadius: BorderRadius.circular(18),
                        clipBehavior: Clip.antiAlias,
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(item.colorValue),
                                Color.lerp(
                                  Color(item.colorValue),
                                  const Color(0xFF192939),
                                  .48,
                                )!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: InkWell(
                            onLongPress: () => _edit(context, ref, item),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          item.minutes == 0
                                              ? '正向计时'
                                              : '${item.minutes} 分钟',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:
                                        enabled ? () => onStart(item) : null,
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      disabledForegroundColor: Colors.white54,
                                    ),
                                    child: const Text(
                                      '开始',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: '编辑专注任务',
                                    onPressed: () => _edit(context, ref, item),
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
        ),
      ],
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, [
    FocusPresetRow? item,
  ]) async {
    final title = TextEditingController(text: item?.title ?? '');
    final minutes = TextEditingController(
      text: '${item?.minutes == 0 ? 25 : item?.minutes ?? 60}',
    );
    var stopwatch = item?.minutes == 0;
    final form = GlobalKey<FormState>();
    final result = await showDialog<int>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text(item == null ? '新建专注任务' : '编辑专注任务'),
                  content: SingleChildScrollView(
                    child: Form(
                      key: form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: title,
                            maxLength: 60,
                            decoration: const InputDecoration(
                              labelText: '任务名称',
                              hintText: '例如：数学',
                            ),
                            validator:
                                (v) =>
                                    v == null || v.trim().isEmpty
                                        ? '请输入任务名称'
                                        : null,
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('正向计时'),
                            subtitle: const Text('从零计时，完成时手动结束'),
                            value: stopwatch,
                            onChanged: (v) => setState(() => stopwatch = v),
                          ),
                          if (!stopwatch)
                            TextFormField(
                              controller: minutes,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: '专注分钟（1–240）',
                              ),
                              validator: (v) {
                                final n = int.tryParse(v ?? '');
                                return n == null || n < 1 || n > 240
                                    ? '请输入 1 至 240'
                                    : null;
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    if (item != null)
                      TextButton(
                        onPressed: () => Navigator.pop(context, -1),
                        child: const Text('删除'),
                      ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                    FilledButton(
                      onPressed: () {
                        if (form.currentState!.validate()) {
                          Navigator.pop(context, 1);
                        }
                      },
                      child: const Text('保存'),
                    ),
                  ],
                ),
          ),
    );
    if (result != null) {
      final db = ref.read(databaseProvider);
      if (result == -1 && item != null) {
        await (db.delete(db.focusPresets)
          ..where((t) => t.id.equals(item.id))).go();
      } else {
        await db
            .into(db.focusPresets)
            .insertOnConflictUpdate(
              FocusPresetsCompanion(
                id:
                    item == null
                        ? const drift.Value.absent()
                        : drift.Value(item.id),
                title: drift.Value(title.text.trim()),
                minutes: drift.Value(stopwatch ? 0 : int.parse(minutes.text)),
                colorValue: drift.Value(
                  AppColors.automaticTaskColor(title.text.trim()),
                ),
              ),
            );
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 250));
    title.dispose();
    minutes.dispose();
  }
}
