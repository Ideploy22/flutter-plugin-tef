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

enum class TefOperation(val value: String) {
    CONFIGURE("configure"),
    PAY("pay"),
    UNKNOWN("")
}

enum class CreditCardOperation(val value: String) {
    CREDIT("credit"),
    DEBIT("debit"),
    PIX("pix"),
    UNKNOWN("");

    companion object {
        fun fromString(value: String): CreditCardOperation {
            return values().find { it.value == value } ?: UNKNOWN
        }
    }
}


enum class TefWhat(val value: Int) {
    PROGRESS(1),
    COLLECT(2),
    TRANSACTION(3),
    FINISH(4),
}

class FlutterPluginTefIntegrationPlugin : FlutterPlugin, ActivityAware {
    private val nameSpace = "br.ideploy.tef.integration.flutter_plugin_tef_integration"
    val tag = "IDeploy: "

    private lateinit var channel: MethodChannel
    private var handler: Handler? = null
    private var mEventSink: EventSink? = null
    private var eventChannel: EventChannel? = null
    private var activity: Activity? = null
    private var binaryMessenger: BinaryMessenger? = null

    private var operation: TefOperation = TefOperation.UNKNOWN

    private fun setOperation(op: TefOperation) {
        operation = op
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        binaryMessenger = flutterPluginBinding.binaryMessenger

        handler = object : Handler(Looper.getMainLooper()) {
            override fun handleMessage(message: Message) {
                var value: String? = null
                try {
                    when (message.what) {
                        TefWhat.PROGRESS.value -> {
                            value = ElginTef.ObterMensagemProgresso()
                        }
                        TefWhat.COLLECT.value -> {
                            value = ElginTef.ObterOpcaoColeta()
                        }
                        TefWhat.TRANSACTION.value -> {
                            value = ElginTef.ObterMensagemProgresso()
                        }
                        TefWhat.FINISH.value -> {
                            value = if (operation == TefOperation.CONFIGURE) {
                                "${message.obj}"
                            } else {
                                ElginTef.ObterDadosTransacao()
                            }
                        }
                    }

                    invokeMethodUIThread(makeSuccessResponse(operation.value, JSONObject().apply {
                        put("what", message.what)
                        put("message", value ?: "${message.obj}")
                    }))
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

    private fun initializeTEF() {
        activity?.let { validContext ->
            ElginTef.setContext(validContext)
            handler?.let { validHandler ->
                ElginTef.setHandler(validHandler)
            }
        }
    }

    private fun configureTEF(data: String?) {
        if (data != null) {
            val jsonObject = JSONObject(data)
            val applicationName: String = (jsonObject["applicationName"] as String)
            val applicationVersion: String = (jsonObject["applicationVersion"] as String)
            val pinPadText: String = (jsonObject["pinPadText"] as String)
            val document: String = (jsonObject["document"] as String)

            ElginTef.InformarDadosAutomacao(
                applicationName,
                applicationVersion,
                pinPadText,
                "",
                "",
                ""
            )
            ElginTef.AtivarTerminal(document)
        }
    }

    private fun pay(data: String?) {
        if (data != null) {
            val jsonObject = JSONObject(data)
            val paymentType: CreditCardOperation = CreditCardOperation.fromString(jsonObject["paymentType"] as String)
            val value: String = jsonObject["value"] as String

            when (paymentType) {
                CreditCardOperation.CREDIT -> {
                    val operationType: String? = jsonObject["operationType"] as String?
                    val installments: Int? = jsonObject["installments"] as Int?

                    ElginTef.RealizarTransacaoCredito(
                        value,
                        operationType,
                        (installments ?: 1).toString()
                    )
                }
                CreditCardOperation.DEBIT -> {
                    ElginTef.RealizarTransacaoDebito(value)
                }
                CreditCardOperation.PIX -> {
                    ElginTef.RealizarTransacaoPIX(value)
                }
                CreditCardOperation.UNKNOWN -> TODO()
            }
        }
    }

    private fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "initialize" -> {
                try {
                    initializeTEF()
                    result.success(makeSuccessResponse("configure", JSONObject().apply {
                        put("success", true)
                    }).toString())
                } catch (e: Exception) {
                    result.error("configure", e.message, null)
                }
            }
            "configure" -> {
                try {
                    val args = call.arguments() as String?
                    val response = makeSuccessResponse("configure", JSONObject().apply {
                        put("start", args != null)
                    })
                    setOperation(TefOperation.CONFIGURE)
                    configureTEF(args)
                    result.success(response.toString())
                } catch (e: Exception) {
                    result.error("configure", e.message, null)
                }
            }
            "pay" -> {
                try {
                    val args = call.arguments() as String?
                    val response = makeSuccessResponse("pay", JSONObject().apply {
                        put("start", args != null)
                    })
                    setOperation(TefOperation.PAY)
                    pay(args)
                    result.success(response.toString())
                } catch (e: Exception) {
                    result.error("pay", e.message, null)
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
