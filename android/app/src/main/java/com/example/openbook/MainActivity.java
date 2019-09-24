package social.openbook.app;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.webkit.MimeTypeMap;

import java.io.ByteArrayInputStream;
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
import java.util.function.Supplier;

import com.example.openbook.ImageConverter;
import com.example.openbook.plugins.ImageConverterPlugin;
import com.example.openbook.util.InputStreamSupplier;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

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
            args.put("video", copyVideoToTempFile(uri).toString());
          }
        } else if (intent.getType().startsWith("video/")) {
          Uri uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
          args.put("video", copyVideoToTempFile(uri).toString());
        } else if (intent.getType().startsWith("text/")) {
          args.put("text", intent.getStringExtra(Intent.EXTRA_TEXT));
        } else {
          Log.w(getClass().getSimpleName(), "unknown intent type \"" + intent.getType() + "\" received, ignoring");
          return;
        }
      } catch (KeyedException e) {
        String msg = String.format("an exception occurred while receiving share of type %s" +
                "%n %s", intent.getType(), e.getCause() != null ? e.getCause().toString() : e.toString());
        String errorTextKey = getLocalizationKey(e);

        args.put("error", errorTextKey);
        Log.w(getClass().getSimpleName(), msg);
      }

      Log.i(getClass().getSimpleName(), "sending intent to flutter");
      eventSink.success(args);
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
        imageStream = this.getContentResolver().openInputStream(imageUri);
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
    Uri result = null;

    if (videoUri.getScheme().equals("content") || videoUri.getScheme().equals("file")) {
      String extension = getExtensionFromUri(videoUri);
      File tempFile = createTemporaryFile("." + extension);
      copyResourceToFile(() -> getContentResolver().openInputStream(videoUri), tempFile);
      result = Uri.fromFile(tempFile);
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

  private void copyResourceToFile(InputStreamSupplier inputSupplier, File target) throws KeyedException {
    try (InputStream input = inputSupplier.get()) {
      try (OutputStream output = new FileOutputStream(target)) {
        byte[] data = new byte[1024];
        int length;
        while ((length = input.read(data)) > 0) {
          output.write(data, 0, length);
        }
      }
      catch (FileNotFoundException e) {
        throw new KeyedException(KeyedException.Key.WriteTempMissing, e);
      } catch (IOException e) {
        throw new KeyedException(KeyedException.Key.WriteTempFailed, e);
      } catch (SecurityException e) {
        throw new KeyedException(KeyedException.Key.WriteTempDenied, e);
      }
    }
    catch (FileNotFoundException e) {
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
