package com.example.openbook.plugins;

import android.media.Image;
import android.util.Log;
import com.example.openbook.ImageConverter;
import com.example.openbook.ImageConverter.TargetFormat;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

public class ImageConverterPlugin implements MethodCallHandler {
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "openspace.social/image_converter");
        channel.setMethodCallHandler(new ImageConverterPlugin());
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
