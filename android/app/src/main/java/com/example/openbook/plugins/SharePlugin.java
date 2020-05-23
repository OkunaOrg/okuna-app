package com.example.openbook.plugins;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.webkit.MimeTypeMap;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.example.openbook.ImageConverter;
import com.example.openbook.util.InputStreamSupplier;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;

import java.io.*;
import java.util.*;

public class SharePlugin implements FlutterPlugin, EventChannel.StreamHandler {
    private final Queue<Intent> intentBacklog = new LinkedList<>();
    private Context applicationContext;
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        applicationContext = binding.getApplicationContext();
        eventChannel = new EventChannel(binding.getBinaryMessenger(), "openbook.social/receive_share");
        eventChannel.setStreamHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        applicationContext = null;
        eventChannel.setStreamHandler(null);
        eventChannel = null;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
        while (!intentBacklog.isEmpty()) {
            handleIntent(intentBacklog.poll());
        }
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
    }

    public void handleIntent(@Nullable Intent intent) {
        // Only handle ACTION_SEND intents.
        if (intent == null || !Objects.equals(intent.getAction(), Intent.ACTION_SEND)) {
            return;
        }

        // Backlog the intent if we don't yet have an event sink to send it to.
        if (eventSink == null) {
            if (!intentBacklog.contains(intent)) {
                intentBacklog.add(intent);
            }
            return;
        }

        Map<String, String> args = new HashMap<>();

        String intentType = Objects.toString(intent.getType());
        try {
            if (intentType.startsWith("image/")) {
                handleImageIntent(intent, args);
            } else if (intentType.startsWith("video/")) {
                handleVideoIntent(intent, args);
            } else if (intentType.startsWith("text/")) {
                args.put("text", intent.getStringExtra(Intent.EXTRA_TEXT));
            } else {
                Log.w(getClass().getSimpleName(), "unknown intent type \"" + intentType + "\" received, ignoring");
            }
        } catch (KeyedException e) {
            String msg;
            if (e.getCause() != null) {
                msg = String.format("an exception occurred while receiving share of type %s" +
                        "%n %s%n caused by %s", intentType, e.toString(), e.getCause().toString());
            } else {
                msg = String.format("an exception occurred while receiving share of type %s" +
                        "%n %s", intentType, e.toString());
            }
            String errorTextKey = getLocalizationKey(e);

            args.put("error", errorTextKey);
            Log.w(getClass().getSimpleName(), msg);
        }

        if (!args.isEmpty()) {
            Log.i(getClass().getSimpleName(), "sending intent to flutter");
            eventSink.success(args);
        }
    }

    private void handleVideoIntent(@NonNull Intent intent, Map<String, String> args) throws KeyedException {
        Uri uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
        if (uri != null) {
            args.put("video", copyVideoToTempFile(uri).toString());
        } else {
            Log.w(getClass().getSimpleName(), "video intent without video URI received, ignoring");
        }
    }

    private void handleImageIntent(@NonNull Intent intent, Map<String, String> args) throws KeyedException {
        Uri uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
        if (uri != null) {
            if (!getExtensionFromUri(uri).equalsIgnoreCase("gif")) {
                args.put("image", copyImageToTempFile(uri).toString());
            } else {
                args.put("video", copyVideoToTempFile(uri).toString());
            }
        } else {
            Log.w(getClass().getSimpleName(), "image intent without image URI received, ignoring");
        }
    }

    private Uri copyImageToTempFile(Uri imageUri) throws KeyedException {
        byte[] data = convertImage(imageUri);
        File imageFile = createTemporaryFile(".jpeg");
        copyResourceToFile(() -> new ByteArrayInputStream(data), imageFile);

        return Uri.fromFile(imageFile);
    }

    private byte[] convertImage(Uri imageUri) throws KeyedException {
        try {
            InputStream imageStream;

            if (imageUri.getScheme().equals("content")) {
                imageStream = applicationContext.getContentResolver().openInputStream(imageUri);
            } else if (imageUri.getScheme().equals("file")) {
                imageStream = new FileInputStream(imageUri.getPath());
            } else {
                throw new KeyedException(KeyedException.Key.UriSchemeNotSupported, imageUri.getScheme(), null);
            }

            return ImageConverter.convertImageData(imageStream, ImageConverter.TargetFormat.JPEG);
        } catch (FileNotFoundException e) {
            throw new KeyedException(KeyedException.Key.ReadFileMissing, e);
        }
    }

    private Uri copyVideoToTempFile(Uri videoUri) throws KeyedException {
        Uri result;

        if (videoUri.getScheme().equals("content") || videoUri.getScheme().equals("file")) {
            String extension = getExtensionFromUri(videoUri);
            File tempFile = createTemporaryFile("." + extension);
            copyResourceToFile(() -> applicationContext.getContentResolver().openInputStream(videoUri), tempFile);
            result = Uri.fromFile(tempFile);
        } else {
            throw new KeyedException(KeyedException.Key.UriSchemeNotSupported, videoUri.getScheme(), null);
        }

        return result;
    }

    private String getExtensionFromUri(Uri uri) throws KeyedException {
        if (uri.getScheme().equals("content")) {
            String mime = applicationContext.getContentResolver().getType(uri);
            return MimeTypeMap.getSingleton().getExtensionFromMimeType(mime);
        } else if (uri.getScheme().equals("file")) {
            return MimeTypeMap.getFileExtensionFromUrl(uri.toString());
        } else {
            throw new KeyedException(KeyedException.Key.UriSchemeNotSupported, uri.getScheme(), null);
        }
    }

    private File createTemporaryFile(String extension) throws KeyedException {
        String name = UUID.randomUUID().toString();

        try {
            File directory = new File(applicationContext.getCacheDir(), "mediaCache");
            if (!directory.exists()) {
                directory.mkdirs();
            }

            return File.createTempFile(name, extension, directory);
        } catch (IOException e) {
            throw new KeyedException(KeyedException.Key.TempCreationFailed, e);
        } catch (SecurityException e) {
            throw new KeyedException(KeyedException.Key.TempCreationDenied, e);
        }
    }

    private void copyResourceToFile(InputStreamSupplier inputSupplier, File target) throws KeyedException {
        try (InputStream input = inputSupplier.get()) {
            try (OutputStream output = new FileOutputStream(target)) {
                byte[] data = new byte[1024];
                int length;
                while ((length = input.read(data)) > 0) {
                    output.write(data, 0, length);
                }
            } catch (FileNotFoundException e) {
                throw new KeyedException(KeyedException.Key.WriteTempMissing, e);
            } catch (IOException e) {
                throw new KeyedException(KeyedException.Key.WriteTempFailed, e);
            } catch (SecurityException e) {
                throw new KeyedException(KeyedException.Key.WriteTempDenied, e);
            }
        } catch (FileNotFoundException e) {
            throw new KeyedException(KeyedException.Key.ReadFileMissing, e);
        } catch (IOException e) {
            //Exception when closing the streams. Ignore.
        }
    }

    private String getLocalizationKey(KeyedException e) {
        String errorTextKey = "";

        switch (e.getKey()) {
            case TempCreationFailed:
            case WriteTempFailed:
            case WriteTempMissing:
                errorTextKey = "error__receive_share_temp_write_failed";
                break;
            case WriteTempDenied:
            case TempCreationDenied:
                errorTextKey = "error__receive_share_temp_write_denied";
                break;
            case UriSchemeNotSupported:
                errorTextKey = "error__receive_share_invalid_uri_scheme";
                break;
            case ReadFileMissing:
                errorTextKey = "error__receive_share_file_not_found";
                break;
        }

        return errorTextKey;
    }
}

class KeyedException extends Exception {
    public enum Key {
        TempCreationFailed("Failed to create temporary file."),
        TempCreationDenied(TempCreationFailed.message),
        WriteTempDenied("Failed to write to temporary file."),
        WriteTempFailed(WriteTempDenied.message),
        WriteTempMissing(WriteTempDenied.message),
        ReadFileMissing("Failed to read the shared file."),
        UriSchemeNotSupported("Unsupported URI scheme: ");

        private final String message;

        Key(String msg) {
            message = msg;
        }
    }

    private final KeyedException.Key key;

    public KeyedException(KeyedException.Key key, Throwable cause) {
        super("", cause);
        this.key = key;
    }

    public KeyedException(KeyedException.Key key, String message, Throwable cause) {
        super(message, cause);
        this.key = key;
    }

    public KeyedException.Key getKey() {
        return key;
    }

    @Override
    public String getMessage() {
        return key.message + super.getMessage();
    }
}
