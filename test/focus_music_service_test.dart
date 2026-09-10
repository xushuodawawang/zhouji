import 'package:flutter_test/flutter_test.dart';
import 'package:zhouji/services/focus_music_service.dart';

void main() {
  test('本地歌单可以序列化并完整恢复', () {
    const playlist = [
      FocusMusicSelection(uri: 'content://music/one', name: '数学.mp3'),
      FocusMusicSelection(uri: 'content://music/two', name: '白噪音.flac'),
    ];

    final restored = FocusMusicService.decodePlaylist(
      FocusMusicService.encodePlaylist(playlist),
    );

    expect(restored.map((item) => item.uri), [
      'content://music/one',
      'content://music/two',
    ]);
    expect(restored.map((item) => item.name), ['数学.mp3', '白噪音.flac']);
    expect(FocusMusicService.decodePlaylist('not-json'), isEmpty);
  });
}
