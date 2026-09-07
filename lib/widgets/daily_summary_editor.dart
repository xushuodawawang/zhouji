import 'dart:async';

import 'package:flutter/material.dart';

class DailySummaryEditor extends StatefulWidget {
  const DailySummaryEditor({
    super.key,
    required this.initialContent,
    required this.onSave,
  });

  final String initialContent;
  final Future<void> Function(String content) onSave;

  @override
  State<DailySummaryEditor> createState() => _DailySummaryEditorState();
}

class _DailySummaryEditorState extends State<DailySummaryEditor> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;
  String _lastSaved = '';
  bool _saving = false;
  bool _saveFailed = false;

  @override
  void initState() {
    super.initState();
    _lastSaved = widget.initialContent;
    _controller = TextEditingController(text: widget.initialContent);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant DailySummaryEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus &&
        widget.initialContent != _controller.text &&
        widget.initialContent != oldWidget.initialContent) {
      _controller.text = widget.initialContent;
      _lastSaved = widget.initialContent;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (_controller.text != _lastSaved) {
      unawaited(widget.onSave(_controller.text));
    }
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_stories_outlined, size: 20),
                const SizedBox(width: 8),
                Text('今日总结', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Text(
                    _saveFailed
                        ? '保存失败'
                        : _saving
                        ? '保存中…'
                        : '已自动保存',
                    key: ValueKey((_saving, _saveFailed)),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color:
                          _saveFailed
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              minLines: 5,
              maxLines: 9,
              maxLength: 2000,
              onChanged: _scheduleSave,
              decoration: const InputDecoration(
                hintText: '今天完成了什么？\n遇到了哪些问题？\n明天需要继续做什么？',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scheduleSave(String value) {
    _debounce?.cancel();
    setState(() {
      _saving = true;
      _saveFailed = false;
    });
    _debounce = Timer(const Duration(milliseconds: 700), _save);
  }

  Future<void> _save() async {
    final value = _controller.text;
    try {
      await widget.onSave(value);
      if (!mounted) return;
      setState(() {
        _lastSaved = value;
        _saving = false;
        _saveFailed = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _saveFailed = true;
      });
    }
  }
}
