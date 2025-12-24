package com.example.pizzaeatho

import android.content.Context
import android.util.Log
import com.google.mediapipe.tasks.genai.llminference.GraphOptions
import com.google.mediapipe.tasks.genai.llminference.LlmInference
import com.google.mediapipe.tasks.genai.llminference.LlmInferenceSession
import java.io.File

private const val TAG = "OnDeviceLlm"
private const val DEFAULT_TOPK = 64
private const val DEFAULT_TOPP = 0.95f
private const val DEFAULT_TEMPERATURE = 0.6f
private const val DEFAULT_MAX_TOKEN = 512

object LlmHelper {
    private var engine: LlmInference? = null
    private var session: LlmInferenceSession? = null
    private var currentModelPath: String? = null

    fun initialize(context: Context, modelPath: String): String? {
        if (engine != null && currentModelPath == modelPath) {
            return null
        }

        cleanUp()

        val modelFile = File(modelPath)
        if (!modelFile.exists()) {
            return "모델 파일이 존재하지 않습니다: $modelPath"
        }

        return try {
            val options = LlmInference.LlmInferenceOptions.builder()
                .setModelPath(modelFile.path)
                .setMaxTokens(DEFAULT_MAX_TOKEN)
                .setPreferredBackend(LlmInference.Backend.GPU)
                .setMaxNumImages(0)
                .build()

            val createdEngine = LlmInference.createFromOptions(context, options)
            val createdSession = createSession(createdEngine)

            engine = createdEngine
            session = createdSession
            currentModelPath = modelPath
            null
        } catch (e: Exception) {
            Log.e(TAG, "initialize failed", e)
            e.message ?: "initialize failed"
        }
    }

    fun generate(
        prompt: String,
        resultListener: (partial: String, done: Boolean) -> Unit,
    ) {
        val engine = engine
        if (engine == null) {
            resultListener("LLM engine not initialized.", true)
            return
        }

        val session = resetSession(engine)
        try {
            session.addQueryChunk(prompt)
            session.generateResponseAsync { partial, done ->
                resultListener(partial, done)
            }
        } catch (e: Exception) {
            Log.e(TAG, "generate failed", e)
            resultListener(e.message ?: "generate failed", true)
        }
    }

    private fun createSession(engine: LlmInference): LlmInferenceSession {
        return LlmInferenceSession.createFromOptions(
            engine,
            LlmInferenceSession.LlmInferenceSessionOptions.builder()
                .setTopK(DEFAULT_TOPK)
                .setTopP(DEFAULT_TOPP)
                .setTemperature(DEFAULT_TEMPERATURE)
                .setGraphOptions(
                    GraphOptions.builder()
                        .setEnableVisionModality(false)
                        .setEnableAudioModality(false)
                        .build()
                )
                .build(),
        )
    }

    private fun resetSession(engine: LlmInference): LlmInferenceSession {
        try {
            session?.close()
        } catch (e: Exception) {
            Log.w(TAG, "session close failed", e)
        }
        val newSession = createSession(engine)
        session = newSession
        return newSession
    }

    fun cleanUp() {
        try {
            session?.close()
        } catch (e: Exception) {
            Log.w(TAG, "session close failed", e)
        }
        try {
            engine?.close()
        } catch (e: Exception) {
            Log.w(TAG, "engine close failed", e)
        }
        session = null
        engine = null
        currentModelPath = null
    }
}
