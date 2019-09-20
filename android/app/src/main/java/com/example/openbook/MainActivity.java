package social.openbook.app;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.webkit.MimeTypeMap;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.example.openbook.ImageConverter;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.example.openbook.plugins.ImageConverterPlugin;

public class MainActivity extends FlutterActivity {

  public static final String SHARE_STREAM = "openbook.social/receive_share";

  private EventChannel.EventSink eventSink = null;
  private List<Intent> intentBacklog = new ArrayList<>();
  private boolean streamCanceled = false;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    ImageConverterPlugin.registerWith(this.registrarFor("com.example.openbook.plugins.ImageConverterPlugin"));

    new EventChannel(getFlutterView(), SHARE_STREAM).setStreamHandler(
      new EventChannel.StreamHandler() {
        @Override
        public void onListen(Object args, final EventChannel.EventSink events) {
          eventSink = events;
          streamCanceled = false;
          for (int i = 0; i < intentBacklog.size(); i++) {
            sendIntent(intentBacklog.remove(i));
          }
        }

        @Override
        public void onCancel(Object args) {
          eventSink = null;
          streamCanceled = true;
        }
      }
    );

    sendIntent(getIntent());
  }

  @Override
  protected void onNewIntent(Intent intent) {
    super.onNewIntent(intent);
    sendIntent(intent);
  }

  private void sendIntent(Intent intent) {
    if (intent.getAction().equals(Intent.ACTION_SEND)) {
      if (eventSink == null) {
        if (!streamCanceled && !intentBacklog.contains(intent)) {
          intentBacklog.add(intent);
        }
        return;
      }

      Map<String, String> args = new HashMap<>();

      try {
        if (intent.getType().startsWith("image/")) {
          Uri uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
          if (!getExtensionFromUri(uri).equalsIgnoreCase("gif")) {
            args.put("image", copyImageToTempFile(uri).toString());
          } else {
            args.put("video", copyVideoToTempFileIfNeeded(uri).toString());
          }
        } else if (intent.getType().startsWith("video/")) {
          Uri uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
          args.put("video", copyVideoToTempFileIfNeeded(uri).toString());
        } else if (intent.getType().startsWith("text/")) {
          args.put("text", intent.getStringExtra(Intent.EXTRA_TEXT));
        } else {
          Log.w(getClass().getSimpleName(), "unknown intent type \"" + intent.getType() + "\" received, ignoring");
          return;
        }
      } catch (KeyedException e) {
        String msg = String.format("an exception occurred while receiving share of type %s" +
                "%n %s", intent.getType(), e.getCause() != null ? e.getCause().toString() : e.toString());
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

        args.put("error", errorTextKey);
        Log.w(getClass().getSimpleName(), msg);
      }

      Log.i(getClass().getSimpleName(), "sending intent to flutter");
      eventSink.success(args);
    }
  }

  private Uri copyImageToTempFile(Uri imageUri) throws KeyedException {
    byte[] data;
    try {
      if (imageUri.getScheme().equals("content")) {
        data = ImageConverter.convertImageData(this.getContentResolver().openInputStream(imageUri), ImageConverter.TargetFormat.JPEG);
      } else if (imageUri.getScheme().equals("file")) {
        data = ImageConverter.convertImageDataFile(new File(imageUri.getPath()), ImageConverter.TargetFormat.JPEG);
      } else {
        throw new KeyedException(KeyedException.Key.UriSchemeNotSupported, imageUri.getScheme(), null);
      }
    } catch (FileNotFoundException e) {
      throw new KeyedException(KeyedException.Key.ReadFileMissing, e);
    }

    File imageFile = createTemporaryFile(".jpeg");
    try (FileOutputStream fileOutput = new FileOutputStream(imageFile)) {
      fileOutput.write(data);
    } catch (FileNotFoundException e) {
      throw new KeyedException(KeyedException.Key.WriteTempMissing, e);
    } catch (IOException e) {
      throw new KeyedException(KeyedException.Key.WriteTempFailed, e);
    } catch (SecurityException e) {
      throw new KeyedException(KeyedException.Key.WriteTempDenied, e);
    }

    return Uri.fromFile(imageFile);
  }

  private Uri copyVideoToTempFileIfNeeded(Uri videoUri) throws KeyedException {
    Uri result = null;

    if (videoUri.getScheme().equals("file")) {
      result = videoUri;
    } else if (videoUri.getScheme().equals("content")){
      String extension = getExtensionFromUri(videoUri);
      File tempFile = createTemporaryFile("." + extension);

      try (InputStream in = this.getContentResolver().openInputStream(videoUri)) {
        try (OutputStream out = new FileOutputStream(tempFile)) {
          byte[] data = new byte[1024];
          int length;
          while ((length = in.read(data)) > 0) {
            out.write(data, 0, length);
          }

          result = Uri.fromFile(tempFile);
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
        //Exception when closing the input stream. Ignore.
      }
    } else {
      throw new KeyedException(KeyedException.Key.UriSchemeNotSupported, videoUri.getScheme(), null);
    }

    return result;
  }

  private String getExtensionFromUri(Uri uri) throws KeyedException {
    if (uri.getScheme().equals("content")) {
      String mime = this.getContentResolver().getType(uri);
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
      return File.createTempFile(name, extension, this.getExternalFilesDir(Environment.DIRECTORY_PICTURES));
    } catch (IOException e) {
      throw new KeyedException(KeyedException.Key.TempCreationFailed, e);
    } catch (SecurityException e) {
      throw new KeyedException(KeyedException.Key.TempCreationDenied, e);
    }
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
    UriSchemeNotSupported("Unsupported UR scheme: ");

    private String message;

    private Key(String msg) {
      message = msg;
    }
  }
  private final Key key;

  public KeyedException(Key key, Throwable cause) {
    super(cause);
    this.key = key;
  }

  public KeyedException(Key key, String message, Throwable cause) {
    super(message, cause);
    this.key = key;
  }

  public Key getKey() {
    return key;
  }

  @Override
  public String getMessage() {
    return key.message + super.getMessage();
  }
}
