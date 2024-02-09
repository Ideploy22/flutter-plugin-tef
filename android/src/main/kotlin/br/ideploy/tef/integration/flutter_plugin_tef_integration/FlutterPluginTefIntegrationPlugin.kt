package br.ideploy.tef.integration.flutter_plugin_tef_integration


import android.app.Activity
import android.util.Log
import android.os.Handler
import android.os.Looper
import android.os.Message
import com.elgin.e1.pagamentos.tef.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject


class FlutterPluginTefIntegrationPlugin : FlutterPlugin, ActivityAware {
    private val nameSpace = "br.ideploy.tef.integration.flutter_plugin_tef_integration"
    val tag = "IDeploy: "

    private lateinit var channel: MethodChannel
    private var handler: Handler? = null
    private var mEventSink: EventSink? = null
    private var eventChannel: EventChannel? = null
    private var activity: Activity? = null
    private var binaryMessenger: BinaryMessenger? = null

    private var operation: String = "";

    private  fun setOperation(op: String) {
        operation = op
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        binaryMessenger = flutterPluginBinding.binaryMessenger

        handler = object : Handler(Looper.getMainLooper()) {
            override fun handleMessage(message: Message) {
                var value: String? = null
                try {
                    when (message.what) {
                        1 -> { // MENSAGEM DE PROGRESSO
                            value = ElginTef.ObterMensagemProgresso()
                        }
                        2 -> { // OPÇÃO DE COLETA
                            value = ElginTef.ObterOpcaoColeta()
                        }
                        3 -> { // DADOS DA TRANSAÇÃO
                            value = ElginTef.ObterDadosTransacao()
                        }
                        4 -> { // FINALIZAR
                            value = ElginTef.ObterMensagemProgresso()
                        }
                        else -> {
                        }
                    }

                    Log.d(
                        tag,
                        "MESSAGE: $value - What: ${message.what} - When: ${message.`when`} - Obj: ${message.obj}"
                    )

                    val response = makeSuccessResponse(operation, JSONObject().apply {
                        put("what", message.what)
                        put("message", "${message.obj}")
                    })
                    invokeMethodUIThread(response)
                } catch (e: java.lang.Exception) {
                    Log.d(tag, e.toString())
                }
            }
        }
    }

    private fun makeSuccessResponse(type: String, data: JSONObject?): JSONObject {
        val response = JSONObject()
        response.put("type", type)
        response.put("data", data)
        response.put("success", true)
        return response
    }

    private fun makeErrorResponse(type: String, error: String?): JSONObject {
        val response = JSONObject()
        response.put("type", type)
        response.put("error", error)
        response.put("success", false)
        return response
    }

    private fun configureTEF(data: String?) {
        var applicationName: String? = null
        var applicationVersion: String? = null
        var pinPadText: String? = null
        var document: String? = null
        if (data != null) {
            val jsonObject = JSONObject(data)
            applicationName = (jsonObject["applicationName"] as String)
            applicationVersion = (jsonObject["applicationVersion"] as String)
            pinPadText = (jsonObject["pinPadText"] as String)
            document = (jsonObject["document"] as String)
        }

        activity?.let { validContext ->
            ElginTef.setContext(validContext)
            handler?.let { validHandler ->
                ElginTef.setHandler(validHandler)
                ElginTef.InformarDadosAutomacao(
                    applicationName,
                    applicationVersion,
                    pinPadText,
                    "ELGIN",
                    "Loja172",
                    "T1720010"
                )
                ElginTef.AtivarTerminal(document)
            }
        }
    }

    private fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "configure" -> {
                try {
                    val args = call.arguments() as String?
                    val response = makeSuccessResponse("configure", JSONObject().apply {
                        put("start", args != null)
                    })
                    setOperation("configure")
                    configureTEF(args)
                    result.success(response.toString())
                } catch (e: Exception) {
                    result.error("configure", e.message, null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        activity = activityPluginBinding.activity

        channel = MethodChannel(binaryMessenger!!, "$nameSpace/methods")
        channel.setMethodCallHandler { call, result ->
            onMethodCall(call, result)
        }

        eventChannel = EventChannel(binaryMessenger!!, "$nameSpace/events")
        eventChannel!!.setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, eventSink: EventSink) {
                    mEventSink = eventSink
                }

                override fun onCancel(p0: Any?) {
                    eventChannel!!.setStreamHandler(null)
                    mEventSink = null
                }
            }
        )
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Log.d(tag, "onDetachedFromActivityForConfigChanges")
    }

    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {
        Log.d(tag, "onDetachedFromActivityForConfigChanges")
    }

    override fun onDetachedFromActivity() {
        Log.d(tag, "onDetachedFromActivityForConfigChanges")
    }

    private fun invokeMethodUIThread(response: JSONObject) {
        activity!!.runOnUiThread {
            mEventSink!!.success(response.toString())
        }
    }
}
