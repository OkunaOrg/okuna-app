package social.openbook.app;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.webkit.MimeTypeMap;

import java.io.File;
import java.io.FileInputStream;
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
      if (intent.getType().startsWith("image/")) {
        Uri uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
        uri = copyImageToTempFile(uri);
        args.put("image", uri.toString());
      } else if (intent.getType().startsWith("video/")) {
        Uri uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
        uri = copyVideoToTempFileIfNeeded(uri);
        if (uri != null) {
          args.put("video", uri.toString());
        } else {
          return;
        }
      } else if (intent.getType().startsWith("text/")) {
        args.put("text", intent.getStringExtra(Intent.EXTRA_TEXT));
      } else {
        Log.w(getClass().getSimpleName(), "unknown intent type \"" + intent.getType() + "\" received, ignoring");
        return;
      }
      Log.i(getClass().getSimpleName(), "sending intent to flutter");
      eventSink.success(args);
    }
  }

  private Uri copyImageToTempFile(Uri imageUri) {
    try {
      byte[] data;
      if (imageUri.getScheme().equals("content")) {
        data = ImageConverter.convertImageData(this.getContentResolver().openInputStream(imageUri), ImageConverter.TargetFormat.JPEG);
      } else {
        data = ImageConverter.convertImageDataFile(new File(imageUri.getPath()), ImageConverter.TargetFormat.JPEG);
      }

      File imageFile = createTemporaryFile(".jpeg");
      FileOutputStream fileOutput = new FileOutputStream(imageFile);
      fileOutput.write(data);
      fileOutput.close();

      return Uri.fromFile(imageFile);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  private Uri copyVideoToTempFileIfNeeded(Uri videoUri) {
    Uri result = null;

    if (videoUri.getScheme().equals("file")) {
      result = videoUri;
    } else if (videoUri.getScheme().equals("content")){
      String extension = getExtensionFromContentUri(videoUri);
      File tempFile = createTemporaryFile("." + extension);

      try (InputStream in = this.getContentResolver().openInputStream(videoUri);
           OutputStream out = new FileOutputStream(tempFile)) {
        byte[] data = new byte[1024];
        int length;
        while ((length = in.read(data)) > 0) {
          out.write(data, 0, length);
        }

        result = Uri.fromFile(tempFile);
      } catch (IOException e) {
        throw new RuntimeException(e);
      }
    }

    return result;
  }

  private String getExtensionFromContentUri(Uri contentUri) {
    String mime = this.getContentResolver().getType(contentUri);
    return MimeTypeMap.getSingleton().getExtensionFromMimeType(mime);
  }

  private File createTemporaryFile(String extension) {
    try {
      String name = UUID.randomUUID().toString();
      return File.createTempFile(name, extension, this.getExternalFilesDir(Environment.DIRECTORY_PICTURES));
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }
}
