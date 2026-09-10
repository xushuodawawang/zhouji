package com.zhouji.zhouji

import android.app.ActivityManager
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.OpenableColumns
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val musicChannelName = "com.zhouji.zhouji/focus_music"
    private val lockChannelName = "com.zhouji.zhouji/focus_lock"
    private var player: MediaPlayer? = null
    private var chimePlayer: MediaPlayer? = null
    private var shouldPlayMusic = false
    private var previewing = false
    private var musicQueue: List<Uri> = emptyList()
    private var musicQueueIndex = 0
    private val mainHandler = Handler(Looper.getMainLooper())
    private var pendingResult: MethodChannel.Result? = null

    private val audioPicker = registerForActivityResult(
        ActivityResultContracts.OpenDocument()
    ) { uri ->
        val result = pendingResult
        pendingResult = null
        if (uri == null) {
            result?.success(null)
            return@registerForActivityResult
        }
        result?.success(describeAudio(uri))
    }

    private val playlistPicker = registerForActivityResult(
        ActivityResultContracts.OpenMultipleDocuments()
    ) { uris ->
        val result = pendingResult
        pendingResult = null
        result?.success(uris.map(::describeAudio))
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, musicChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "pickAudio" -> {
                        if (pendingResult != null) {
                            result.error("picker_busy", "音乐选择器已经打开", null)
                        } else {
                            pendingResult = result
                            audioPicker.launch(arrayOf("audio/*"))
                        }
                    }
                    "pickPlaylist" -> {
                        if (pendingResult != null) {
                            result.error("picker_busy", "音乐选择器已经打开", null)
                        } else {
                            pendingResult = result
                            playlistPicker.launch(arrayOf("audio/*"))
                        }
                    }
                    "play" -> playAudio(call.argument("uri"), false, result)
                    "playPlaylist" -> playPlaylist(call.argument("uris"), result)
                    "preview" -> playAudio(call.argument("uri"), true, result)
                    "pause" -> {
                        try {
                            shouldPlayMusic = false
                            if (player?.isPlaying == true) player?.pause()
                            result.success(null)
                        } catch (error: Exception) {
                            result.error("pause_failed", error.message, null)
                        }
                    }
                    "resume" -> {
                        try {
                            val current = player
                            if (current == null) {
                                result.success(false)
                            } else {
                                shouldPlayMusic = true
                                if (!current.isPlaying) current.start()
                                result.success(true)
                            }
                        } catch (_: IllegalStateException) {
                            // The player can still be preparing; its listener starts it later.
                            result.success(player != null)
                        } catch (_: Exception) {
                            shouldPlayMusic = false
                            result.success(false)
                        }
                    }
                    "stop" -> {
                        stopMusic()
                        result.success(null)
                    }
                    "playCompletionSound" -> playCompletionSound(result)
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, lockChannelName)
            .setMethodCallHandler { call, result ->
                val manager = getSystemService(ACTIVITY_SERVICE) as ActivityManager
                when (call.method) {
                    "activate" -> {
                        try {
                            if (manager.lockTaskModeState == ActivityManager.LOCK_TASK_MODE_NONE) {
                                startLockTask()
                            }
                            result.success(true)
                        } catch (error: Exception) {
                            result.error("lock_failed", error.message, null)
                        }
                    }
                    "deactivate" -> {
                        try {
                            if (manager.lockTaskModeState != ActivityManager.LOCK_TASK_MODE_NONE) {
                                stopLockTask()
                            }
                            result.success(null)
                        } catch (error: Exception) {
                            result.error("unlock_failed", error.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun describeAudio(uri: Uri): Map<String, String> {
        try {
            contentResolver.takePersistableUriPermission(
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION
            )
        } catch (_: SecurityException) {
            // Some document providers grant a durable URI without this call.
        }
        var name = "自定义音乐"
        contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)
            ?.use { cursor ->
                if (cursor.moveToFirst()) name = cursor.getString(0) ?: name
            }
        return mapOf("uri" to uri.toString(), "name" to name)
    }

    private fun playAudio(uri: String?, preview: Boolean, result: MethodChannel.Result) {
        if (uri.isNullOrBlank()) {
            result.error("missing_uri", "没有选择音乐", null)
            return
        }
        startPlayback(listOf(uri), preview, result)
    }

    private fun playPlaylist(uris: List<String>?, result: MethodChannel.Result) {
        val playable = uris.orEmpty().filter { it.isNotBlank() }
        if (playable.isEmpty()) {
            result.error("missing_uri", "歌单中没有可播放的音乐", null)
            return
        }
        startPlayback(playable, false, result)
    }

    private fun startPlayback(
        uris: List<String>,
        preview: Boolean,
        result: MethodChannel.Result
    ) {
        try {
            stopMusic()
            musicQueue = uris.map(Uri::parse)
            musicQueueIndex = 0
            previewing = preview
            shouldPlayMusic = true
            prepareCurrentTrack()
            result.success(null)
        } catch (error: Exception) {
            stopMusic()
            result.error("play_failed", error.message, null)
        }
    }

    private fun prepareCurrentTrack() {
        if (musicQueue.isEmpty()) return
        val nextPlayer = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_MEDIA)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .build()
                )
                setDataSource(this@MainActivity, musicQueue[musicQueueIndex])
                isLooping = !previewing && musicQueue.size == 1
                setVolume(0.45f, 0.45f)
                setOnPreparedListener {
                    if (player === it && shouldPlayMusic) it.start()
                }
                setOnCompletionListener { finished ->
                    if (player === finished) player = null
                    finished.release()
                    if (previewing) {
                        shouldPlayMusic = false
                        musicQueue = emptyList()
                    } else if (shouldPlayMusic && musicQueue.isNotEmpty()) {
                        musicQueueIndex = (musicQueueIndex + 1) % musicQueue.size
                        try {
                            prepareCurrentTrack()
                        } catch (_: Exception) {
                            stopMusic()
                        }
                    }
                }
                setOnErrorListener { failed, _, _ ->
                    if (player === failed) player = null
                    failed.release()
                    stopMusic()
                    true
                }
                prepareAsync()
            }
        player = nextPlayer
        if (previewing) {
            mainHandler.postDelayed({
                if (player === nextPlayer) stopMusic()
            }, 10_000)
        }
    }

    private fun stopMusic() {
        shouldPlayMusic = false
        previewing = false
        musicQueue = emptyList()
        musicQueueIndex = 0
        player?.release()
        player = null
    }

    private fun playCompletionSound(result: MethodChannel.Result) {
        try {
            chimePlayer?.release()
            val descriptor = resources.openRawResourceFd(R.raw.focus_complete_chime)
            chimePlayer = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION_EVENT)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                )
                setDataSource(descriptor.fileDescriptor, descriptor.startOffset, descriptor.length)
                descriptor.close()
                setVolume(0.85f, 0.85f)
                setOnCompletionListener { finished ->
                    if (chimePlayer === finished) chimePlayer = null
                    finished.release()
                }
                prepare()
                start()
            }
            result.success(null)
        } catch (error: Exception) {
            chimePlayer?.release()
            chimePlayer = null
            result.error("chime_failed", error.message, null)
        }
    }

    override fun onDestroy() {
        stopMusic()
        chimePlayer?.release()
        chimePlayer = null
        super.onDestroy()
    }
}
