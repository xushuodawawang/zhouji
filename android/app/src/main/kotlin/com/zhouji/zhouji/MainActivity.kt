package com.zhouji.zhouji

import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.provider.OpenableColumns
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val channelName = "com.zhouji.zhouji/focus_music"
    private var player: MediaPlayer? = null
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
        result?.success(mapOf("uri" to uri.toString(), "name" to name))
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
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
                    "play" -> {
                        val uri = call.argument<String>("uri")
                        if (uri.isNullOrBlank()) {
                            result.error("missing_uri", "没有选择音乐", null)
                        } else {
                            try {
                                player?.release()
                                player = MediaPlayer().apply {
                                    setAudioAttributes(
                                        AudioAttributes.Builder()
                                            .setUsage(AudioAttributes.USAGE_MEDIA)
                                            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                                            .build()
                                    )
                                    setDataSource(this@MainActivity, android.net.Uri.parse(uri))
                                    isLooping = true
                                    setVolume(0.45f, 0.45f)
                                    setOnPreparedListener { if (player === it) it.start() }
                                    setOnErrorListener { failed, _, _ ->
                                        if (player === failed) player = null
                                        failed.release()
                                        true
                                    }
                                    prepareAsync()
                                }
                                result.success(null)
                            } catch (error: Exception) {
                                player?.release()
                                player = null
                                result.error("play_failed", error.message, null)
                            }
                        }
                    }
                    "stop" -> {
                        player?.release()
                        player = null
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        player?.release()
        player = null
        super.onDestroy()
    }
}
