// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlanTasksTable extends PlanTasks
    with TableInfo<$PlanTasksTable, PlanTaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskDateMeta = const VerificationMeta(
    'taskDate',
  );
  @override
  late final GeneratedColumn<DateTime> taskDate = GeneratedColumn<DateTime>(
    'task_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isLockedMeta = const VerificationMeta(
    'isLocked',
  );
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
    'is_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isAllDayMeta = const VerificationMeta(
    'isAllDay',
  );
  @override
  late final GeneratedColumn<bool> isAllDay = GeneratedColumn<bool>(
    'is_all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedDurationMinutesMeta =
      const VerificationMeta('plannedDurationMinutes');
  @override
  late final GeneratedColumn<int> plannedDurationMinutes = GeneratedColumn<int>(
    'planned_duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _focusMinutesMeta = const VerificationMeta(
    'focusMinutes',
  );
  @override
  late final GeneratedColumn<int> focusMinutes = GeneratedColumn<int>(
    'focus_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    taskDate,
    startMinutes,
    endMinutes,
    colorValue,
    note,
    isCompleted,
    createdAt,
    updatedAt,
    categoryId,
    isLocked,
    isAllDay,
    sortOrder,
    completedAt,
    plannedDurationMinutes,
    focusMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanTaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('task_date')) {
      context.handle(
        _taskDateMeta,
        taskDate.isAcceptableOrUnknown(data['task_date']!, _taskDateMeta),
      );
    } else if (isInserting) {
      context.missing(_taskDateMeta);
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinutesMeta);
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinutesMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('is_locked')) {
      context.handle(
        _isLockedMeta,
        isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta),
      );
    }
    if (data.containsKey('is_all_day')) {
      context.handle(
        _isAllDayMeta,
        isAllDay.isAcceptableOrUnknown(data['is_all_day']!, _isAllDayMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('planned_duration_minutes')) {
      context.handle(
        _plannedDurationMinutesMeta,
        plannedDurationMinutes.isAcceptableOrUnknown(
          data['planned_duration_minutes']!,
          _plannedDurationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('focus_minutes')) {
      context.handle(
        _focusMinutesMeta,
        focusMinutes.isAcceptableOrUnknown(
          data['focus_minutes']!,
          _focusMinutesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanTaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanTaskRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      taskDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}task_date'],
          )!,
      startMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}start_minutes'],
          )!,
      endMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}end_minutes'],
          )!,
      colorValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}color_value'],
          )!,
      note:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}note'],
          )!,
      isCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_completed'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      isLocked:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_locked'],
          )!,
      isAllDay:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_all_day'],
          )!,
      sortOrder:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sort_order'],
          )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      plannedDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_duration_minutes'],
      ),
      focusMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_minutes'],
      ),
    );
  }

  @override
  $PlanTasksTable createAlias(String alias) {
    return $PlanTasksTable(attachedDatabase, alias);
  }
}

class PlanTaskRow extends DataClass implements Insertable<PlanTaskRow> {
  final int id;
  final String title;
  final DateTime taskDate;
  final int startMinutes;
  final int endMinutes;
  final int colorValue;
  final String note;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? categoryId;
  final bool isLocked;
  final bool isAllDay;
  final int sortOrder;
  final DateTime? completedAt;
  final int? plannedDurationMinutes;
  final int? focusMinutes;
  const PlanTaskRow({
    required this.id,
    required this.title,
    required this.taskDate,
    required this.startMinutes,
    required this.endMinutes,
    required this.colorValue,
    required this.note,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    this.categoryId,
    required this.isLocked,
    required this.isAllDay,
    required this.sortOrder,
    this.completedAt,
    this.plannedDurationMinutes,
    this.focusMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['task_date'] = Variable<DateTime>(taskDate);
    map['start_minutes'] = Variable<int>(startMinutes);
    map['end_minutes'] = Variable<int>(endMinutes);
    map['color_value'] = Variable<int>(colorValue);
    map['note'] = Variable<String>(note);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['is_locked'] = Variable<bool>(isLocked);
    map['is_all_day'] = Variable<bool>(isAllDay);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || plannedDurationMinutes != null) {
      map['planned_duration_minutes'] = Variable<int>(plannedDurationMinutes);
    }
    if (!nullToAbsent || focusMinutes != null) {
      map['focus_minutes'] = Variable<int>(focusMinutes);
    }
    return map;
  }

  PlanTasksCompanion toCompanion(bool nullToAbsent) {
    return PlanTasksCompanion(
      id: Value(id),
      title: Value(title),
      taskDate: Value(taskDate),
      startMinutes: Value(startMinutes),
      endMinutes: Value(endMinutes),
      colorValue: Value(colorValue),
      note: Value(note),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      categoryId:
          categoryId == null && nullToAbsent
              ? const Value.absent()
              : Value(categoryId),
      isLocked: Value(isLocked),
      isAllDay: Value(isAllDay),
      sortOrder: Value(sortOrder),
      completedAt:
          completedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(completedAt),
      plannedDurationMinutes:
          plannedDurationMinutes == null && nullToAbsent
              ? const Value.absent()
              : Value(plannedDurationMinutes),
      focusMinutes:
          focusMinutes == null && nullToAbsent
              ? const Value.absent()
              : Value(focusMinutes),
    );
  }

  factory PlanTaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanTaskRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      taskDate: serializer.fromJson<DateTime>(json['taskDate']),
      startMinutes: serializer.fromJson<int>(json['startMinutes']),
      endMinutes: serializer.fromJson<int>(json['endMinutes']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      note: serializer.fromJson<String>(json['note']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
      isAllDay: serializer.fromJson<bool>(json['isAllDay']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      plannedDurationMinutes: serializer.fromJson<int?>(
        json['plannedDurationMinutes'],
      ),
      focusMinutes: serializer.fromJson<int?>(json['focusMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'taskDate': serializer.toJson<DateTime>(taskDate),
      'startMinutes': serializer.toJson<int>(startMinutes),
      'endMinutes': serializer.toJson<int>(endMinutes),
      'colorValue': serializer.toJson<int>(colorValue),
      'note': serializer.toJson<String>(note),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'categoryId': serializer.toJson<int?>(categoryId),
      'isLocked': serializer.toJson<bool>(isLocked),
      'isAllDay': serializer.toJson<bool>(isAllDay),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'plannedDurationMinutes': serializer.toJson<int?>(plannedDurationMinutes),
      'focusMinutes': serializer.toJson<int?>(focusMinutes),
    };
  }

  PlanTaskRow copyWith({
    int? id,
    String? title,
    DateTime? taskDate,
    int? startMinutes,
    int? endMinutes,
    int? colorValue,
    String? note,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<int?> categoryId = const Value.absent(),
    bool? isLocked,
    bool? isAllDay,
    int? sortOrder,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> plannedDurationMinutes = const Value.absent(),
    Value<int?> focusMinutes = const Value.absent(),
  }) => PlanTaskRow(
    id: id ?? this.id,
    title: title ?? this.title,
    taskDate: taskDate ?? this.taskDate,
    startMinutes: startMinutes ?? this.startMinutes,
    endMinutes: endMinutes ?? this.endMinutes,
    colorValue: colorValue ?? this.colorValue,
    note: note ?? this.note,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    isLocked: isLocked ?? this.isLocked,
    isAllDay: isAllDay ?? this.isAllDay,
    sortOrder: sortOrder ?? this.sortOrder,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    plannedDurationMinutes:
        plannedDurationMinutes.present
            ? plannedDurationMinutes.value
            : this.plannedDurationMinutes,
    focusMinutes: focusMinutes.present ? focusMinutes.value : this.focusMinutes,
  );
  PlanTaskRow copyWithCompanion(PlanTasksCompanion data) {
    return PlanTaskRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      taskDate: data.taskDate.present ? data.taskDate.value : this.taskDate,
      startMinutes:
          data.startMinutes.present
              ? data.startMinutes.value
              : this.startMinutes,
      endMinutes:
          data.endMinutes.present ? data.endMinutes.value : this.endMinutes,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      note: data.note.present ? data.note.value : this.note,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
      isAllDay: data.isAllDay.present ? data.isAllDay.value : this.isAllDay,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      plannedDurationMinutes:
          data.plannedDurationMinutes.present
              ? data.plannedDurationMinutes.value
              : this.plannedDurationMinutes,
      focusMinutes:
          data.focusMinutes.present
              ? data.focusMinutes.value
              : this.focusMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanTaskRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('taskDate: $taskDate, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('colorValue: $colorValue, ')
          ..write('note: $note, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('categoryId: $categoryId, ')
          ..write('isLocked: $isLocked, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('completedAt: $completedAt, ')
          ..write('plannedDurationMinutes: $plannedDurationMinutes, ')
          ..write('focusMinutes: $focusMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    taskDate,
    startMinutes,
    endMinutes,
    colorValue,
    note,
    isCompleted,
    createdAt,
    updatedAt,
    categoryId,
    isLocked,
    isAllDay,
    sortOrder,
    completedAt,
    plannedDurationMinutes,
    focusMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanTaskRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.taskDate == this.taskDate &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.colorValue == this.colorValue &&
          other.note == this.note &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.categoryId == this.categoryId &&
          other.isLocked == this.isLocked &&
          other.isAllDay == this.isAllDay &&
          other.sortOrder == this.sortOrder &&
          other.completedAt == this.completedAt &&
          other.plannedDurationMinutes == this.plannedDurationMinutes &&
          other.focusMinutes == this.focusMinutes);
}

class PlanTasksCompanion extends UpdateCompanion<PlanTaskRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> taskDate;
  final Value<int> startMinutes;
  final Value<int> endMinutes;
  final Value<int> colorValue;
  final Value<String> note;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> categoryId;
  final Value<bool> isLocked;
  final Value<bool> isAllDay;
  final Value<int> sortOrder;
  final Value<DateTime?> completedAt;
  final Value<int?> plannedDurationMinutes;
  final Value<int?> focusMinutes;
  const PlanTasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.taskDate = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.note = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.plannedDurationMinutes = const Value.absent(),
    this.focusMinutes = const Value.absent(),
  });
  PlanTasksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime taskDate,
    required int startMinutes,
    required int endMinutes,
    required int colorValue,
    this.note = const Value.absent(),
    this.isCompleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.categoryId = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.plannedDurationMinutes = const Value.absent(),
    this.focusMinutes = const Value.absent(),
  }) : title = Value(title),
       taskDate = Value(taskDate),
       startMinutes = Value(startMinutes),
       endMinutes = Value(endMinutes),
       colorValue = Value(colorValue),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PlanTaskRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? taskDate,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<int>? colorValue,
    Expression<String>? note,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? categoryId,
    Expression<bool>? isLocked,
    Expression<bool>? isAllDay,
    Expression<int>? sortOrder,
    Expression<DateTime>? completedAt,
    Expression<int>? plannedDurationMinutes,
    Expression<int>? focusMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (taskDate != null) 'task_date': taskDate,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (colorValue != null) 'color_value': colorValue,
      if (note != null) 'note': note,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (categoryId != null) 'category_id': categoryId,
      if (isLocked != null) 'is_locked': isLocked,
      if (isAllDay != null) 'is_all_day': isAllDay,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (completedAt != null) 'completed_at': completedAt,
      if (plannedDurationMinutes != null)
        'planned_duration_minutes': plannedDurationMinutes,
      if (focusMinutes != null) 'focus_minutes': focusMinutes,
    });
  }

  PlanTasksCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? taskDate,
    Value<int>? startMinutes,
    Value<int>? endMinutes,
    Value<int>? colorValue,
    Value<String>? note,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int?>? categoryId,
    Value<bool>? isLocked,
    Value<bool>? isAllDay,
    Value<int>? sortOrder,
    Value<DateTime?>? completedAt,
    Value<int?>? plannedDurationMinutes,
    Value<int?>? focusMinutes,
  }) {
    return PlanTasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      taskDate: taskDate ?? this.taskDate,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      colorValue: colorValue ?? this.colorValue,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryId: categoryId ?? this.categoryId,
      isLocked: isLocked ?? this.isLocked,
      isAllDay: isAllDay ?? this.isAllDay,
      sortOrder: sortOrder ?? this.sortOrder,
      completedAt: completedAt ?? this.completedAt,
      plannedDurationMinutes:
          plannedDurationMinutes ?? this.plannedDurationMinutes,
      focusMinutes: focusMinutes ?? this.focusMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (taskDate.present) {
      map['task_date'] = Variable<DateTime>(taskDate.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (isAllDay.present) {
      map['is_all_day'] = Variable<bool>(isAllDay.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (plannedDurationMinutes.present) {
      map['planned_duration_minutes'] = Variable<int>(
        plannedDurationMinutes.value,
      );
    }
    if (focusMinutes.present) {
      map['focus_minutes'] = Variable<int>(focusMinutes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanTasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('taskDate: $taskDate, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('colorValue: $colorValue, ')
          ..write('note: $note, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('categoryId: $categoryId, ')
          ..write('isLocked: $isLocked, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('completedAt: $completedAt, ')
          ..write('plannedDurationMinutes: $plannedDurationMinutes, ')
          ..write('focusMinutes: $focusMinutes')
          ..write(')'))
        .toString();
  }
}

class $ActivityRecordsTable extends ActivityRecords
    with TableInfo<$ActivityRecordsTable, ActivityRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recordDateMeta = const VerificationMeta(
    'recordDate',
  );
  @override
  late final GeneratedColumn<DateTime> recordDate = GeneratedColumn<DateTime>(
    'record_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recordDate,
    title,
    startMinutes,
    endMinutes,
    durationMinutes,
    note,
    isCompleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_date')) {
      context.handle(
        _recordDateMeta,
        recordDate.isAcceptableOrUnknown(data['record_date']!, _recordDateMeta),
      );
    } else if (isInserting) {
      context.missing(_recordDateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityRecordRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      recordDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}record_date'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      ),
      endMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes'],
      ),
      durationMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}duration_minutes'],
          )!,
      note:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}note'],
          )!,
      isCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_completed'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $ActivityRecordsTable createAlias(String alias) {
    return $ActivityRecordsTable(attachedDatabase, alias);
  }
}

class ActivityRecordRow extends DataClass
    implements Insertable<ActivityRecordRow> {
  final int id;
  final DateTime recordDate;
  final String title;
  final int? startMinutes;
  final int? endMinutes;
  final int durationMinutes;
  final String note;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ActivityRecordRow({
    required this.id,
    required this.recordDate,
    required this.title,
    this.startMinutes,
    this.endMinutes,
    required this.durationMinutes,
    required this.note,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_date'] = Variable<DateTime>(recordDate);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || startMinutes != null) {
      map['start_minutes'] = Variable<int>(startMinutes);
    }
    if (!nullToAbsent || endMinutes != null) {
      map['end_minutes'] = Variable<int>(endMinutes);
    }
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['note'] = Variable<String>(note);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ActivityRecordsCompanion toCompanion(bool nullToAbsent) {
    return ActivityRecordsCompanion(
      id: Value(id),
      recordDate: Value(recordDate),
      title: Value(title),
      startMinutes:
          startMinutes == null && nullToAbsent
              ? const Value.absent()
              : Value(startMinutes),
      endMinutes:
          endMinutes == null && nullToAbsent
              ? const Value.absent()
              : Value(endMinutes),
      durationMinutes: Value(durationMinutes),
      note: Value(note),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActivityRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityRecordRow(
      id: serializer.fromJson<int>(json['id']),
      recordDate: serializer.fromJson<DateTime>(json['recordDate']),
      title: serializer.fromJson<String>(json['title']),
      startMinutes: serializer.fromJson<int?>(json['startMinutes']),
      endMinutes: serializer.fromJson<int?>(json['endMinutes']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      note: serializer.fromJson<String>(json['note']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordDate': serializer.toJson<DateTime>(recordDate),
      'title': serializer.toJson<String>(title),
      'startMinutes': serializer.toJson<int?>(startMinutes),
      'endMinutes': serializer.toJson<int?>(endMinutes),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'note': serializer.toJson<String>(note),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ActivityRecordRow copyWith({
    int? id,
    DateTime? recordDate,
    String? title,
    Value<int?> startMinutes = const Value.absent(),
    Value<int?> endMinutes = const Value.absent(),
    int? durationMinutes,
    String? note,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ActivityRecordRow(
    id: id ?? this.id,
    recordDate: recordDate ?? this.recordDate,
    title: title ?? this.title,
    startMinutes: startMinutes.present ? startMinutes.value : this.startMinutes,
    endMinutes: endMinutes.present ? endMinutes.value : this.endMinutes,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    note: note ?? this.note,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ActivityRecordRow copyWithCompanion(ActivityRecordsCompanion data) {
    return ActivityRecordRow(
      id: data.id.present ? data.id.value : this.id,
      recordDate:
          data.recordDate.present ? data.recordDate.value : this.recordDate,
      title: data.title.present ? data.title.value : this.title,
      startMinutes:
          data.startMinutes.present
              ? data.startMinutes.value
              : this.startMinutes,
      endMinutes:
          data.endMinutes.present ? data.endMinutes.value : this.endMinutes,
      durationMinutes:
          data.durationMinutes.present
              ? data.durationMinutes.value
              : this.durationMinutes,
      note: data.note.present ? data.note.value : this.note,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRecordRow(')
          ..write('id: $id, ')
          ..write('recordDate: $recordDate, ')
          ..write('title: $title, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('note: $note, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recordDate,
    title,
    startMinutes,
    endMinutes,
    durationMinutes,
    note,
    isCompleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityRecordRow &&
          other.id == this.id &&
          other.recordDate == this.recordDate &&
          other.title == this.title &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.durationMinutes == this.durationMinutes &&
          other.note == this.note &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ActivityRecordsCompanion extends UpdateCompanion<ActivityRecordRow> {
  final Value<int> id;
  final Value<DateTime> recordDate;
  final Value<String> title;
  final Value<int?> startMinutes;
  final Value<int?> endMinutes;
  final Value<int> durationMinutes;
  final Value<String> note;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ActivityRecordsCompanion({
    this.id = const Value.absent(),
    this.recordDate = const Value.absent(),
    this.title = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.note = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ActivityRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime recordDate,
    required String title,
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    required int durationMinutes,
    this.note = const Value.absent(),
    this.isCompleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : recordDate = Value(recordDate),
       title = Value(title),
       durationMinutes = Value(durationMinutes),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActivityRecordRow> custom({
    Expression<int>? id,
    Expression<DateTime>? recordDate,
    Expression<String>? title,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<int>? durationMinutes,
    Expression<String>? note,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordDate != null) 'record_date': recordDate,
      if (title != null) 'title': title,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (note != null) 'note': note,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ActivityRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? recordDate,
    Value<String>? title,
    Value<int?>? startMinutes,
    Value<int?>? endMinutes,
    Value<int>? durationMinutes,
    Value<String>? note,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ActivityRecordsCompanion(
      id: id ?? this.id,
      recordDate: recordDate ?? this.recordDate,
      title: title ?? this.title,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordDate.present) {
      map['record_date'] = Variable<DateTime>(recordDate.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRecordsCompanion(')
          ..write('id: $id, ')
          ..write('recordDate: $recordDate, ')
          ..write('title: $title, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('note: $note, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailySummariesTable extends DailySummaries
    with TableInfo<$DailySummariesTable, DailySummaryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailySummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _summaryDateMeta = const VerificationMeta(
    'summaryDate',
  );
  @override
  late final GeneratedColumn<DateTime> summaryDate = GeneratedColumn<DateTime>(
    'summary_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    summaryDate,
    content,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailySummaryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('summary_date')) {
      context.handle(
        _summaryDateMeta,
        summaryDate.isAcceptableOrUnknown(
          data['summary_date']!,
          _summaryDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_summaryDateMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailySummaryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailySummaryRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      summaryDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}summary_date'],
          )!,
      content:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}content'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $DailySummariesTable createAlias(String alias) {
    return $DailySummariesTable(attachedDatabase, alias);
  }
}

class DailySummaryRow extends DataClass implements Insertable<DailySummaryRow> {
  final int id;
  final DateTime summaryDate;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailySummaryRow({
    required this.id,
    required this.summaryDate,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['summary_date'] = Variable<DateTime>(summaryDate);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailySummariesCompanion toCompanion(bool nullToAbsent) {
    return DailySummariesCompanion(
      id: Value(id),
      summaryDate: Value(summaryDate),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailySummaryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailySummaryRow(
      id: serializer.fromJson<int>(json['id']),
      summaryDate: serializer.fromJson<DateTime>(json['summaryDate']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'summaryDate': serializer.toJson<DateTime>(summaryDate),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailySummaryRow copyWith({
    int? id,
    DateTime? summaryDate,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailySummaryRow(
    id: id ?? this.id,
    summaryDate: summaryDate ?? this.summaryDate,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailySummaryRow copyWithCompanion(DailySummariesCompanion data) {
    return DailySummaryRow(
      id: data.id.present ? data.id.value : this.id,
      summaryDate:
          data.summaryDate.present ? data.summaryDate.value : this.summaryDate,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailySummaryRow(')
          ..write('id: $id, ')
          ..write('summaryDate: $summaryDate, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, summaryDate, content, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailySummaryRow &&
          other.id == this.id &&
          other.summaryDate == this.summaryDate &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailySummariesCompanion extends UpdateCompanion<DailySummaryRow> {
  final Value<int> id;
  final Value<DateTime> summaryDate;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DailySummariesCompanion({
    this.id = const Value.absent(),
    this.summaryDate = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailySummariesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime summaryDate,
    this.content = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : summaryDate = Value(summaryDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DailySummaryRow> custom({
    Expression<int>? id,
    Expression<DateTime>? summaryDate,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (summaryDate != null) 'summary_date': summaryDate,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailySummariesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? summaryDate,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DailySummariesCompanion(
      id: id ?? this.id,
      summaryDate: summaryDate ?? this.summaryDate,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (summaryDate.present) {
      map['summary_date'] = Variable<DateTime>(summaryDate.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailySummariesCompanion(')
          ..write('id: $id, ')
          ..write('summaryDate: $summaryDate, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TaskCategoriesTable extends TaskCategories
    with TableInfo<$TaskCategoriesTable, TaskCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    colorValue,
    isDefault,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskCategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCategoryRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      colorValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}color_value'],
          )!,
      isDefault:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_default'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $TaskCategoriesTable createAlias(String alias) {
    return $TaskCategoriesTable(attachedDatabase, alias);
  }
}

class TaskCategoryRow extends DataClass implements Insertable<TaskCategoryRow> {
  final int id;
  final String name;
  final int colorValue;
  final bool isDefault;
  final DateTime createdAt;
  const TaskCategoryRow({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.isDefault,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color_value'] = Variable<int>(colorValue);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaskCategoriesCompanion toCompanion(bool nullToAbsent) {
    return TaskCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      colorValue: Value(colorValue),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
    );
  }

  factory TaskCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCategoryRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int>(colorValue),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaskCategoryRow copyWith({
    int? id,
    String? name,
    int? colorValue,
    bool? isDefault,
    DateTime? createdAt,
  }) => TaskCategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    colorValue: colorValue ?? this.colorValue,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
  );
  TaskCategoryRow copyWithCompanion(TaskCategoriesCompanion data) {
    return TaskCategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorValue, isDefault, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorValue == this.colorValue &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt);
}

class TaskCategoriesCompanion extends UpdateCompanion<TaskCategoryRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> colorValue;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  const TaskCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TaskCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int colorValue,
    this.isDefault = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       colorValue = Value(colorValue),
       createdAt = Value(createdAt);
  static Insertable<TaskCategoryRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TaskCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? colorValue,
    Value<bool>? isDefault,
    Value<DateTime>? createdAt,
  }) {
    return TaskCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionDateMeta = const VerificationMeta(
    'sessionDate',
  );
  @override
  late final GeneratedColumn<DateTime> sessionDate = GeneratedColumn<DateTime>(
    'session_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedMinutesMeta = const VerificationMeta(
    'plannedMinutes',
  );
  @override
  late final GeneratedColumn<int> plannedMinutes = GeneratedColumn<int>(
    'planned_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualMinutesMeta = const VerificationMeta(
    'actualMinutes',
  );
  @override
  late final GeneratedColumn<int> actualMinutes = GeneratedColumn<int>(
    'actual_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionDate,
    startedAt,
    endedAt,
    plannedMinutes,
    actualMinutes,
    mode,
    completed,
    taskId,
    categoryId,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_date')) {
      context.handle(
        _sessionDateMeta,
        sessionDate.isAcceptableOrUnknown(
          data['session_date']!,
          _sessionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionDateMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('planned_minutes')) {
      context.handle(
        _plannedMinutesMeta,
        plannedMinutes.isAcceptableOrUnknown(
          data['planned_minutes']!,
          _plannedMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedMinutesMeta);
    }
    if (data.containsKey('actual_minutes')) {
      context.handle(
        _actualMinutesMeta,
        actualMinutes.isAcceptableOrUnknown(
          data['actual_minutes']!,
          _actualMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualMinutesMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSessionRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      sessionDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}session_date'],
          )!,
      startedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}started_at'],
          )!,
      endedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}ended_at'],
          )!,
      plannedMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}planned_minutes'],
          )!,
      actualMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}actual_minutes'],
          )!,
      mode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}mode'],
          )!,
      completed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}completed'],
          )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      note:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}note'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSessionRow extends DataClass implements Insertable<FocusSessionRow> {
  final int id;
  final DateTime sessionDate;
  final DateTime startedAt;
  final DateTime endedAt;
  final int plannedMinutes;
  final int actualMinutes;
  final String mode;
  final bool completed;
  final int? taskId;
  final int? categoryId;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FocusSessionRow({
    required this.id,
    required this.sessionDate,
    required this.startedAt,
    required this.endedAt,
    required this.plannedMinutes,
    required this.actualMinutes,
    required this.mode,
    required this.completed,
    this.taskId,
    this.categoryId,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_date'] = Variable<DateTime>(sessionDate);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['planned_minutes'] = Variable<int>(plannedMinutes);
    map['actual_minutes'] = Variable<int>(actualMinutes);
    map['mode'] = Variable<String>(mode);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<int>(taskId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      sessionDate: Value(sessionDate),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      plannedMinutes: Value(plannedMinutes),
      actualMinutes: Value(actualMinutes),
      mode: Value(mode),
      completed: Value(completed),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
      categoryId:
          categoryId == null && nullToAbsent
              ? const Value.absent()
              : Value(categoryId),
      note: Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FocusSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSessionRow(
      id: serializer.fromJson<int>(json['id']),
      sessionDate: serializer.fromJson<DateTime>(json['sessionDate']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      plannedMinutes: serializer.fromJson<int>(json['plannedMinutes']),
      actualMinutes: serializer.fromJson<int>(json['actualMinutes']),
      mode: serializer.fromJson<String>(json['mode']),
      completed: serializer.fromJson<bool>(json['completed']),
      taskId: serializer.fromJson<int?>(json['taskId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionDate': serializer.toJson<DateTime>(sessionDate),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'plannedMinutes': serializer.toJson<int>(plannedMinutes),
      'actualMinutes': serializer.toJson<int>(actualMinutes),
      'mode': serializer.toJson<String>(mode),
      'completed': serializer.toJson<bool>(completed),
      'taskId': serializer.toJson<int?>(taskId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FocusSessionRow copyWith({
    int? id,
    DateTime? sessionDate,
    DateTime? startedAt,
    DateTime? endedAt,
    int? plannedMinutes,
    int? actualMinutes,
    String? mode,
    bool? completed,
    Value<int?> taskId = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FocusSessionRow(
    id: id ?? this.id,
    sessionDate: sessionDate ?? this.sessionDate,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    plannedMinutes: plannedMinutes ?? this.plannedMinutes,
    actualMinutes: actualMinutes ?? this.actualMinutes,
    mode: mode ?? this.mode,
    completed: completed ?? this.completed,
    taskId: taskId.present ? taskId.value : this.taskId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FocusSessionRow copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSessionRow(
      id: data.id.present ? data.id.value : this.id,
      sessionDate:
          data.sessionDate.present ? data.sessionDate.value : this.sessionDate,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      plannedMinutes:
          data.plannedMinutes.present
              ? data.plannedMinutes.value
              : this.plannedMinutes,
      actualMinutes:
          data.actualMinutes.present
              ? data.actualMinutes.value
              : this.actualMinutes,
      mode: data.mode.present ? data.mode.value : this.mode,
      completed: data.completed.present ? data.completed.value : this.completed,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionRow(')
          ..write('id: $id, ')
          ..write('sessionDate: $sessionDate, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('actualMinutes: $actualMinutes, ')
          ..write('mode: $mode, ')
          ..write('completed: $completed, ')
          ..write('taskId: $taskId, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionDate,
    startedAt,
    endedAt,
    plannedMinutes,
    actualMinutes,
    mode,
    completed,
    taskId,
    categoryId,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSessionRow &&
          other.id == this.id &&
          other.sessionDate == this.sessionDate &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.plannedMinutes == this.plannedMinutes &&
          other.actualMinutes == this.actualMinutes &&
          other.mode == this.mode &&
          other.completed == this.completed &&
          other.taskId == this.taskId &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSessionRow> {
  final Value<int> id;
  final Value<DateTime> sessionDate;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> plannedMinutes;
  final Value<int> actualMinutes;
  final Value<String> mode;
  final Value<bool> completed;
  final Value<int?> taskId;
  final Value<int?> categoryId;
  final Value<String> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.sessionDate = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.plannedMinutes = const Value.absent(),
    this.actualMinutes = const Value.absent(),
    this.mode = const Value.absent(),
    this.completed = const Value.absent(),
    this.taskId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime sessionDate,
    required DateTime startedAt,
    required DateTime endedAt,
    required int plannedMinutes,
    required int actualMinutes,
    required String mode,
    this.completed = const Value.absent(),
    this.taskId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : sessionDate = Value(sessionDate),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       plannedMinutes = Value(plannedMinutes),
       actualMinutes = Value(actualMinutes),
       mode = Value(mode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FocusSessionRow> custom({
    Expression<int>? id,
    Expression<DateTime>? sessionDate,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? plannedMinutes,
    Expression<int>? actualMinutes,
    Expression<String>? mode,
    Expression<bool>? completed,
    Expression<int>? taskId,
    Expression<int>? categoryId,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionDate != null) 'session_date': sessionDate,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (plannedMinutes != null) 'planned_minutes': plannedMinutes,
      if (actualMinutes != null) 'actual_minutes': actualMinutes,
      if (mode != null) 'mode': mode,
      if (completed != null) 'completed': completed,
      if (taskId != null) 'task_id': taskId,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? sessionDate,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? plannedMinutes,
    Value<int>? actualMinutes,
    Value<String>? mode,
    Value<bool>? completed,
    Value<int?>? taskId,
    Value<int?>? categoryId,
    Value<String>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      sessionDate: sessionDate ?? this.sessionDate,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      mode: mode ?? this.mode,
      completed: completed ?? this.completed,
      taskId: taskId ?? this.taskId,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionDate.present) {
      map['session_date'] = Variable<DateTime>(sessionDate.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (plannedMinutes.present) {
      map['planned_minutes'] = Variable<int>(plannedMinutes.value);
    }
    if (actualMinutes.present) {
      map['actual_minutes'] = Variable<int>(actualMinutes.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('sessionDate: $sessionDate, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('actualMinutes: $actualMinutes, ')
          ..write('mode: $mode, ')
          ..write('completed: $completed, ')
          ..write('taskId: $taskId, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ActiveTimersTable extends ActiveTimers
    with TableInfo<$ActiveTimersTable, ActiveTimerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveTimersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedEndAtMeta = const VerificationMeta(
    'expectedEndAt',
  );
  @override
  late final GeneratedColumn<DateTime> expectedEndAt =
      GeneratedColumn<DateTime>(
        'expected_end_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _remainingSecondsMeta = const VerificationMeta(
    'remainingSeconds',
  );
  @override
  late final GeneratedColumn<int> remainingSeconds = GeneratedColumn<int>(
    'remaining_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalSecondsMeta = const VerificationMeta(
    'totalSeconds',
  );
  @override
  late final GeneratedColumn<int> totalSeconds = GeneratedColumn<int>(
    'total_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isRunningMeta = const VerificationMeta(
    'isRunning',
  );
  @override
  late final GeneratedColumn<bool> isRunning = GeneratedColumn<bool>(
    'is_running',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_running" IN (0, 1))',
    ),
  );
  static const VerificationMeta _cycleCountMeta = const VerificationMeta(
    'cycleCount',
  );
  @override
  late final GeneratedColumn<int> cycleCount = GeneratedColumn<int>(
    'cycle_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mode,
    phase,
    startedAt,
    expectedEndAt,
    remainingSeconds,
    totalSeconds,
    title,
    isRunning,
    cycleCount,
    taskId,
    categoryId,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_timers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveTimerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('expected_end_at')) {
      context.handle(
        _expectedEndAtMeta,
        expectedEndAt.isAcceptableOrUnknown(
          data['expected_end_at']!,
          _expectedEndAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedEndAtMeta);
    }
    if (data.containsKey('remaining_seconds')) {
      context.handle(
        _remainingSecondsMeta,
        remainingSeconds.isAcceptableOrUnknown(
          data['remaining_seconds']!,
          _remainingSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingSecondsMeta);
    }
    if (data.containsKey('total_seconds')) {
      context.handle(
        _totalSecondsMeta,
        totalSeconds.isAcceptableOrUnknown(
          data['total_seconds']!,
          _totalSecondsMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('is_running')) {
      context.handle(
        _isRunningMeta,
        isRunning.isAcceptableOrUnknown(data['is_running']!, _isRunningMeta),
      );
    } else if (isInserting) {
      context.missing(_isRunningMeta);
    }
    if (data.containsKey('cycle_count')) {
      context.handle(
        _cycleCountMeta,
        cycleCount.isAcceptableOrUnknown(data['cycle_count']!, _cycleCountMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActiveTimerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveTimerRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      mode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}mode'],
          )!,
      phase:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}phase'],
          )!,
      startedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}started_at'],
          )!,
      expectedEndAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}expected_end_at'],
          )!,
      remainingSeconds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}remaining_seconds'],
          )!,
      totalSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_seconds'],
      ),
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      isRunning:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_running'],
          )!,
      cycleCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}cycle_count'],
          )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $ActiveTimersTable createAlias(String alias) {
    return $ActiveTimersTable(attachedDatabase, alias);
  }
}

class ActiveTimerRow extends DataClass implements Insertable<ActiveTimerRow> {
  final int id;
  final String mode;
  final String phase;
  final DateTime startedAt;
  final DateTime expectedEndAt;
  final int remainingSeconds;
  final int? totalSeconds;
  final String title;
  final bool isRunning;
  final int cycleCount;
  final int? taskId;
  final int? categoryId;
  final DateTime updatedAt;
  const ActiveTimerRow({
    required this.id,
    required this.mode,
    required this.phase,
    required this.startedAt,
    required this.expectedEndAt,
    required this.remainingSeconds,
    this.totalSeconds,
    required this.title,
    required this.isRunning,
    required this.cycleCount,
    this.taskId,
    this.categoryId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mode'] = Variable<String>(mode);
    map['phase'] = Variable<String>(phase);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['expected_end_at'] = Variable<DateTime>(expectedEndAt);
    map['remaining_seconds'] = Variable<int>(remainingSeconds);
    if (!nullToAbsent || totalSeconds != null) {
      map['total_seconds'] = Variable<int>(totalSeconds);
    }
    map['title'] = Variable<String>(title);
    map['is_running'] = Variable<bool>(isRunning);
    map['cycle_count'] = Variable<int>(cycleCount);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<int>(taskId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ActiveTimersCompanion toCompanion(bool nullToAbsent) {
    return ActiveTimersCompanion(
      id: Value(id),
      mode: Value(mode),
      phase: Value(phase),
      startedAt: Value(startedAt),
      expectedEndAt: Value(expectedEndAt),
      remainingSeconds: Value(remainingSeconds),
      totalSeconds:
          totalSeconds == null && nullToAbsent
              ? const Value.absent()
              : Value(totalSeconds),
      title: Value(title),
      isRunning: Value(isRunning),
      cycleCount: Value(cycleCount),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
      categoryId:
          categoryId == null && nullToAbsent
              ? const Value.absent()
              : Value(categoryId),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActiveTimerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveTimerRow(
      id: serializer.fromJson<int>(json['id']),
      mode: serializer.fromJson<String>(json['mode']),
      phase: serializer.fromJson<String>(json['phase']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      expectedEndAt: serializer.fromJson<DateTime>(json['expectedEndAt']),
      remainingSeconds: serializer.fromJson<int>(json['remainingSeconds']),
      totalSeconds: serializer.fromJson<int?>(json['totalSeconds']),
      title: serializer.fromJson<String>(json['title']),
      isRunning: serializer.fromJson<bool>(json['isRunning']),
      cycleCount: serializer.fromJson<int>(json['cycleCount']),
      taskId: serializer.fromJson<int?>(json['taskId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mode': serializer.toJson<String>(mode),
      'phase': serializer.toJson<String>(phase),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'expectedEndAt': serializer.toJson<DateTime>(expectedEndAt),
      'remainingSeconds': serializer.toJson<int>(remainingSeconds),
      'totalSeconds': serializer.toJson<int?>(totalSeconds),
      'title': serializer.toJson<String>(title),
      'isRunning': serializer.toJson<bool>(isRunning),
      'cycleCount': serializer.toJson<int>(cycleCount),
      'taskId': serializer.toJson<int?>(taskId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ActiveTimerRow copyWith({
    int? id,
    String? mode,
    String? phase,
    DateTime? startedAt,
    DateTime? expectedEndAt,
    int? remainingSeconds,
    Value<int?> totalSeconds = const Value.absent(),
    String? title,
    bool? isRunning,
    int? cycleCount,
    Value<int?> taskId = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    DateTime? updatedAt,
  }) => ActiveTimerRow(
    id: id ?? this.id,
    mode: mode ?? this.mode,
    phase: phase ?? this.phase,
    startedAt: startedAt ?? this.startedAt,
    expectedEndAt: expectedEndAt ?? this.expectedEndAt,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    totalSeconds: totalSeconds.present ? totalSeconds.value : this.totalSeconds,
    title: title ?? this.title,
    isRunning: isRunning ?? this.isRunning,
    cycleCount: cycleCount ?? this.cycleCount,
    taskId: taskId.present ? taskId.value : this.taskId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ActiveTimerRow copyWithCompanion(ActiveTimersCompanion data) {
    return ActiveTimerRow(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      phase: data.phase.present ? data.phase.value : this.phase,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      expectedEndAt:
          data.expectedEndAt.present
              ? data.expectedEndAt.value
              : this.expectedEndAt,
      remainingSeconds:
          data.remainingSeconds.present
              ? data.remainingSeconds.value
              : this.remainingSeconds,
      totalSeconds:
          data.totalSeconds.present
              ? data.totalSeconds.value
              : this.totalSeconds,
      title: data.title.present ? data.title.value : this.title,
      isRunning: data.isRunning.present ? data.isRunning.value : this.isRunning,
      cycleCount:
          data.cycleCount.present ? data.cycleCount.value : this.cycleCount,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTimerRow(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('phase: $phase, ')
          ..write('startedAt: $startedAt, ')
          ..write('expectedEndAt: $expectedEndAt, ')
          ..write('remainingSeconds: $remainingSeconds, ')
          ..write('totalSeconds: $totalSeconds, ')
          ..write('title: $title, ')
          ..write('isRunning: $isRunning, ')
          ..write('cycleCount: $cycleCount, ')
          ..write('taskId: $taskId, ')
          ..write('categoryId: $categoryId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mode,
    phase,
    startedAt,
    expectedEndAt,
    remainingSeconds,
    totalSeconds,
    title,
    isRunning,
    cycleCount,
    taskId,
    categoryId,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveTimerRow &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.phase == this.phase &&
          other.startedAt == this.startedAt &&
          other.expectedEndAt == this.expectedEndAt &&
          other.remainingSeconds == this.remainingSeconds &&
          other.totalSeconds == this.totalSeconds &&
          other.title == this.title &&
          other.isRunning == this.isRunning &&
          other.cycleCount == this.cycleCount &&
          other.taskId == this.taskId &&
          other.categoryId == this.categoryId &&
          other.updatedAt == this.updatedAt);
}

class ActiveTimersCompanion extends UpdateCompanion<ActiveTimerRow> {
  final Value<int> id;
  final Value<String> mode;
  final Value<String> phase;
  final Value<DateTime> startedAt;
  final Value<DateTime> expectedEndAt;
  final Value<int> remainingSeconds;
  final Value<int?> totalSeconds;
  final Value<String> title;
  final Value<bool> isRunning;
  final Value<int> cycleCount;
  final Value<int?> taskId;
  final Value<int?> categoryId;
  final Value<DateTime> updatedAt;
  const ActiveTimersCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.phase = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.expectedEndAt = const Value.absent(),
    this.remainingSeconds = const Value.absent(),
    this.totalSeconds = const Value.absent(),
    this.title = const Value.absent(),
    this.isRunning = const Value.absent(),
    this.cycleCount = const Value.absent(),
    this.taskId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ActiveTimersCompanion.insert({
    this.id = const Value.absent(),
    required String mode,
    required String phase,
    required DateTime startedAt,
    required DateTime expectedEndAt,
    required int remainingSeconds,
    this.totalSeconds = const Value.absent(),
    this.title = const Value.absent(),
    required bool isRunning,
    this.cycleCount = const Value.absent(),
    this.taskId = const Value.absent(),
    this.categoryId = const Value.absent(),
    required DateTime updatedAt,
  }) : mode = Value(mode),
       phase = Value(phase),
       startedAt = Value(startedAt),
       expectedEndAt = Value(expectedEndAt),
       remainingSeconds = Value(remainingSeconds),
       isRunning = Value(isRunning),
       updatedAt = Value(updatedAt);
  static Insertable<ActiveTimerRow> custom({
    Expression<int>? id,
    Expression<String>? mode,
    Expression<String>? phase,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? expectedEndAt,
    Expression<int>? remainingSeconds,
    Expression<int>? totalSeconds,
    Expression<String>? title,
    Expression<bool>? isRunning,
    Expression<int>? cycleCount,
    Expression<int>? taskId,
    Expression<int>? categoryId,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (phase != null) 'phase': phase,
      if (startedAt != null) 'started_at': startedAt,
      if (expectedEndAt != null) 'expected_end_at': expectedEndAt,
      if (remainingSeconds != null) 'remaining_seconds': remainingSeconds,
      if (totalSeconds != null) 'total_seconds': totalSeconds,
      if (title != null) 'title': title,
      if (isRunning != null) 'is_running': isRunning,
      if (cycleCount != null) 'cycle_count': cycleCount,
      if (taskId != null) 'task_id': taskId,
      if (categoryId != null) 'category_id': categoryId,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ActiveTimersCompanion copyWith({
    Value<int>? id,
    Value<String>? mode,
    Value<String>? phase,
    Value<DateTime>? startedAt,
    Value<DateTime>? expectedEndAt,
    Value<int>? remainingSeconds,
    Value<int?>? totalSeconds,
    Value<String>? title,
    Value<bool>? isRunning,
    Value<int>? cycleCount,
    Value<int?>? taskId,
    Value<int?>? categoryId,
    Value<DateTime>? updatedAt,
  }) {
    return ActiveTimersCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      phase: phase ?? this.phase,
      startedAt: startedAt ?? this.startedAt,
      expectedEndAt: expectedEndAt ?? this.expectedEndAt,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      title: title ?? this.title,
      isRunning: isRunning ?? this.isRunning,
      cycleCount: cycleCount ?? this.cycleCount,
      taskId: taskId ?? this.taskId,
      categoryId: categoryId ?? this.categoryId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (expectedEndAt.present) {
      map['expected_end_at'] = Variable<DateTime>(expectedEndAt.value);
    }
    if (remainingSeconds.present) {
      map['remaining_seconds'] = Variable<int>(remainingSeconds.value);
    }
    if (totalSeconds.present) {
      map['total_seconds'] = Variable<int>(totalSeconds.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isRunning.present) {
      map['is_running'] = Variable<bool>(isRunning.value);
    }
    if (cycleCount.present) {
      map['cycle_count'] = Variable<int>(cycleCount.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveTimersCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('phase: $phase, ')
          ..write('startedAt: $startedAt, ')
          ..write('expectedEndAt: $expectedEndAt, ')
          ..write('remainingSeconds: $remainingSeconds, ')
          ..write('totalSeconds: $totalSeconds, ')
          ..write('title: $title, ')
          ..write('isRunning: $isRunning, ')
          ..write('cycleCount: $cycleCount, ')
          ..write('taskId: $taskId, ')
          ..write('categoryId: $categoryId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MonthlyGoalsTable extends MonthlyGoals
    with TableInfo<$MonthlyGoalsTable, MonthlyGoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _yearMonthMeta = const VerificationMeta(
    'yearMonth',
  );
  @override
  late final GeneratedColumn<String> yearMonth = GeneratedColumn<String>(
    'year_month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    yearMonth,
    content,
    isCompleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonthlyGoalRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('year_month')) {
      context.handle(
        _yearMonthMeta,
        yearMonth.isAcceptableOrUnknown(data['year_month']!, _yearMonthMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMonthMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {yearMonth, content},
  ];
  @override
  MonthlyGoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyGoalRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      yearMonth:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}year_month'],
          )!,
      content:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}content'],
          )!,
      isCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_completed'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $MonthlyGoalsTable createAlias(String alias) {
    return $MonthlyGoalsTable(attachedDatabase, alias);
  }
}

class MonthlyGoalRow extends DataClass implements Insertable<MonthlyGoalRow> {
  final int id;
  final String yearMonth;
  final String content;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MonthlyGoalRow({
    required this.id,
    required this.yearMonth,
    required this.content,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['year_month'] = Variable<String>(yearMonth);
    map['content'] = Variable<String>(content);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MonthlyGoalsCompanion toCompanion(bool nullToAbsent) {
    return MonthlyGoalsCompanion(
      id: Value(id),
      yearMonth: Value(yearMonth),
      content: Value(content),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MonthlyGoalRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyGoalRow(
      id: serializer.fromJson<int>(json['id']),
      yearMonth: serializer.fromJson<String>(json['yearMonth']),
      content: serializer.fromJson<String>(json['content']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'yearMonth': serializer.toJson<String>(yearMonth),
      'content': serializer.toJson<String>(content),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MonthlyGoalRow copyWith({
    int? id,
    String? yearMonth,
    String? content,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MonthlyGoalRow(
    id: id ?? this.id,
    yearMonth: yearMonth ?? this.yearMonth,
    content: content ?? this.content,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MonthlyGoalRow copyWithCompanion(MonthlyGoalsCompanion data) {
    return MonthlyGoalRow(
      id: data.id.present ? data.id.value : this.id,
      yearMonth: data.yearMonth.present ? data.yearMonth.value : this.yearMonth,
      content: data.content.present ? data.content.value : this.content,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyGoalRow(')
          ..write('id: $id, ')
          ..write('yearMonth: $yearMonth, ')
          ..write('content: $content, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, yearMonth, content, isCompleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyGoalRow &&
          other.id == this.id &&
          other.yearMonth == this.yearMonth &&
          other.content == this.content &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MonthlyGoalsCompanion extends UpdateCompanion<MonthlyGoalRow> {
  final Value<int> id;
  final Value<String> yearMonth;
  final Value<String> content;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MonthlyGoalsCompanion({
    this.id = const Value.absent(),
    this.yearMonth = const Value.absent(),
    this.content = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MonthlyGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String yearMonth,
    required String content,
    this.isCompleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : yearMonth = Value(yearMonth),
       content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MonthlyGoalRow> custom({
    Expression<int>? id,
    Expression<String>? yearMonth,
    Expression<String>? content,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (yearMonth != null) 'year_month': yearMonth,
      if (content != null) 'content': content,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MonthlyGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? yearMonth,
    Value<String>? content,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return MonthlyGoalsCompanion(
      id: id ?? this.id,
      yearMonth: yearMonth ?? this.yearMonth,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (yearMonth.present) {
      map['year_month'] = Variable<String>(yearMonth.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyGoalsCompanion(')
          ..write('id: $id, ')
          ..write('yearMonth: $yearMonth, ')
          ..write('content: $content, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _weekViewModeMeta = const VerificationMeta(
    'weekViewMode',
  );
  @override
  late final GeneratedColumn<String> weekViewMode = GeneratedColumn<String>(
    'week_view_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('detail'),
  );
  static const VerificationMeta _scheduleZoomMeta = const VerificationMeta(
    'scheduleZoom',
  );
  @override
  late final GeneratedColumn<String> scheduleZoom = GeneratedColumn<String>(
    'schedule_zoom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('standard'),
  );
  static const VerificationMeta _detailHourHeightMeta = const VerificationMeta(
    'detailHourHeight',
  );
  @override
  late final GeneratedColumn<double> detailHourHeight = GeneratedColumn<double>(
    'detail_hour_height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(56.0),
  );
  static const VerificationMeta _overviewHourHeightMeta =
      const VerificationMeta('overviewHourHeight');
  @override
  late final GeneratedColumn<double> overviewHourHeight =
      GeneratedColumn<double>(
        'overview_hour_height',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(28.0),
      );
  static const VerificationMeta _pomodoroFocusMinutesMeta =
      const VerificationMeta('pomodoroFocusMinutes');
  @override
  late final GeneratedColumn<int> pomodoroFocusMinutes = GeneratedColumn<int>(
    'pomodoro_focus_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25),
  );
  static const VerificationMeta _shortBreakMinutesMeta = const VerificationMeta(
    'shortBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> shortBreakMinutes = GeneratedColumn<int>(
    'short_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _longBreakMinutesMeta = const VerificationMeta(
    'longBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> longBreakMinutes = GeneratedColumn<int>(
    'long_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _longBreakIntervalMeta = const VerificationMeta(
    'longBreakInterval',
  );
  @override
  late final GeneratedColumn<int> longBreakInterval = GeneratedColumn<int>(
    'long_break_interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _notificationEnabledMeta =
      const VerificationMeta('notificationEnabled');
  @override
  late final GeneratedColumn<bool> notificationEnabled = GeneratedColumn<bool>(
    'notification_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notification_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _autoCompleteTaskOnFocusMeta =
      const VerificationMeta('autoCompleteTaskOnFocus');
  @override
  late final GeneratedColumn<bool> autoCompleteTaskOnFocus =
      GeneratedColumn<bool>(
        'auto_complete_task_on_focus',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_complete_task_on_focus" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _focusMusicEnabledMeta = const VerificationMeta(
    'focusMusicEnabled',
  );
  @override
  late final GeneratedColumn<bool> focusMusicEnabled = GeneratedColumn<bool>(
    'focus_music_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("focus_music_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _focusMusicUriMeta = const VerificationMeta(
    'focusMusicUri',
  );
  @override
  late final GeneratedColumn<String> focusMusicUri = GeneratedColumn<String>(
    'focus_music_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _focusMusicNameMeta = const VerificationMeta(
    'focusMusicName',
  );
  @override
  late final GeneratedColumn<String> focusMusicName = GeneratedColumn<String>(
    'focus_music_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _timelineStartMinutesMeta =
      const VerificationMeta('timelineStartMinutes');
  @override
  late final GeneratedColumn<int> timelineStartMinutes = GeneratedColumn<int>(
    'timeline_start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timelineEndMinutesMeta =
      const VerificationMeta('timelineEndMinutes');
  @override
  late final GeneratedColumn<int> timelineEndMinutes = GeneratedColumn<int>(
    'timeline_end_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1440),
  );
  static const VerificationMeta _autoColorEnabledMeta = const VerificationMeta(
    'autoColorEnabled',
  );
  @override
  late final GeneratedColumn<bool> autoColorEnabled = GeneratedColumn<bool>(
    'auto_color_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_color_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    weekViewMode,
    scheduleZoom,
    detailHourHeight,
    overviewHourHeight,
    pomodoroFocusMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    longBreakInterval,
    notificationEnabled,
    autoCompleteTaskOnFocus,
    focusMusicEnabled,
    focusMusicUri,
    focusMusicName,
    timelineStartMinutes,
    timelineEndMinutes,
    autoColorEnabled,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('week_view_mode')) {
      context.handle(
        _weekViewModeMeta,
        weekViewMode.isAcceptableOrUnknown(
          data['week_view_mode']!,
          _weekViewModeMeta,
        ),
      );
    }
    if (data.containsKey('schedule_zoom')) {
      context.handle(
        _scheduleZoomMeta,
        scheduleZoom.isAcceptableOrUnknown(
          data['schedule_zoom']!,
          _scheduleZoomMeta,
        ),
      );
    }
    if (data.containsKey('detail_hour_height')) {
      context.handle(
        _detailHourHeightMeta,
        detailHourHeight.isAcceptableOrUnknown(
          data['detail_hour_height']!,
          _detailHourHeightMeta,
        ),
      );
    }
    if (data.containsKey('overview_hour_height')) {
      context.handle(
        _overviewHourHeightMeta,
        overviewHourHeight.isAcceptableOrUnknown(
          data['overview_hour_height']!,
          _overviewHourHeightMeta,
        ),
      );
    }
    if (data.containsKey('pomodoro_focus_minutes')) {
      context.handle(
        _pomodoroFocusMinutesMeta,
        pomodoroFocusMinutes.isAcceptableOrUnknown(
          data['pomodoro_focus_minutes']!,
          _pomodoroFocusMinutesMeta,
        ),
      );
    }
    if (data.containsKey('short_break_minutes')) {
      context.handle(
        _shortBreakMinutesMeta,
        shortBreakMinutes.isAcceptableOrUnknown(
          data['short_break_minutes']!,
          _shortBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('long_break_minutes')) {
      context.handle(
        _longBreakMinutesMeta,
        longBreakMinutes.isAcceptableOrUnknown(
          data['long_break_minutes']!,
          _longBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('long_break_interval')) {
      context.handle(
        _longBreakIntervalMeta,
        longBreakInterval.isAcceptableOrUnknown(
          data['long_break_interval']!,
          _longBreakIntervalMeta,
        ),
      );
    }
    if (data.containsKey('notification_enabled')) {
      context.handle(
        _notificationEnabledMeta,
        notificationEnabled.isAcceptableOrUnknown(
          data['notification_enabled']!,
          _notificationEnabledMeta,
        ),
      );
    }
    if (data.containsKey('auto_complete_task_on_focus')) {
      context.handle(
        _autoCompleteTaskOnFocusMeta,
        autoCompleteTaskOnFocus.isAcceptableOrUnknown(
          data['auto_complete_task_on_focus']!,
          _autoCompleteTaskOnFocusMeta,
        ),
      );
    }
    if (data.containsKey('focus_music_enabled')) {
      context.handle(
        _focusMusicEnabledMeta,
        focusMusicEnabled.isAcceptableOrUnknown(
          data['focus_music_enabled']!,
          _focusMusicEnabledMeta,
        ),
      );
    }
    if (data.containsKey('focus_music_uri')) {
      context.handle(
        _focusMusicUriMeta,
        focusMusicUri.isAcceptableOrUnknown(
          data['focus_music_uri']!,
          _focusMusicUriMeta,
        ),
      );
    }
    if (data.containsKey('focus_music_name')) {
      context.handle(
        _focusMusicNameMeta,
        focusMusicName.isAcceptableOrUnknown(
          data['focus_music_name']!,
          _focusMusicNameMeta,
        ),
      );
    }
    if (data.containsKey('timeline_start_minutes')) {
      context.handle(
        _timelineStartMinutesMeta,
        timelineStartMinutes.isAcceptableOrUnknown(
          data['timeline_start_minutes']!,
          _timelineStartMinutesMeta,
        ),
      );
    }
    if (data.containsKey('timeline_end_minutes')) {
      context.handle(
        _timelineEndMinutesMeta,
        timelineEndMinutes.isAcceptableOrUnknown(
          data['timeline_end_minutes']!,
          _timelineEndMinutesMeta,
        ),
      );
    }
    if (data.containsKey('auto_color_enabled')) {
      context.handle(
        _autoColorEnabledMeta,
        autoColorEnabled.isAcceptableOrUnknown(
          data['auto_color_enabled']!,
          _autoColorEnabledMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      themeMode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}theme_mode'],
          )!,
      weekViewMode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}week_view_mode'],
          )!,
      scheduleZoom:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}schedule_zoom'],
          )!,
      detailHourHeight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}detail_hour_height'],
          )!,
      overviewHourHeight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}overview_hour_height'],
          )!,
      pomodoroFocusMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}pomodoro_focus_minutes'],
          )!,
      shortBreakMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}short_break_minutes'],
          )!,
      longBreakMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}long_break_minutes'],
          )!,
      longBreakInterval:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}long_break_interval'],
          )!,
      notificationEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}notification_enabled'],
          )!,
      autoCompleteTaskOnFocus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}auto_complete_task_on_focus'],
          )!,
      focusMusicEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}focus_music_enabled'],
          )!,
      focusMusicUri:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}focus_music_uri'],
          )!,
      focusMusicName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}focus_music_name'],
          )!,
      timelineStartMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}timeline_start_minutes'],
          )!,
      timelineEndMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}timeline_end_minutes'],
          )!,
      autoColorEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}auto_color_enabled'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsRow extends DataClass implements Insertable<AppSettingsRow> {
  final int id;
  final String themeMode;
  final String weekViewMode;
  final String scheduleZoom;
  final double detailHourHeight;
  final double overviewHourHeight;
  final int pomodoroFocusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int longBreakInterval;
  final bool notificationEnabled;
  final bool autoCompleteTaskOnFocus;
  final bool focusMusicEnabled;
  final String focusMusicUri;
  final String focusMusicName;
  final int timelineStartMinutes;
  final int timelineEndMinutes;
  final bool autoColorEnabled;
  final DateTime updatedAt;
  const AppSettingsRow({
    required this.id,
    required this.themeMode,
    required this.weekViewMode,
    required this.scheduleZoom,
    required this.detailHourHeight,
    required this.overviewHourHeight,
    required this.pomodoroFocusMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.longBreakInterval,
    required this.notificationEnabled,
    required this.autoCompleteTaskOnFocus,
    required this.focusMusicEnabled,
    required this.focusMusicUri,
    required this.focusMusicName,
    required this.timelineStartMinutes,
    required this.timelineEndMinutes,
    required this.autoColorEnabled,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['week_view_mode'] = Variable<String>(weekViewMode);
    map['schedule_zoom'] = Variable<String>(scheduleZoom);
    map['detail_hour_height'] = Variable<double>(detailHourHeight);
    map['overview_hour_height'] = Variable<double>(overviewHourHeight);
    map['pomodoro_focus_minutes'] = Variable<int>(pomodoroFocusMinutes);
    map['short_break_minutes'] = Variable<int>(shortBreakMinutes);
    map['long_break_minutes'] = Variable<int>(longBreakMinutes);
    map['long_break_interval'] = Variable<int>(longBreakInterval);
    map['notification_enabled'] = Variable<bool>(notificationEnabled);
    map['auto_complete_task_on_focus'] = Variable<bool>(
      autoCompleteTaskOnFocus,
    );
    map['focus_music_enabled'] = Variable<bool>(focusMusicEnabled);
    map['focus_music_uri'] = Variable<String>(focusMusicUri);
    map['focus_music_name'] = Variable<String>(focusMusicName);
    map['timeline_start_minutes'] = Variable<int>(timelineStartMinutes);
    map['timeline_end_minutes'] = Variable<int>(timelineEndMinutes);
    map['auto_color_enabled'] = Variable<bool>(autoColorEnabled);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      weekViewMode: Value(weekViewMode),
      scheduleZoom: Value(scheduleZoom),
      detailHourHeight: Value(detailHourHeight),
      overviewHourHeight: Value(overviewHourHeight),
      pomodoroFocusMinutes: Value(pomodoroFocusMinutes),
      shortBreakMinutes: Value(shortBreakMinutes),
      longBreakMinutes: Value(longBreakMinutes),
      longBreakInterval: Value(longBreakInterval),
      notificationEnabled: Value(notificationEnabled),
      autoCompleteTaskOnFocus: Value(autoCompleteTaskOnFocus),
      focusMusicEnabled: Value(focusMusicEnabled),
      focusMusicUri: Value(focusMusicUri),
      focusMusicName: Value(focusMusicName),
      timelineStartMinutes: Value(timelineStartMinutes),
      timelineEndMinutes: Value(timelineEndMinutes),
      autoColorEnabled: Value(autoColorEnabled),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      weekViewMode: serializer.fromJson<String>(json['weekViewMode']),
      scheduleZoom: serializer.fromJson<String>(json['scheduleZoom']),
      detailHourHeight: serializer.fromJson<double>(json['detailHourHeight']),
      overviewHourHeight: serializer.fromJson<double>(
        json['overviewHourHeight'],
      ),
      pomodoroFocusMinutes: serializer.fromJson<int>(
        json['pomodoroFocusMinutes'],
      ),
      shortBreakMinutes: serializer.fromJson<int>(json['shortBreakMinutes']),
      longBreakMinutes: serializer.fromJson<int>(json['longBreakMinutes']),
      longBreakInterval: serializer.fromJson<int>(json['longBreakInterval']),
      notificationEnabled: serializer.fromJson<bool>(
        json['notificationEnabled'],
      ),
      autoCompleteTaskOnFocus: serializer.fromJson<bool>(
        json['autoCompleteTaskOnFocus'],
      ),
      focusMusicEnabled: serializer.fromJson<bool>(json['focusMusicEnabled']),
      focusMusicUri: serializer.fromJson<String>(json['focusMusicUri']),
      focusMusicName: serializer.fromJson<String>(json['focusMusicName']),
      timelineStartMinutes: serializer.fromJson<int>(
        json['timelineStartMinutes'],
      ),
      timelineEndMinutes: serializer.fromJson<int>(json['timelineEndMinutes']),
      autoColorEnabled: serializer.fromJson<bool>(json['autoColorEnabled']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'weekViewMode': serializer.toJson<String>(weekViewMode),
      'scheduleZoom': serializer.toJson<String>(scheduleZoom),
      'detailHourHeight': serializer.toJson<double>(detailHourHeight),
      'overviewHourHeight': serializer.toJson<double>(overviewHourHeight),
      'pomodoroFocusMinutes': serializer.toJson<int>(pomodoroFocusMinutes),
      'shortBreakMinutes': serializer.toJson<int>(shortBreakMinutes),
      'longBreakMinutes': serializer.toJson<int>(longBreakMinutes),
      'longBreakInterval': serializer.toJson<int>(longBreakInterval),
      'notificationEnabled': serializer.toJson<bool>(notificationEnabled),
      'autoCompleteTaskOnFocus': serializer.toJson<bool>(
        autoCompleteTaskOnFocus,
      ),
      'focusMusicEnabled': serializer.toJson<bool>(focusMusicEnabled),
      'focusMusicUri': serializer.toJson<String>(focusMusicUri),
      'focusMusicName': serializer.toJson<String>(focusMusicName),
      'timelineStartMinutes': serializer.toJson<int>(timelineStartMinutes),
      'timelineEndMinutes': serializer.toJson<int>(timelineEndMinutes),
      'autoColorEnabled': serializer.toJson<bool>(autoColorEnabled),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSettingsRow copyWith({
    int? id,
    String? themeMode,
    String? weekViewMode,
    String? scheduleZoom,
    double? detailHourHeight,
    double? overviewHourHeight,
    int? pomodoroFocusMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? longBreakInterval,
    bool? notificationEnabled,
    bool? autoCompleteTaskOnFocus,
    bool? focusMusicEnabled,
    String? focusMusicUri,
    String? focusMusicName,
    int? timelineStartMinutes,
    int? timelineEndMinutes,
    bool? autoColorEnabled,
    DateTime? updatedAt,
  }) => AppSettingsRow(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    weekViewMode: weekViewMode ?? this.weekViewMode,
    scheduleZoom: scheduleZoom ?? this.scheduleZoom,
    detailHourHeight: detailHourHeight ?? this.detailHourHeight,
    overviewHourHeight: overviewHourHeight ?? this.overviewHourHeight,
    pomodoroFocusMinutes: pomodoroFocusMinutes ?? this.pomodoroFocusMinutes,
    shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
    longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
    longBreakInterval: longBreakInterval ?? this.longBreakInterval,
    notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    autoCompleteTaskOnFocus:
        autoCompleteTaskOnFocus ?? this.autoCompleteTaskOnFocus,
    focusMusicEnabled: focusMusicEnabled ?? this.focusMusicEnabled,
    focusMusicUri: focusMusicUri ?? this.focusMusicUri,
    focusMusicName: focusMusicName ?? this.focusMusicName,
    timelineStartMinutes: timelineStartMinutes ?? this.timelineStartMinutes,
    timelineEndMinutes: timelineEndMinutes ?? this.timelineEndMinutes,
    autoColorEnabled: autoColorEnabled ?? this.autoColorEnabled,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSettingsRow copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      weekViewMode:
          data.weekViewMode.present
              ? data.weekViewMode.value
              : this.weekViewMode,
      scheduleZoom:
          data.scheduleZoom.present
              ? data.scheduleZoom.value
              : this.scheduleZoom,
      detailHourHeight:
          data.detailHourHeight.present
              ? data.detailHourHeight.value
              : this.detailHourHeight,
      overviewHourHeight:
          data.overviewHourHeight.present
              ? data.overviewHourHeight.value
              : this.overviewHourHeight,
      pomodoroFocusMinutes:
          data.pomodoroFocusMinutes.present
              ? data.pomodoroFocusMinutes.value
              : this.pomodoroFocusMinutes,
      shortBreakMinutes:
          data.shortBreakMinutes.present
              ? data.shortBreakMinutes.value
              : this.shortBreakMinutes,
      longBreakMinutes:
          data.longBreakMinutes.present
              ? data.longBreakMinutes.value
              : this.longBreakMinutes,
      longBreakInterval:
          data.longBreakInterval.present
              ? data.longBreakInterval.value
              : this.longBreakInterval,
      notificationEnabled:
          data.notificationEnabled.present
              ? data.notificationEnabled.value
              : this.notificationEnabled,
      autoCompleteTaskOnFocus:
          data.autoCompleteTaskOnFocus.present
              ? data.autoCompleteTaskOnFocus.value
              : this.autoCompleteTaskOnFocus,
      focusMusicEnabled:
          data.focusMusicEnabled.present
              ? data.focusMusicEnabled.value
              : this.focusMusicEnabled,
      focusMusicUri:
          data.focusMusicUri.present
              ? data.focusMusicUri.value
              : this.focusMusicUri,
      focusMusicName:
          data.focusMusicName.present
              ? data.focusMusicName.value
              : this.focusMusicName,
      timelineStartMinutes:
          data.timelineStartMinutes.present
              ? data.timelineStartMinutes.value
              : this.timelineStartMinutes,
      timelineEndMinutes:
          data.timelineEndMinutes.present
              ? data.timelineEndMinutes.value
              : this.timelineEndMinutes,
      autoColorEnabled:
          data.autoColorEnabled.present
              ? data.autoColorEnabled.value
              : this.autoColorEnabled,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRow(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('weekViewMode: $weekViewMode, ')
          ..write('scheduleZoom: $scheduleZoom, ')
          ..write('detailHourHeight: $detailHourHeight, ')
          ..write('overviewHourHeight: $overviewHourHeight, ')
          ..write('pomodoroFocusMinutes: $pomodoroFocusMinutes, ')
          ..write('shortBreakMinutes: $shortBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('longBreakInterval: $longBreakInterval, ')
          ..write('notificationEnabled: $notificationEnabled, ')
          ..write('autoCompleteTaskOnFocus: $autoCompleteTaskOnFocus, ')
          ..write('focusMusicEnabled: $focusMusicEnabled, ')
          ..write('focusMusicUri: $focusMusicUri, ')
          ..write('focusMusicName: $focusMusicName, ')
          ..write('timelineStartMinutes: $timelineStartMinutes, ')
          ..write('timelineEndMinutes: $timelineEndMinutes, ')
          ..write('autoColorEnabled: $autoColorEnabled, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    weekViewMode,
    scheduleZoom,
    detailHourHeight,
    overviewHourHeight,
    pomodoroFocusMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    longBreakInterval,
    notificationEnabled,
    autoCompleteTaskOnFocus,
    focusMusicEnabled,
    focusMusicUri,
    focusMusicName,
    timelineStartMinutes,
    timelineEndMinutes,
    autoColorEnabled,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsRow &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.weekViewMode == this.weekViewMode &&
          other.scheduleZoom == this.scheduleZoom &&
          other.detailHourHeight == this.detailHourHeight &&
          other.overviewHourHeight == this.overviewHourHeight &&
          other.pomodoroFocusMinutes == this.pomodoroFocusMinutes &&
          other.shortBreakMinutes == this.shortBreakMinutes &&
          other.longBreakMinutes == this.longBreakMinutes &&
          other.longBreakInterval == this.longBreakInterval &&
          other.notificationEnabled == this.notificationEnabled &&
          other.autoCompleteTaskOnFocus == this.autoCompleteTaskOnFocus &&
          other.focusMusicEnabled == this.focusMusicEnabled &&
          other.focusMusicUri == this.focusMusicUri &&
          other.focusMusicName == this.focusMusicName &&
          other.timelineStartMinutes == this.timelineStartMinutes &&
          other.timelineEndMinutes == this.timelineEndMinutes &&
          other.autoColorEnabled == this.autoColorEnabled &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsRow> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<String> weekViewMode;
  final Value<String> scheduleZoom;
  final Value<double> detailHourHeight;
  final Value<double> overviewHourHeight;
  final Value<int> pomodoroFocusMinutes;
  final Value<int> shortBreakMinutes;
  final Value<int> longBreakMinutes;
  final Value<int> longBreakInterval;
  final Value<bool> notificationEnabled;
  final Value<bool> autoCompleteTaskOnFocus;
  final Value<bool> focusMusicEnabled;
  final Value<String> focusMusicUri;
  final Value<String> focusMusicName;
  final Value<int> timelineStartMinutes;
  final Value<int> timelineEndMinutes;
  final Value<bool> autoColorEnabled;
  final Value<DateTime> updatedAt;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.weekViewMode = const Value.absent(),
    this.scheduleZoom = const Value.absent(),
    this.detailHourHeight = const Value.absent(),
    this.overviewHourHeight = const Value.absent(),
    this.pomodoroFocusMinutes = const Value.absent(),
    this.shortBreakMinutes = const Value.absent(),
    this.longBreakMinutes = const Value.absent(),
    this.longBreakInterval = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
    this.autoCompleteTaskOnFocus = const Value.absent(),
    this.focusMusicEnabled = const Value.absent(),
    this.focusMusicUri = const Value.absent(),
    this.focusMusicName = const Value.absent(),
    this.timelineStartMinutes = const Value.absent(),
    this.timelineEndMinutes = const Value.absent(),
    this.autoColorEnabled = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.weekViewMode = const Value.absent(),
    this.scheduleZoom = const Value.absent(),
    this.detailHourHeight = const Value.absent(),
    this.overviewHourHeight = const Value.absent(),
    this.pomodoroFocusMinutes = const Value.absent(),
    this.shortBreakMinutes = const Value.absent(),
    this.longBreakMinutes = const Value.absent(),
    this.longBreakInterval = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
    this.autoCompleteTaskOnFocus = const Value.absent(),
    this.focusMusicEnabled = const Value.absent(),
    this.focusMusicUri = const Value.absent(),
    this.focusMusicName = const Value.absent(),
    this.timelineStartMinutes = const Value.absent(),
    this.timelineEndMinutes = const Value.absent(),
    this.autoColorEnabled = const Value.absent(),
    required DateTime updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<AppSettingsRow> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<String>? weekViewMode,
    Expression<String>? scheduleZoom,
    Expression<double>? detailHourHeight,
    Expression<double>? overviewHourHeight,
    Expression<int>? pomodoroFocusMinutes,
    Expression<int>? shortBreakMinutes,
    Expression<int>? longBreakMinutes,
    Expression<int>? longBreakInterval,
    Expression<bool>? notificationEnabled,
    Expression<bool>? autoCompleteTaskOnFocus,
    Expression<bool>? focusMusicEnabled,
    Expression<String>? focusMusicUri,
    Expression<String>? focusMusicName,
    Expression<int>? timelineStartMinutes,
    Expression<int>? timelineEndMinutes,
    Expression<bool>? autoColorEnabled,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (weekViewMode != null) 'week_view_mode': weekViewMode,
      if (scheduleZoom != null) 'schedule_zoom': scheduleZoom,
      if (detailHourHeight != null) 'detail_hour_height': detailHourHeight,
      if (overviewHourHeight != null)
        'overview_hour_height': overviewHourHeight,
      if (pomodoroFocusMinutes != null)
        'pomodoro_focus_minutes': pomodoroFocusMinutes,
      if (shortBreakMinutes != null) 'short_break_minutes': shortBreakMinutes,
      if (longBreakMinutes != null) 'long_break_minutes': longBreakMinutes,
      if (longBreakInterval != null) 'long_break_interval': longBreakInterval,
      if (notificationEnabled != null)
        'notification_enabled': notificationEnabled,
      if (autoCompleteTaskOnFocus != null)
        'auto_complete_task_on_focus': autoCompleteTaskOnFocus,
      if (focusMusicEnabled != null) 'focus_music_enabled': focusMusicEnabled,
      if (focusMusicUri != null) 'focus_music_uri': focusMusicUri,
      if (focusMusicName != null) 'focus_music_name': focusMusicName,
      if (timelineStartMinutes != null)
        'timeline_start_minutes': timelineStartMinutes,
      if (timelineEndMinutes != null)
        'timeline_end_minutes': timelineEndMinutes,
      if (autoColorEnabled != null) 'auto_color_enabled': autoColorEnabled,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<String>? weekViewMode,
    Value<String>? scheduleZoom,
    Value<double>? detailHourHeight,
    Value<double>? overviewHourHeight,
    Value<int>? pomodoroFocusMinutes,
    Value<int>? shortBreakMinutes,
    Value<int>? longBreakMinutes,
    Value<int>? longBreakInterval,
    Value<bool>? notificationEnabled,
    Value<bool>? autoCompleteTaskOnFocus,
    Value<bool>? focusMusicEnabled,
    Value<String>? focusMusicUri,
    Value<String>? focusMusicName,
    Value<int>? timelineStartMinutes,
    Value<int>? timelineEndMinutes,
    Value<bool>? autoColorEnabled,
    Value<DateTime>? updatedAt,
  }) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      weekViewMode: weekViewMode ?? this.weekViewMode,
      scheduleZoom: scheduleZoom ?? this.scheduleZoom,
      detailHourHeight: detailHourHeight ?? this.detailHourHeight,
      overviewHourHeight: overviewHourHeight ?? this.overviewHourHeight,
      pomodoroFocusMinutes: pomodoroFocusMinutes ?? this.pomodoroFocusMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      autoCompleteTaskOnFocus:
          autoCompleteTaskOnFocus ?? this.autoCompleteTaskOnFocus,
      focusMusicEnabled: focusMusicEnabled ?? this.focusMusicEnabled,
      focusMusicUri: focusMusicUri ?? this.focusMusicUri,
      focusMusicName: focusMusicName ?? this.focusMusicName,
      timelineStartMinutes: timelineStartMinutes ?? this.timelineStartMinutes,
      timelineEndMinutes: timelineEndMinutes ?? this.timelineEndMinutes,
      autoColorEnabled: autoColorEnabled ?? this.autoColorEnabled,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (weekViewMode.present) {
      map['week_view_mode'] = Variable<String>(weekViewMode.value);
    }
    if (scheduleZoom.present) {
      map['schedule_zoom'] = Variable<String>(scheduleZoom.value);
    }
    if (detailHourHeight.present) {
      map['detail_hour_height'] = Variable<double>(detailHourHeight.value);
    }
    if (overviewHourHeight.present) {
      map['overview_hour_height'] = Variable<double>(overviewHourHeight.value);
    }
    if (pomodoroFocusMinutes.present) {
      map['pomodoro_focus_minutes'] = Variable<int>(pomodoroFocusMinutes.value);
    }
    if (shortBreakMinutes.present) {
      map['short_break_minutes'] = Variable<int>(shortBreakMinutes.value);
    }
    if (longBreakMinutes.present) {
      map['long_break_minutes'] = Variable<int>(longBreakMinutes.value);
    }
    if (longBreakInterval.present) {
      map['long_break_interval'] = Variable<int>(longBreakInterval.value);
    }
    if (notificationEnabled.present) {
      map['notification_enabled'] = Variable<bool>(notificationEnabled.value);
    }
    if (autoCompleteTaskOnFocus.present) {
      map['auto_complete_task_on_focus'] = Variable<bool>(
        autoCompleteTaskOnFocus.value,
      );
    }
    if (focusMusicEnabled.present) {
      map['focus_music_enabled'] = Variable<bool>(focusMusicEnabled.value);
    }
    if (focusMusicUri.present) {
      map['focus_music_uri'] = Variable<String>(focusMusicUri.value);
    }
    if (focusMusicName.present) {
      map['focus_music_name'] = Variable<String>(focusMusicName.value);
    }
    if (timelineStartMinutes.present) {
      map['timeline_start_minutes'] = Variable<int>(timelineStartMinutes.value);
    }
    if (timelineEndMinutes.present) {
      map['timeline_end_minutes'] = Variable<int>(timelineEndMinutes.value);
    }
    if (autoColorEnabled.present) {
      map['auto_color_enabled'] = Variable<bool>(autoColorEnabled.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('weekViewMode: $weekViewMode, ')
          ..write('scheduleZoom: $scheduleZoom, ')
          ..write('detailHourHeight: $detailHourHeight, ')
          ..write('overviewHourHeight: $overviewHourHeight, ')
          ..write('pomodoroFocusMinutes: $pomodoroFocusMinutes, ')
          ..write('shortBreakMinutes: $shortBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('longBreakInterval: $longBreakInterval, ')
          ..write('notificationEnabled: $notificationEnabled, ')
          ..write('autoCompleteTaskOnFocus: $autoCompleteTaskOnFocus, ')
          ..write('focusMusicEnabled: $focusMusicEnabled, ')
          ..write('focusMusicUri: $focusMusicUri, ')
          ..write('focusMusicName: $focusMusicName, ')
          ..write('timelineStartMinutes: $timelineStartMinutes, ')
          ..write('timelineEndMinutes: $timelineEndMinutes, ')
          ..write('autoColorEnabled: $autoColorEnabled, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FocusPresetsTable extends FocusPresets
    with TableInfo<$FocusPresetsTable, FocusPresetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusPresetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, minutes, colorValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_presets';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusPresetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusPresetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusPresetRow(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      minutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}minutes'],
          )!,
      colorValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}color_value'],
          )!,
    );
  }

  @override
  $FocusPresetsTable createAlias(String alias) {
    return $FocusPresetsTable(attachedDatabase, alias);
  }
}

class FocusPresetRow extends DataClass implements Insertable<FocusPresetRow> {
  final int id;
  final String title;
  final int minutes;
  final int colorValue;
  const FocusPresetRow({
    required this.id,
    required this.title,
    required this.minutes,
    required this.colorValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['minutes'] = Variable<int>(minutes);
    map['color_value'] = Variable<int>(colorValue);
    return map;
  }

  FocusPresetsCompanion toCompanion(bool nullToAbsent) {
    return FocusPresetsCompanion(
      id: Value(id),
      title: Value(title),
      minutes: Value(minutes),
      colorValue: Value(colorValue),
    );
  }

  factory FocusPresetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusPresetRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      minutes: serializer.fromJson<int>(json['minutes']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'minutes': serializer.toJson<int>(minutes),
      'colorValue': serializer.toJson<int>(colorValue),
    };
  }

  FocusPresetRow copyWith({
    int? id,
    String? title,
    int? minutes,
    int? colorValue,
  }) => FocusPresetRow(
    id: id ?? this.id,
    title: title ?? this.title,
    minutes: minutes ?? this.minutes,
    colorValue: colorValue ?? this.colorValue,
  );
  FocusPresetRow copyWithCompanion(FocusPresetsCompanion data) {
    return FocusPresetRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusPresetRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('minutes: $minutes, ')
          ..write('colorValue: $colorValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, minutes, colorValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusPresetRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.minutes == this.minutes &&
          other.colorValue == this.colorValue);
}

class FocusPresetsCompanion extends UpdateCompanion<FocusPresetRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> minutes;
  final Value<int> colorValue;
  const FocusPresetsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.minutes = const Value.absent(),
    this.colorValue = const Value.absent(),
  });
  FocusPresetsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.minutes = const Value.absent(),
    required int colorValue,
  }) : title = Value(title),
       colorValue = Value(colorValue);
  static Insertable<FocusPresetRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? minutes,
    Expression<int>? colorValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (minutes != null) 'minutes': minutes,
      if (colorValue != null) 'color_value': colorValue,
    });
  }

  FocusPresetsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? minutes,
    Value<int>? colorValue,
  }) {
    return FocusPresetsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      minutes: minutes ?? this.minutes,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusPresetsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('minutes: $minutes, ')
          ..write('colorValue: $colorValue')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlanTasksTable planTasks = $PlanTasksTable(this);
  late final $ActivityRecordsTable activityRecords = $ActivityRecordsTable(
    this,
  );
  late final $DailySummariesTable dailySummaries = $DailySummariesTable(this);
  late final $TaskCategoriesTable taskCategories = $TaskCategoriesTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $ActiveTimersTable activeTimers = $ActiveTimersTable(this);
  late final $MonthlyGoalsTable monthlyGoals = $MonthlyGoalsTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final $FocusPresetsTable focusPresets = $FocusPresetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    planTasks,
    activityRecords,
    dailySummaries,
    taskCategories,
    focusSessions,
    activeTimers,
    monthlyGoals,
    appSettingsTable,
    focusPresets,
  ];
}

typedef $$PlanTasksTableCreateCompanionBuilder =
    PlanTasksCompanion Function({
      Value<int> id,
      required String title,
      required DateTime taskDate,
      required int startMinutes,
      required int endMinutes,
      required int colorValue,
      Value<String> note,
      Value<bool> isCompleted,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int?> categoryId,
      Value<bool> isLocked,
      Value<bool> isAllDay,
      Value<int> sortOrder,
      Value<DateTime?> completedAt,
      Value<int?> plannedDurationMinutes,
      Value<int?> focusMinutes,
    });
typedef $$PlanTasksTableUpdateCompanionBuilder =
    PlanTasksCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<DateTime> taskDate,
      Value<int> startMinutes,
      Value<int> endMinutes,
      Value<int> colorValue,
      Value<String> note,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int?> categoryId,
      Value<bool> isLocked,
      Value<bool> isAllDay,
      Value<int> sortOrder,
      Value<DateTime?> completedAt,
      Value<int?> plannedDurationMinutes,
      Value<int?> focusMinutes,
    });

class $$PlanTasksTableFilterComposer
    extends Composer<_$AppDatabase, $PlanTasksTable> {
  $$PlanTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get taskDate => $composableBuilder(
    column: $table.taskDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedDurationMinutes => $composableBuilder(
    column: $table.plannedDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusMinutes => $composableBuilder(
    column: $table.focusMinutes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlanTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanTasksTable> {
  $$PlanTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get taskDate => $composableBuilder(
    column: $table.taskDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedDurationMinutes => $composableBuilder(
    column: $table.plannedDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusMinutes => $composableBuilder(
    column: $table.focusMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlanTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanTasksTable> {
  $$PlanTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get taskDate =>
      $composableBuilder(column: $table.taskDate, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  GeneratedColumn<bool> get isAllDay =>
      $composableBuilder(column: $table.isAllDay, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedDurationMinutes => $composableBuilder(
    column: $table.plannedDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusMinutes => $composableBuilder(
    column: $table.focusMinutes,
    builder: (column) => column,
  );
}

class $$PlanTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanTasksTable,
          PlanTaskRow,
          $$PlanTasksTableFilterComposer,
          $$PlanTasksTableOrderingComposer,
          $$PlanTasksTableAnnotationComposer,
          $$PlanTasksTableCreateCompanionBuilder,
          $$PlanTasksTableUpdateCompanionBuilder,
          (
            PlanTaskRow,
            BaseReferences<_$AppDatabase, $PlanTasksTable, PlanTaskRow>,
          ),
          PlanTaskRow,
          PrefetchHooks Function()
        > {
  $$PlanTasksTableTableManager(_$AppDatabase db, $PlanTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PlanTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PlanTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PlanTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> taskDate = const Value.absent(),
                Value<int> startMinutes = const Value.absent(),
                Value<int> endMinutes = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<bool> isAllDay = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> plannedDurationMinutes = const Value.absent(),
                Value<int?> focusMinutes = const Value.absent(),
              }) => PlanTasksCompanion(
                id: id,
                title: title,
                taskDate: taskDate,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                colorValue: colorValue,
                note: note,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                categoryId: categoryId,
                isLocked: isLocked,
                isAllDay: isAllDay,
                sortOrder: sortOrder,
                completedAt: completedAt,
                plannedDurationMinutes: plannedDurationMinutes,
                focusMinutes: focusMinutes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required DateTime taskDate,
                required int startMinutes,
                required int endMinutes,
                required int colorValue,
                Value<String> note = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int?> categoryId = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<bool> isAllDay = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> plannedDurationMinutes = const Value.absent(),
                Value<int?> focusMinutes = const Value.absent(),
              }) => PlanTasksCompanion.insert(
                id: id,
                title: title,
                taskDate: taskDate,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                colorValue: colorValue,
                note: note,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                categoryId: categoryId,
                isLocked: isLocked,
                isAllDay: isAllDay,
                sortOrder: sortOrder,
                completedAt: completedAt,
                plannedDurationMinutes: plannedDurationMinutes,
                focusMinutes: focusMinutes,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlanTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanTasksTable,
      PlanTaskRow,
      $$PlanTasksTableFilterComposer,
      $$PlanTasksTableOrderingComposer,
      $$PlanTasksTableAnnotationComposer,
      $$PlanTasksTableCreateCompanionBuilder,
      $$PlanTasksTableUpdateCompanionBuilder,
      (
        PlanTaskRow,
        BaseReferences<_$AppDatabase, $PlanTasksTable, PlanTaskRow>,
      ),
      PlanTaskRow,
      PrefetchHooks Function()
    >;
typedef $$ActivityRecordsTableCreateCompanionBuilder =
    ActivityRecordsCompanion Function({
      Value<int> id,
      required DateTime recordDate,
      required String title,
      Value<int?> startMinutes,
      Value<int?> endMinutes,
      required int durationMinutes,
      Value<String> note,
      Value<bool> isCompleted,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ActivityRecordsTableUpdateCompanionBuilder =
    ActivityRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> recordDate,
      Value<String> title,
      Value<int?> startMinutes,
      Value<int?> endMinutes,
      Value<int> durationMinutes,
      Value<String> note,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ActivityRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityRecordsTable> {
  $$ActivityRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityRecordsTable> {
  $$ActivityRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityRecordsTable> {
  $$ActivityRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get recordDate => $composableBuilder(
    column: $table.recordDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ActivityRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityRecordsTable,
          ActivityRecordRow,
          $$ActivityRecordsTableFilterComposer,
          $$ActivityRecordsTableOrderingComposer,
          $$ActivityRecordsTableAnnotationComposer,
          $$ActivityRecordsTableCreateCompanionBuilder,
          $$ActivityRecordsTableUpdateCompanionBuilder,
          (
            ActivityRecordRow,
            BaseReferences<
              _$AppDatabase,
              $ActivityRecordsTable,
              ActivityRecordRow
            >,
          ),
          ActivityRecordRow,
          PrefetchHooks Function()
        > {
  $$ActivityRecordsTableTableManager(
    _$AppDatabase db,
    $ActivityRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$ActivityRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ActivityRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ActivityRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> recordDate = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> startMinutes = const Value.absent(),
                Value<int?> endMinutes = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ActivityRecordsCompanion(
                id: id,
                recordDate: recordDate,
                title: title,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                durationMinutes: durationMinutes,
                note: note,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime recordDate,
                required String title,
                Value<int?> startMinutes = const Value.absent(),
                Value<int?> endMinutes = const Value.absent(),
                required int durationMinutes,
                Value<String> note = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ActivityRecordsCompanion.insert(
                id: id,
                recordDate: recordDate,
                title: title,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                durationMinutes: durationMinutes,
                note: note,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityRecordsTable,
      ActivityRecordRow,
      $$ActivityRecordsTableFilterComposer,
      $$ActivityRecordsTableOrderingComposer,
      $$ActivityRecordsTableAnnotationComposer,
      $$ActivityRecordsTableCreateCompanionBuilder,
      $$ActivityRecordsTableUpdateCompanionBuilder,
      (
        ActivityRecordRow,
        BaseReferences<_$AppDatabase, $ActivityRecordsTable, ActivityRecordRow>,
      ),
      ActivityRecordRow,
      PrefetchHooks Function()
    >;
typedef $$DailySummariesTableCreateCompanionBuilder =
    DailySummariesCompanion Function({
      Value<int> id,
      required DateTime summaryDate,
      Value<String> content,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$DailySummariesTableUpdateCompanionBuilder =
    DailySummariesCompanion Function({
      Value<int> id,
      Value<DateTime> summaryDate,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$DailySummariesTableFilterComposer
    extends Composer<_$AppDatabase, $DailySummariesTable> {
  $$DailySummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get summaryDate => $composableBuilder(
    column: $table.summaryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailySummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailySummariesTable> {
  $$DailySummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get summaryDate => $composableBuilder(
    column: $table.summaryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailySummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailySummariesTable> {
  $$DailySummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get summaryDate => $composableBuilder(
    column: $table.summaryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailySummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailySummariesTable,
          DailySummaryRow,
          $$DailySummariesTableFilterComposer,
          $$DailySummariesTableOrderingComposer,
          $$DailySummariesTableAnnotationComposer,
          $$DailySummariesTableCreateCompanionBuilder,
          $$DailySummariesTableUpdateCompanionBuilder,
          (
            DailySummaryRow,
            BaseReferences<
              _$AppDatabase,
              $DailySummariesTable,
              DailySummaryRow
            >,
          ),
          DailySummaryRow,
          PrefetchHooks Function()
        > {
  $$DailySummariesTableTableManager(
    _$AppDatabase db,
    $DailySummariesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DailySummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$DailySummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$DailySummariesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> summaryDate = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailySummariesCompanion(
                id: id,
                summaryDate: summaryDate,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime summaryDate,
                Value<String> content = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => DailySummariesCompanion.insert(
                id: id,
                summaryDate: summaryDate,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailySummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailySummariesTable,
      DailySummaryRow,
      $$DailySummariesTableFilterComposer,
      $$DailySummariesTableOrderingComposer,
      $$DailySummariesTableAnnotationComposer,
      $$DailySummariesTableCreateCompanionBuilder,
      $$DailySummariesTableUpdateCompanionBuilder,
      (
        DailySummaryRow,
        BaseReferences<_$AppDatabase, $DailySummariesTable, DailySummaryRow>,
      ),
      DailySummaryRow,
      PrefetchHooks Function()
    >;
typedef $$TaskCategoriesTableCreateCompanionBuilder =
    TaskCategoriesCompanion Function({
      Value<int> id,
      required String name,
      required int colorValue,
      Value<bool> isDefault,
      required DateTime createdAt,
    });
typedef $$TaskCategoriesTableUpdateCompanionBuilder =
    TaskCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> colorValue,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
    });

class $$TaskCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCategoriesTable> {
  $$TaskCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCategoriesTable> {
  $$TaskCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCategoriesTable> {
  $$TaskCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TaskCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskCategoriesTable,
          TaskCategoryRow,
          $$TaskCategoriesTableFilterComposer,
          $$TaskCategoriesTableOrderingComposer,
          $$TaskCategoriesTableAnnotationComposer,
          $$TaskCategoriesTableCreateCompanionBuilder,
          $$TaskCategoriesTableUpdateCompanionBuilder,
          (
            TaskCategoryRow,
            BaseReferences<
              _$AppDatabase,
              $TaskCategoriesTable,
              TaskCategoryRow
            >,
          ),
          TaskCategoryRow,
          PrefetchHooks Function()
        > {
  $$TaskCategoriesTableTableManager(
    _$AppDatabase db,
    $TaskCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TaskCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$TaskCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TaskCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TaskCategoriesCompanion(
                id: id,
                name: name,
                colorValue: colorValue,
                isDefault: isDefault,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int colorValue,
                Value<bool> isDefault = const Value.absent(),
                required DateTime createdAt,
              }) => TaskCategoriesCompanion.insert(
                id: id,
                name: name,
                colorValue: colorValue,
                isDefault: isDefault,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskCategoriesTable,
      TaskCategoryRow,
      $$TaskCategoriesTableFilterComposer,
      $$TaskCategoriesTableOrderingComposer,
      $$TaskCategoriesTableAnnotationComposer,
      $$TaskCategoriesTableCreateCompanionBuilder,
      $$TaskCategoriesTableUpdateCompanionBuilder,
      (
        TaskCategoryRow,
        BaseReferences<_$AppDatabase, $TaskCategoriesTable, TaskCategoryRow>,
      ),
      TaskCategoryRow,
      PrefetchHooks Function()
    >;
typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<int> id,
      required DateTime sessionDate,
      required DateTime startedAt,
      required DateTime endedAt,
      required int plannedMinutes,
      required int actualMinutes,
      required String mode,
      Value<bool> completed,
      Value<int?> taskId,
      Value<int?> categoryId,
      Value<String> note,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> sessionDate,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> plannedMinutes,
      Value<int> actualMinutes,
      Value<String> mode,
      Value<bool> completed,
      Value<int?> taskId,
      Value<int?> categoryId,
      Value<String> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$FocusSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sessionDate => $composableBuilder(
    column: $table.sessionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sessionDate => $composableBuilder(
    column: $table.sessionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get sessionDate => $composableBuilder(
    column: $table.sessionDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionsTable,
          FocusSessionRow,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (
            FocusSessionRow,
            BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSessionRow>,
          ),
          FocusSessionRow,
          PrefetchHooks Function()
        > {
  $$FocusSessionsTableTableManager(_$AppDatabase db, $FocusSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$FocusSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> sessionDate = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> plannedMinutes = const Value.absent(),
                Value<int> actualMinutes = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                sessionDate: sessionDate,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedMinutes: plannedMinutes,
                actualMinutes: actualMinutes,
                mode: mode,
                completed: completed,
                taskId: taskId,
                categoryId: categoryId,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime sessionDate,
                required DateTime startedAt,
                required DateTime endedAt,
                required int plannedMinutes,
                required int actualMinutes,
                required String mode,
                Value<bool> completed = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> note = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => FocusSessionsCompanion.insert(
                id: id,
                sessionDate: sessionDate,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedMinutes: plannedMinutes,
                actualMinutes: actualMinutes,
                mode: mode,
                completed: completed,
                taskId: taskId,
                categoryId: categoryId,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionsTable,
      FocusSessionRow,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (
        FocusSessionRow,
        BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSessionRow>,
      ),
      FocusSessionRow,
      PrefetchHooks Function()
    >;
typedef $$ActiveTimersTableCreateCompanionBuilder =
    ActiveTimersCompanion Function({
      Value<int> id,
      required String mode,
      required String phase,
      required DateTime startedAt,
      required DateTime expectedEndAt,
      required int remainingSeconds,
      Value<int?> totalSeconds,
      Value<String> title,
      required bool isRunning,
      Value<int> cycleCount,
      Value<int?> taskId,
      Value<int?> categoryId,
      required DateTime updatedAt,
    });
typedef $$ActiveTimersTableUpdateCompanionBuilder =
    ActiveTimersCompanion Function({
      Value<int> id,
      Value<String> mode,
      Value<String> phase,
      Value<DateTime> startedAt,
      Value<DateTime> expectedEndAt,
      Value<int> remainingSeconds,
      Value<int?> totalSeconds,
      Value<String> title,
      Value<bool> isRunning,
      Value<int> cycleCount,
      Value<int?> taskId,
      Value<int?> categoryId,
      Value<DateTime> updatedAt,
    });

class $$ActiveTimersTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveTimersTable> {
  $$ActiveTimersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expectedEndAt => $composableBuilder(
    column: $table.expectedEndAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingSeconds => $composableBuilder(
    column: $table.remainingSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSeconds => $composableBuilder(
    column: $table.totalSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRunning => $composableBuilder(
    column: $table.isRunning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleCount => $composableBuilder(
    column: $table.cycleCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveTimersTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveTimersTable> {
  $$ActiveTimersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expectedEndAt => $composableBuilder(
    column: $table.expectedEndAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingSeconds => $composableBuilder(
    column: $table.remainingSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSeconds => $composableBuilder(
    column: $table.totalSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRunning => $composableBuilder(
    column: $table.isRunning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleCount => $composableBuilder(
    column: $table.cycleCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveTimersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveTimersTable> {
  $$ActiveTimersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expectedEndAt => $composableBuilder(
    column: $table.expectedEndAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remainingSeconds => $composableBuilder(
    column: $table.remainingSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalSeconds => $composableBuilder(
    column: $table.totalSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isRunning =>
      $composableBuilder(column: $table.isRunning, builder: (column) => column);

  GeneratedColumn<int> get cycleCount => $composableBuilder(
    column: $table.cycleCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ActiveTimersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveTimersTable,
          ActiveTimerRow,
          $$ActiveTimersTableFilterComposer,
          $$ActiveTimersTableOrderingComposer,
          $$ActiveTimersTableAnnotationComposer,
          $$ActiveTimersTableCreateCompanionBuilder,
          $$ActiveTimersTableUpdateCompanionBuilder,
          (
            ActiveTimerRow,
            BaseReferences<_$AppDatabase, $ActiveTimersTable, ActiveTimerRow>,
          ),
          ActiveTimerRow,
          PrefetchHooks Function()
        > {
  $$ActiveTimersTableTableManager(_$AppDatabase db, $ActiveTimersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ActiveTimersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ActiveTimersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$ActiveTimersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> expectedEndAt = const Value.absent(),
                Value<int> remainingSeconds = const Value.absent(),
                Value<int?> totalSeconds = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> isRunning = const Value.absent(),
                Value<int> cycleCount = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ActiveTimersCompanion(
                id: id,
                mode: mode,
                phase: phase,
                startedAt: startedAt,
                expectedEndAt: expectedEndAt,
                remainingSeconds: remainingSeconds,
                totalSeconds: totalSeconds,
                title: title,
                isRunning: isRunning,
                cycleCount: cycleCount,
                taskId: taskId,
                categoryId: categoryId,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String mode,
                required String phase,
                required DateTime startedAt,
                required DateTime expectedEndAt,
                required int remainingSeconds,
                Value<int?> totalSeconds = const Value.absent(),
                Value<String> title = const Value.absent(),
                required bool isRunning,
                Value<int> cycleCount = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                required DateTime updatedAt,
              }) => ActiveTimersCompanion.insert(
                id: id,
                mode: mode,
                phase: phase,
                startedAt: startedAt,
                expectedEndAt: expectedEndAt,
                remainingSeconds: remainingSeconds,
                totalSeconds: totalSeconds,
                title: title,
                isRunning: isRunning,
                cycleCount: cycleCount,
                taskId: taskId,
                categoryId: categoryId,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActiveTimersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveTimersTable,
      ActiveTimerRow,
      $$ActiveTimersTableFilterComposer,
      $$ActiveTimersTableOrderingComposer,
      $$ActiveTimersTableAnnotationComposer,
      $$ActiveTimersTableCreateCompanionBuilder,
      $$ActiveTimersTableUpdateCompanionBuilder,
      (
        ActiveTimerRow,
        BaseReferences<_$AppDatabase, $ActiveTimersTable, ActiveTimerRow>,
      ),
      ActiveTimerRow,
      PrefetchHooks Function()
    >;
typedef $$MonthlyGoalsTableCreateCompanionBuilder =
    MonthlyGoalsCompanion Function({
      Value<int> id,
      required String yearMonth,
      required String content,
      Value<bool> isCompleted,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$MonthlyGoalsTableUpdateCompanionBuilder =
    MonthlyGoalsCompanion Function({
      Value<int> id,
      Value<String> yearMonth,
      Value<String> content,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$MonthlyGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyGoalsTable> {
  $$MonthlyGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get yearMonth => $composableBuilder(
    column: $table.yearMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MonthlyGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyGoalsTable> {
  $$MonthlyGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get yearMonth => $composableBuilder(
    column: $table.yearMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthlyGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyGoalsTable> {
  $$MonthlyGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get yearMonth =>
      $composableBuilder(column: $table.yearMonth, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MonthlyGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthlyGoalsTable,
          MonthlyGoalRow,
          $$MonthlyGoalsTableFilterComposer,
          $$MonthlyGoalsTableOrderingComposer,
          $$MonthlyGoalsTableAnnotationComposer,
          $$MonthlyGoalsTableCreateCompanionBuilder,
          $$MonthlyGoalsTableUpdateCompanionBuilder,
          (
            MonthlyGoalRow,
            BaseReferences<_$AppDatabase, $MonthlyGoalsTable, MonthlyGoalRow>,
          ),
          MonthlyGoalRow,
          PrefetchHooks Function()
        > {
  $$MonthlyGoalsTableTableManager(_$AppDatabase db, $MonthlyGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MonthlyGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$MonthlyGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$MonthlyGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> yearMonth = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MonthlyGoalsCompanion(
                id: id,
                yearMonth: yearMonth,
                content: content,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String yearMonth,
                required String content,
                Value<bool> isCompleted = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => MonthlyGoalsCompanion.insert(
                id: id,
                yearMonth: yearMonth,
                content: content,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MonthlyGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthlyGoalsTable,
      MonthlyGoalRow,
      $$MonthlyGoalsTableFilterComposer,
      $$MonthlyGoalsTableOrderingComposer,
      $$MonthlyGoalsTableAnnotationComposer,
      $$MonthlyGoalsTableCreateCompanionBuilder,
      $$MonthlyGoalsTableUpdateCompanionBuilder,
      (
        MonthlyGoalRow,
        BaseReferences<_$AppDatabase, $MonthlyGoalsTable, MonthlyGoalRow>,
      ),
      MonthlyGoalRow,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<String> weekViewMode,
      Value<String> scheduleZoom,
      Value<double> detailHourHeight,
      Value<double> overviewHourHeight,
      Value<int> pomodoroFocusMinutes,
      Value<int> shortBreakMinutes,
      Value<int> longBreakMinutes,
      Value<int> longBreakInterval,
      Value<bool> notificationEnabled,
      Value<bool> autoCompleteTaskOnFocus,
      Value<bool> focusMusicEnabled,
      Value<String> focusMusicUri,
      Value<String> focusMusicName,
      Value<int> timelineStartMinutes,
      Value<int> timelineEndMinutes,
      Value<bool> autoColorEnabled,
      required DateTime updatedAt,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<String> weekViewMode,
      Value<String> scheduleZoom,
      Value<double> detailHourHeight,
      Value<double> overviewHourHeight,
      Value<int> pomodoroFocusMinutes,
      Value<int> shortBreakMinutes,
      Value<int> longBreakMinutes,
      Value<int> longBreakInterval,
      Value<bool> notificationEnabled,
      Value<bool> autoCompleteTaskOnFocus,
      Value<bool> focusMusicEnabled,
      Value<String> focusMusicUri,
      Value<String> focusMusicName,
      Value<int> timelineStartMinutes,
      Value<int> timelineEndMinutes,
      Value<bool> autoColorEnabled,
      Value<DateTime> updatedAt,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekViewMode => $composableBuilder(
    column: $table.weekViewMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduleZoom => $composableBuilder(
    column: $table.scheduleZoom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get detailHourHeight => $composableBuilder(
    column: $table.detailHourHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get overviewHourHeight => $composableBuilder(
    column: $table.overviewHourHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pomodoroFocusMinutes => $composableBuilder(
    column: $table.pomodoroFocusMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBreakInterval => $composableBuilder(
    column: $table.longBreakInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationEnabled => $composableBuilder(
    column: $table.notificationEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoCompleteTaskOnFocus => $composableBuilder(
    column: $table.autoCompleteTaskOnFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get focusMusicEnabled => $composableBuilder(
    column: $table.focusMusicEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focusMusicUri => $composableBuilder(
    column: $table.focusMusicUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focusMusicName => $composableBuilder(
    column: $table.focusMusicName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timelineStartMinutes => $composableBuilder(
    column: $table.timelineStartMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timelineEndMinutes => $composableBuilder(
    column: $table.timelineEndMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoColorEnabled => $composableBuilder(
    column: $table.autoColorEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekViewMode => $composableBuilder(
    column: $table.weekViewMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduleZoom => $composableBuilder(
    column: $table.scheduleZoom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get detailHourHeight => $composableBuilder(
    column: $table.detailHourHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get overviewHourHeight => $composableBuilder(
    column: $table.overviewHourHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pomodoroFocusMinutes => $composableBuilder(
    column: $table.pomodoroFocusMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBreakInterval => $composableBuilder(
    column: $table.longBreakInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationEnabled => $composableBuilder(
    column: $table.notificationEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoCompleteTaskOnFocus => $composableBuilder(
    column: $table.autoCompleteTaskOnFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get focusMusicEnabled => $composableBuilder(
    column: $table.focusMusicEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focusMusicUri => $composableBuilder(
    column: $table.focusMusicUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focusMusicName => $composableBuilder(
    column: $table.focusMusicName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timelineStartMinutes => $composableBuilder(
    column: $table.timelineStartMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timelineEndMinutes => $composableBuilder(
    column: $table.timelineEndMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoColorEnabled => $composableBuilder(
    column: $table.autoColorEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get weekViewMode => $composableBuilder(
    column: $table.weekViewMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduleZoom => $composableBuilder(
    column: $table.scheduleZoom,
    builder: (column) => column,
  );

  GeneratedColumn<double> get detailHourHeight => $composableBuilder(
    column: $table.detailHourHeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get overviewHourHeight => $composableBuilder(
    column: $table.overviewHourHeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pomodoroFocusMinutes => $composableBuilder(
    column: $table.pomodoroFocusMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBreakInterval => $composableBuilder(
    column: $table.longBreakInterval,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationEnabled => $composableBuilder(
    column: $table.notificationEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoCompleteTaskOnFocus => $composableBuilder(
    column: $table.autoCompleteTaskOnFocus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get focusMusicEnabled => $composableBuilder(
    column: $table.focusMusicEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get focusMusicUri => $composableBuilder(
    column: $table.focusMusicUri,
    builder: (column) => column,
  );

  GeneratedColumn<String> get focusMusicName => $composableBuilder(
    column: $table.focusMusicName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timelineStartMinutes => $composableBuilder(
    column: $table.timelineStartMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timelineEndMinutes => $composableBuilder(
    column: $table.timelineEndMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoColorEnabled => $composableBuilder(
    column: $table.autoColorEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsRow,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingsRow
            >,
          ),
          AppSettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AppSettingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$AppSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> weekViewMode = const Value.absent(),
                Value<String> scheduleZoom = const Value.absent(),
                Value<double> detailHourHeight = const Value.absent(),
                Value<double> overviewHourHeight = const Value.absent(),
                Value<int> pomodoroFocusMinutes = const Value.absent(),
                Value<int> shortBreakMinutes = const Value.absent(),
                Value<int> longBreakMinutes = const Value.absent(),
                Value<int> longBreakInterval = const Value.absent(),
                Value<bool> notificationEnabled = const Value.absent(),
                Value<bool> autoCompleteTaskOnFocus = const Value.absent(),
                Value<bool> focusMusicEnabled = const Value.absent(),
                Value<String> focusMusicUri = const Value.absent(),
                Value<String> focusMusicName = const Value.absent(),
                Value<int> timelineStartMinutes = const Value.absent(),
                Value<int> timelineEndMinutes = const Value.absent(),
                Value<bool> autoColorEnabled = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppSettingsTableCompanion(
                id: id,
                themeMode: themeMode,
                weekViewMode: weekViewMode,
                scheduleZoom: scheduleZoom,
                detailHourHeight: detailHourHeight,
                overviewHourHeight: overviewHourHeight,
                pomodoroFocusMinutes: pomodoroFocusMinutes,
                shortBreakMinutes: shortBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                longBreakInterval: longBreakInterval,
                notificationEnabled: notificationEnabled,
                autoCompleteTaskOnFocus: autoCompleteTaskOnFocus,
                focusMusicEnabled: focusMusicEnabled,
                focusMusicUri: focusMusicUri,
                focusMusicName: focusMusicName,
                timelineStartMinutes: timelineStartMinutes,
                timelineEndMinutes: timelineEndMinutes,
                autoColorEnabled: autoColorEnabled,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> weekViewMode = const Value.absent(),
                Value<String> scheduleZoom = const Value.absent(),
                Value<double> detailHourHeight = const Value.absent(),
                Value<double> overviewHourHeight = const Value.absent(),
                Value<int> pomodoroFocusMinutes = const Value.absent(),
                Value<int> shortBreakMinutes = const Value.absent(),
                Value<int> longBreakMinutes = const Value.absent(),
                Value<int> longBreakInterval = const Value.absent(),
                Value<bool> notificationEnabled = const Value.absent(),
                Value<bool> autoCompleteTaskOnFocus = const Value.absent(),
                Value<bool> focusMusicEnabled = const Value.absent(),
                Value<String> focusMusicUri = const Value.absent(),
                Value<String> focusMusicName = const Value.absent(),
                Value<int> timelineStartMinutes = const Value.absent(),
                Value<int> timelineEndMinutes = const Value.absent(),
                Value<bool> autoColorEnabled = const Value.absent(),
                required DateTime updatedAt,
              }) => AppSettingsTableCompanion.insert(
                id: id,
                themeMode: themeMode,
                weekViewMode: weekViewMode,
                scheduleZoom: scheduleZoom,
                detailHourHeight: detailHourHeight,
                overviewHourHeight: overviewHourHeight,
                pomodoroFocusMinutes: pomodoroFocusMinutes,
                shortBreakMinutes: shortBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                longBreakInterval: longBreakInterval,
                notificationEnabled: notificationEnabled,
                autoCompleteTaskOnFocus: autoCompleteTaskOnFocus,
                focusMusicEnabled: focusMusicEnabled,
                focusMusicUri: focusMusicUri,
                focusMusicName: focusMusicName,
                timelineStartMinutes: timelineStartMinutes,
                timelineEndMinutes: timelineEndMinutes,
                autoColorEnabled: autoColorEnabled,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsRow,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingsRow,
        BaseReferences<_$AppDatabase, $AppSettingsTableTable, AppSettingsRow>,
      ),
      AppSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$FocusPresetsTableCreateCompanionBuilder =
    FocusPresetsCompanion Function({
      Value<int> id,
      required String title,
      Value<int> minutes,
      required int colorValue,
    });
typedef $$FocusPresetsTableUpdateCompanionBuilder =
    FocusPresetsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> minutes,
      Value<int> colorValue,
    });

class $$FocusPresetsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusPresetsTable> {
  $$FocusPresetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FocusPresetsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusPresetsTable> {
  $$FocusPresetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FocusPresetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusPresetsTable> {
  $$FocusPresetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );
}

class $$FocusPresetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusPresetsTable,
          FocusPresetRow,
          $$FocusPresetsTableFilterComposer,
          $$FocusPresetsTableOrderingComposer,
          $$FocusPresetsTableAnnotationComposer,
          $$FocusPresetsTableCreateCompanionBuilder,
          $$FocusPresetsTableUpdateCompanionBuilder,
          (
            FocusPresetRow,
            BaseReferences<_$AppDatabase, $FocusPresetsTable, FocusPresetRow>,
          ),
          FocusPresetRow,
          PrefetchHooks Function()
        > {
  $$FocusPresetsTableTableManager(_$AppDatabase db, $FocusPresetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$FocusPresetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$FocusPresetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$FocusPresetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
              }) => FocusPresetsCompanion(
                id: id,
                title: title,
                minutes: minutes,
                colorValue: colorValue,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<int> minutes = const Value.absent(),
                required int colorValue,
              }) => FocusPresetsCompanion.insert(
                id: id,
                title: title,
                minutes: minutes,
                colorValue: colorValue,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FocusPresetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusPresetsTable,
      FocusPresetRow,
      $$FocusPresetsTableFilterComposer,
      $$FocusPresetsTableOrderingComposer,
      $$FocusPresetsTableAnnotationComposer,
      $$FocusPresetsTableCreateCompanionBuilder,
      $$FocusPresetsTableUpdateCompanionBuilder,
      (
        FocusPresetRow,
        BaseReferences<_$AppDatabase, $FocusPresetsTable, FocusPresetRow>,
      ),
      FocusPresetRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlanTasksTableTableManager get planTasks =>
      $$PlanTasksTableTableManager(_db, _db.planTasks);
  $$ActivityRecordsTableTableManager get activityRecords =>
      $$ActivityRecordsTableTableManager(_db, _db.activityRecords);
  $$DailySummariesTableTableManager get dailySummaries =>
      $$DailySummariesTableTableManager(_db, _db.dailySummaries);
  $$TaskCategoriesTableTableManager get taskCategories =>
      $$TaskCategoriesTableTableManager(_db, _db.taskCategories);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$ActiveTimersTableTableManager get activeTimers =>
      $$ActiveTimersTableTableManager(_db, _db.activeTimers);
  $$MonthlyGoalsTableTableManager get monthlyGoals =>
      $$MonthlyGoalsTableTableManager(_db, _db.monthlyGoals);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$FocusPresetsTableTableManager get focusPresets =>
      $$FocusPresetsTableTableManager(_db, _db.focusPresets);
}
