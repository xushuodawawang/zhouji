import '../database/app_database.dart';
import '../models/task_category.dart';
import 'plan_task_repository.dart';

class CategoryRepository {
  const CategoryRepository(this._database);

  final AppDatabase _database;

  Stream<List<TaskCategory>> watchAll() => _database.watchCategories().map(
    (rows) =>
        rows
            .map(
              (row) => TaskCategory(
                id: row.id,
                name: row.name,
                colorValue: row.colorValue,
                isDefault: row.isDefault,
              ),
            )
            .toList(),
  );

  Future<int> save({
    int? id,
    required String name,
    required int colorValue,
  }) async {
    if (name.trim().isEmpty) {
      throw const RepositoryException('分类名称不能为空');
    }
    try {
      return await _database.saveCategory(
        id: id,
        name: name.trim(),
        colorValue: colorValue,
      );
    } catch (error) {
      throw RepositoryException('保存分类失败，名称不能重复', error);
    }
  }

  Future<void> delete(TaskCategory category) async {
    if (category.isDefault) {
      throw const RepositoryException('默认分类不能删除');
    }
    await _database.deleteCategory(category.id);
  }
}
