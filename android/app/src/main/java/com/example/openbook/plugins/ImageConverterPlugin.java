package com.example.openbook.plugins;

import androidx.annotation.NonNull;
import com.example.openbook.ImageConverter;
import com.example.openbook.ImageConverter.TargetFormat;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

public class ImageConverterPlugin implements MethodCallHandler, FlutterPlugin {
    private MethodChannel methodChannel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel = new MethodChannel(binding.getBinaryMessenger(), "openspace.social/image_converter");
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
        methodChannel = null;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "convertImage":
                convertImage(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void convertImage(MethodCall call, Result result) {
        byte[] imageData = call.argument("imageData");
        InputStream inputStream = new ByteArrayInputStream(imageData);
        TargetFormat format;
        String formatString = call.argument("format");
        switch (formatString) {
            case "JPEG":
                format = TargetFormat.JPEG;
                break;
            case "PNG":
                format = TargetFormat.PNG;
                break;
            default:
                result.error("unkown_format", "Unknown image format", formatString);
                return;
        }
        imageData = ImageConverter.convertImageData(inputStream, format);
        result.success(imageData);
    }
}
