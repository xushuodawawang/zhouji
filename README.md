# 周迹 V2.1

周迹是一款 Flutter 编写的简约离线计划应用，包含周计划、月计划、日计划、每日记录、番茄专注和时间统计。应用不需要登录、服务器或网络请求，所有业务数据都通过 Drift + SQLite 保存在手机的应用私有目录。

当前版本只面向 Android 本地安装使用，不包含应用商店上架配置。


## V2.1 界面与性能更新（2026-09-07）

- 参考 [TickTick 的日历与专注组织方式](https://ticktick.com/home) 和 [Structured 的时间线层次](https://structured.app/)，统一青绿色主题、浅色／深色卡片、导航、分段按钮、表单与弹窗。
- 周迹标识以日历轮廓、Z 形足迹和金色圆点组成。原创 SVG 与 1024px PNG 位于 `assets/branding/`，Android 包含五档密度、API 26 自适应图标和 API 33 主题图标。通知使用无背景的前景图形。
- 主页面与周／月／日视图首次访问时才构建，访问后保留表单和滚动状态；隐藏页停用 Flutter 动画。
- 专注页面仅在状态、阶段、关联任务等变化时更新表单；秒数由独立表盘订阅，隐藏表盘不逐秒刷新。计时控制器仍在应用启动时恢复。
- 应用主题只监听外观设置，并缓存 ThemeData，修改时间轴缩放不再重新生成应用主题。
- 周时间表缓存任务分栏布局，任务、周起点或缩放变化时才失效；拖动预览不重复排序任务。
- 月视图按日期一次分组，避免每个日期格重复扫描任务；小屏日期格有最小高度并可纵向滚动。
- 任务、实际记录、专注记录增加日期查询索引；数据库继续在后台 isolate 执行，不改变原有业务表字段或删除数据。
- 修复长任务下拉框溢出、模式文字换行及记录页重复标题；统计卡片根据可用宽度和文字缩放调整列数。

验证结果：Flutter analyze 无问题，44 项测试通过，包含旧库迁移、日期索引查询计划、任务拖动与缩放、计时恢复以及页面按需构建／局部刷新回归。Release APK 版本 `2.1.0+5` 已生成并通过 APK 签名校验。

界面截图位于 `build/ui-preview/`，由实际 Flutter 组件渲染，使用测试数据；Windows 截图采用系统中文字体，手机字形可能略有差异。没有连接安卓真机，因此未测量设备上的帧耗时、掉帧率或长时间后台表现，不能据此承诺所有场景都无卡顿。

重新导出图标：`python tool/generate_icon.py`（需要 Pillow）。
重新导出界面截图：`flutter test test/ui_refresh_test.dart --dart-define=CAPTURE_UI=true`。
Windows 中文路径下若分析或构建失败，在英文目录副本执行；构建也可使用下文已有脚本。

## 环境要求

- Flutter stable（本项目已使用 Flutter 3.44.8 / Dart 3.12.2 验证）
- Android SDK 36
- JDK 17
- Android 真机或模拟器

先检查开发环境：

```bash
flutter --version
flutter doctor -v
```

如果 `flutter doctor` 提示 Android license 未接受：

```bash
flutter doctor --android-licenses
```

## 运行、代码生成与打包

在项目根目录依次执行：

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
flutter build apk --release
```

生成的 APK 通常位于：

```text
build/app/outputs/flutter-apk/app-release.apk
```

也建议在提交修改前执行：

```bash
flutter analyze
flutter test
```

### Windows 中文路径

部分 Flutter/Android 构建工具在 Windows 中文绝对路径下会生成错误的 AOT 参数。本项目提供了兼容脚本：它会把源码复制到英文临时目录构建，再将 APK 复制回项目的标准输出目录。

```powershell
powershell -ExecutionPolicy Bypass -File tool/build_android_release.ps1
```

如果 `flutter` 不在 `PATH` 中：

```powershell
powershell -ExecutionPolicy Bypass -File tool/build_android_release.ps1 `
  -FlutterCommand "C:\path\to\flutter\bin\flutter.bat"
```

## 在手机上安装

### 方法一：直接传到手机

1. 把 `app-release.apk` 通过数据线、微信文件传输或网盘传到 Android 手机。
2. 在手机文件管理器中点开 APK。
3. 按系统提示，允许当前文件管理器“安装未知应用”。
4. 点击安装。

后续安装相同应用 ID、相同签名的新 APK 会覆盖升级并保留数据库。卸载应用会删除手机中的周迹私有数据。

### 方法二：ADB 安装

打开手机“开发者选项”和“USB 调试”，连接电脑后执行：

```bash
adb devices
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

`-r` 表示覆盖安装并保留已有应用数据。如果系统提示签名不一致，只能先卸载旧包再安装；卸载前请注意当前版本尚无数据导出功能。

### 开发模式直接运行

连接真机或启动模拟器后：

```bash
flutter devices
flutter run
```

## 主要功能

### 计划

- 顶部在周计划、月计划、日计划之间切换。
- 周视图支持一屏总览和可滚动详细模式，并记住上次模式。
- “总览 / 详细”和紧凑的“＋ 新建”位于同一行；窄屏自动切换为 40×40dp 图标按钮，时间表右下角不再有遮挡任务的悬浮按钮。
- 详细模式从 `07:00` 开始，不被顶部栏遮挡；支持加减按钮、双指捏合和“适配整天”缩放。
- 缩放范围为每小时 28–120dp，缩放时保持当前查看时间居中，不会改变任务的真实起止时间。
- 总览与详细模式分别保存时间轴高度；重启应用或再次进入页面后恢复上次缩放比例。
- 竖屏可横向浏览日期，时间轴固定；横屏尽量完整显示七天。
- 空白区域长按拖动创建任务，移动和缩放按 15 分钟吸附。
- 周视图空白时间格可直接点击创建；周、月、日计划均保留紧凑的新建入口。
- 月视图点击日期可选择新增指定时间任务、全天任务或进入日计划。
- 手工编辑时间精确到 1 分钟，最短 5 分钟，可将结束时间设为 `24:00`。
- 新增与编辑统一使用可滚动 BottomSheet；底部固定提供删除、复制、取消和保存，未保存退出会二次确认。
- 时间区提供 5/15/30 分钟步长和不小于 48dp 的加减按钮，任务时长会实时更新。
- 任务支持分类、颜色、备注、全天、锁定、完成状态。
- 长按任务打开快捷菜单，可编辑、完成、复制到某天、复制到下周、锁定或删除。
- 任务卡使用独立移动手柄和顶部/底部缩放手柄；锁定任务禁止拖动和缩放。
- 任务名称根据卡片实际高度自动显示 1–4 行，空间不足时才省略；短任务优先显示名称。
- 点击任务主体只负责打开编辑器，长按只负责快捷菜单；拖动及上下边界调整均使用独立手柄。
- 15 分钟短任务保持真实起止时间，同时具有 48dp 最小命中高度；相邻短任务自动并列，避免相互遮挡。
- 同一天定时任务发生重叠时阻止保存，并提示冲突任务名称；全天任务不参与冲突。
- 月视图显示任务摘要，长按日期创建全天任务，并支持月目标。
- 日计划汇总全天/定时任务、实际记录摘要和每日总结。

### 专注

- 根据当前时间推荐正在进行或即将开始的今日计划。
- 支持关联任意今日任务，也支持不绑定任务的临时专注。
- 提供 `25 + 5`、`50 + 10` 和自定义专注/休息时长。
- 支持开始、暂停、继续、提前结束、完成当前番茄、跳过休息和重置。
- 计时使用开始时间和预计结束时间计算，不依赖页面每秒递减。
- `ActiveTimer` 会写入 SQLite；应用重启后恢复运行中或暂停中的计时状态。
- 专注完成后生成 `FocusSession`，可选择同时标记关联任务完成。
- 用户主动开启提醒时才请求 Android 通知权限；计时结束通知使用非精确系统调度，避免申请精确闹钟权限。

### 记录与统计

- 每日记录支持新增、编辑和删除实际完成事项。
- 开始/结束时间可选；实际用时可自动计算或手工填写。
- 每日总结采用防抖自动保存。
- 统计页支持今天、本周、本月三个范围。
- 显示专注总时长、完整番茄、专注次数、完成任务、计划时长、实际记录时长和完成率。
- 环形图按任务分类汇总专注时间，仅显示前 5 类，其余合并为“其他”。
- 柱状图显示每次或每日专注趋势。

### 设置

- 跟随系统、浅色、深色三种外观模式。
- 默认周视图模式，以及总览/详细模式各自的时间表缩放。
- 按需开启计时通知。
- 6 个柔和默认分类，并支持新增、编辑和删除自定义分类。

## 数据库与迁移

数据库文件名为 `zhouji.sqlite`，由 `path_provider` 放在 Android 应用支持目录。

schema v3 包含：

- `PlanTask`
- `ActivityRecord`
- `DailySummary`
- `TaskCategory`
- `FocusSession`
- `ActiveTimer`
- `MonthlyGoal`
- `AppSettings`

从 V1 或 V2 升级时使用 Drift `onUpgrade` 原位增加字段和创建新表，不会删除原有任务、记录或总结。V3 只为 `AppSettings` 增加总览与详细时间轴高度字段。默认分类和默认设置使用幂等插入。`database_migration_test.dart` 会实际创建 V1、V2 数据库并验证升级后的旧数据。

修改 Drift 表声明后执行：

```bash
dart run build_runner build --delete-conflicting-outputs
```

不要手工编辑 `lib/database/app_database.g.dart`。

## 计时恢复原理

运行状态保存 `startedAt`、`expectedEndAt`、`remainingSeconds` 和 `isRunning`：

- 运行中：剩余时间等于 `expectedEndAt - 当前时间`。
- 暂停时：保存当时的 `remainingSeconds`。
- 继续时：使用当前时间加剩余秒数生成新的 `expectedEndAt`。
- 重启恢复时：读取唯一的 `ActiveTimer`；如果已经到期，补写完成记录并进入休息准备状态。

因此页面重建、切后台或锁屏不会使计时重置。

## 统计规则

- 计划总时长只计算非全天任务。
- 完成率为已完成任务数除以计划任务总数。
- 专注时间以 `FocusSession.actualMinutes` 为准。
- 有分类的专注按分类汇总；临时或无分类专注计入“未分类专注”。
- 环图分类时间之和始终等于当前范围的专注总时间。

## 项目结构

```text
lib/
├── database/       # Drift 表、查询、事务和迁移
├── models/         # 任务、分类、专注、目标、设置等领域模型
├── repositories/   # 所有数据库读写入口
├── providers/      # Riverpod 数据流和番茄钟状态
├── pages/          # 计划、专注、记录、统计页面
├── services/       # 通知和统计计算
├── widgets/        # 周时间表、任务块、编辑弹窗等组件
├── utils/          # 日期、分钟、颜色工具
├── app.dart        # Material 3、本地化和主题
└── main.dart       # 应用入口

test/
├── database_migration_test.dart
├── database_persistence_test.dart
├── plan_task_repository_test.dart
├── activity_repository_test.dart
├── focus_timer_test.dart
├── statistics_service_test.dart
├── task_interaction_test.dart
├── task_time_and_conflict_test.dart
├── plan_zoom_test.dart
├── timeline_position_calculator_test.dart
├── timeline_settings_persistence_test.dart
├── date_time_utils_test.dart
└── widget_test.dart
```

## 已验证内容

- V1、V2 数据库原位升级且旧数据保留。
- 07:00–08:00 创建、分钟级编辑、15 分钟吸附。
- 普通、锁定和 15 分钟短任务点击编辑，长按快捷菜单。
- 顶部紧凑新建按钮、空白时间格、月视图日期三类新增入口。
- 任务标题根据可用高度动态换行；总览和详细模式都不会固定为单行。
- 详细模式按钮缩放、双指缩放、适配整天、缩放中心保持和重启恢复。
- 缩放前后任务分钟值不变，任务位置与视觉时长按统一换算器同步更新。
- 无需拖动创建 `09:07–09:42` 任务，以及 5/15/30 分钟快捷微调。
- 任务冲突详情、跨日期移动、上下缩放、拖动取消、复制、锁定、完成和删除。
- 全天任务与月目标。
- 活动记录、总结和 SQLite 重启持久化。
- 番茄暂停/继续状态持久化、时间戳恢复和完成记录生成。
- 统计总和、分类环图守恒和周趋势。
- 周/月/日切换、四个底栏入口、窄屏浅色和横屏深色布局。

## 当前可继续优化

- 增加数据库导出、导入和手动备份。
- 增加系统日历导入、桌面小组件和重复任务。
- 为跨日历月边缘日期加载相邻月份的任务摘要。
- 补充真实设备上的长时间后台计时、厂商省电策略和通知延迟专项测试。
- 增加更完整的手势集成测试、无障碍语义和大字体适配。
- 当前 Release APK 使用项目默认调试签名，仅用于本地安装；如需长期跨电脑持续覆盖升级，应创建并妥善保管固定的本地 keystore。
