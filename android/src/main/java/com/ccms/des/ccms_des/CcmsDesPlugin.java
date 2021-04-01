package com.ccms.des.ccms_des;

import java.util.ArrayList;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** CcmsDesPlugin */
public class CcmsDesPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ccms_des");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("encryptToHex")) {
      ArrayList<String> arguments = (ArrayList) call.arguments;
      try {
        String encryString = new CcmsDesUtils(arguments.get(1)).encrypt(arguments.get(0));
        result.success(encryString);
      } catch (Exception e) {
        e.printStackTrace();
        result.success("");
      }
    } else if (call.method.equals("decryptFromHex")) {
      ArrayList<String> arguments = (ArrayList) call.arguments;
      try {
        String encryString = new CcmsDesUtils(arguments.get(1)).decrypt(arguments.get(0));
        result.success(encryString);
      } catch (Exception e) {
        e.printStackTrace();
        result.success("");
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
