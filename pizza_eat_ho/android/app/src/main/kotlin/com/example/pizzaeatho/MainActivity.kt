package com.example.pizzaeatho

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "pizzaeatho/on_device_ai"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "generate") {
                    val prompt = call.argument<String>("prompt").orEmpty()
                    val modelPath = call.argument<String>("modelPath").orEmpty()
                    val initError = LlmHelper.initialize(this, modelPath)
                    if (initError != null) {
                        result.error("INIT_ERROR", initError, null)
                        return@setMethodCallHandler
                    }

                    var lastPartial = ""
                    var completed = false
                    LlmHelper.generate(prompt) { partial, done ->
                        if (completed) return@generate
                        lastPartial = partial
                        if (done) {
                            completed = true
                            runOnUiThread {
                                result.success(lastPartial)
                            }
                        }
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
