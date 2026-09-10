import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/database/app_database.dart';
import 'package:zhouji/models/app_settings.dart';
import 'package:zhouji/models/focus_session.dart';
import 'package:zhouji/providers/focus_timer_controller.dart';
import 'package:zhouji/repositories/focus_repository.dart';
import 'package:zhouji/services/focus_lock_service.dart';
import 'package:zhouji/services/focus_music_service.dart';
import 'package:zhouji/services/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;
  late FocusRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = FocusRepository(database);
  });

  tearDown(() => database.close());

  test('运行中的剩余时间由预计结束时间戳计算', () {
    final now = DateTime(2026, 7, 24, 10);
    final timer = ActiveTimer(
      mode: TimerMode.pomodoro,
      phase: TimerPhase.focus,
      startedAt: now,
      expectedEndAt: now.add(const Duration(minutes: 25)),
      remainingSeconds: 1,
      isRunning: true,
      cycleCount: 0,
    );
    expect(
      FocusTimerController.remainingAt(
        timer,
        now.add(const Duration(minutes: 3)),
      ),
      22 * 60,
    );
    expect(
      FocusTimerController.remainingAt(
        ActiveTimer(
          mode: timer.mode,
          phase: timer.phase,
          startedAt: timer.startedAt,
          expectedEndAt: timer.expectedEndAt,
          remainingSeconds: 321,
          isRunning: false,
          cycleCount: 0,
        ),
        now.add(const Duration(hours: 1)),
      ),
      321,
    );
  });

  test('暂停、继续会持久化 ActiveTimer 状态', () async {
    final controller = FocusTimerController(
      repository: repository,
      notifications: NotificationService(),
      settings: const AppSettings(pomodoroFocusMinutes: 1),
    );
    addTearDown(controller.dispose);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    await controller.start();
    expect((await repository.loadActiveTimer())!.isRunning, isTrue);
    await controller.pause();
    final paused = await repository.loadActiveTimer();
    expect(paused!.isRunning, isFalse);
    expect(paused.remainingSeconds, inInclusiveRange(58, 60));
    await controller.resume();
    expect((await repository.loadActiveTimer())!.isRunning, isTrue);
  });

  test('完成番茄后生成 FocusSession 并清除 ActiveTimer', () async {
    final controller = FocusTimerController(
      repository: repository,
      notifications: NotificationService(),
      settings: const AppSettings(pomodoroFocusMinutes: 1),
    );
    addTearDown(controller.dispose);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    await controller.start();
    await controller.completeCurrent();
    final start = DateTime.now().subtract(const Duration(days: 1));
    final end = DateTime.now().add(const Duration(days: 1));
    final sessions = await repository.getBetween(start, end);

    expect(sessions, hasLength(1));
    expect(sessions.single.completed, isTrue);
    expect(sessions.single.actualMinutes, 1);
    expect(await repository.loadActiveTimer(), isNull);
    expect(controller.state.phase, TimerPhase.shortBreak);
  });

  test('专注锁定、背景音乐控制与完成铃声按生命周期执行', () async {
    final music = _RecordingMusicService();
    final focusLock = _RecordingFocusLockService();
    final controller = FocusTimerController(
      repository: repository,
      notifications: NotificationService(),
      music: music,
      focusLock: focusLock,
      settings: const AppSettings(
        pomodoroFocusMinutes: 1,
        focusLockEnabled: true,
        focusMusicEnabled: true,
        focusMusicUri: 'content://local/study.mp3',
        completionSoundEnabled: true,
      ),
    );
    addTearDown(controller.dispose);
    while (controller.state.restoring) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    await controller.start();
    expect(focusLock.activations, 1);
    expect(music.plays, 1);
    expect(controller.state.musicPlaying, isTrue);

    await controller.toggleMusicPlayback();
    expect(music.pauses, 1);
    expect(controller.state.musicPlaying, isFalse);
    await controller.toggleMusicPlayback();
    expect(music.resumes, 1);
    expect(controller.state.musicPlaying, isTrue);

    await controller.completeCurrent();
    expect(focusLock.deactivations, 1);
    expect(music.stops, 1);
    expect(music.chimes, 1);
    expect(controller.state.phase, TimerPhase.shortBreak);
  });

  test('多首背景音乐按歌单交给原生播放器', () async {
    final music = _RecordingMusicService();
    final controller = FocusTimerController(
      repository: repository,
      notifications: NotificationService(),
      music: music,
      settings: AppSettings(
        pomodoroFocusMinutes: 1,
        focusMusicEnabled: true,
        focusMusicUri: 'content://local/one.mp3',
        focusPlaylistJson: FocusMusicService.encodePlaylist(const [
          FocusMusicSelection(uri: 'content://local/one.mp3', name: 'one.mp3'),
          FocusMusicSelection(
            uri: 'content://local/two.flac',
            name: 'two.flac',
          ),
        ]),
      ),
    );
    addTearDown(controller.dispose);
    while (controller.state.restoring) {
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }

    await controller.start();
    expect(music.playlists, 1);
    expect(music.lastPlaylist, [
      'content://local/one.mp3',
      'content://local/two.flac',
    ]);
    expect(music.plays, 0);
  });
}

class _RecordingMusicService extends FocusMusicService {
  int plays = 0;
  int playlists = 0;
  List<String> lastPlaylist = const [];
  int pauses = 0;
  int resumes = 0;
  int stops = 0;
  int chimes = 0;

  @override
  Future<bool> play(String uri) async {
    plays++;
    return true;
  }

  @override
  Future<bool> playPlaylist(List<String> uris) async {
    playlists++;
    lastPlaylist = List.of(uris);
    return true;
  }

  @override
  Future<void> pause() async {
    pauses++;
  }

  @override
  Future<bool> resume() async {
    resumes++;
    return true;
  }

  @override
  Future<void> stop() async {
    stops++;
  }

  @override
  Future<void> playCompletionSound() async {
    chimes++;
  }
}

class _RecordingFocusLockService extends FocusLockService {
  int activations = 0;
  int deactivations = 0;

  @override
  Future<bool> activate() async {
    activations++;
    return true;
  }

  @override
  Future<void> deactivate() async {
    deactivations++;
  }
}
