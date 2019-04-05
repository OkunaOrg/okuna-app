package social.openbook.app;

import android.content.ContentResolver;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
    if (intent.getAction().equals(Intent.ACTION_SEND) && intent.getType().startsWith("image/")) {
      if (eventSink != null) {
        Map<String, String> args = new HashMap<>();
        Uri uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
        uri = copyImageToTempFile(uri);
        args.put("type", intent.getType());
        args.put("path", uri.toString());
        Log.i(getClass().getSimpleName(), "sending intent to flutter");
        eventSink.success(args);
      } else if (!streamCanceled && !intentBacklog.contains(intent)) {
        intentBacklog.add(intent);
        Log.i(getClass().getSimpleName(), "intent queued in backlog");
      }
    } else if (intent.getAction().equals(Intent.ACTION_SEND) && intent.getType().startsWith("text/")) {
      if (eventSink != null) {
        Map<String, String> args = new HashMap<>();
        args.put("type", intent.getType());
        args.put("text", intent.getStringExtra(Intent.EXTRA_TEXT));
        Log.i(getClass().getSimpleName(), "sending intent to flutter");
        eventSink.success(args);
      } else if (!streamCanceled && !intentBacklog.contains(intent)) {
        intentBacklog.add(intent);
        Log.i(getClass().getSimpleName(), "intent queued in backlog");
      }
    } else {
      Log.i(getClass().getSimpleName(), "received useless intent action " + intent.getAction() + " type " + intent.getType() + ", not sending");
    }
  }

  private Uri copyImageToTempFile(Uri imageUri) {
    try {
      InputStream inputStream;
      if (imageUri.getScheme().equals("content")) {
        inputStream = this.getContentResolver().openInputStream(imageUri);
      } else {
        inputStream = new FileInputStream(new File(imageUri.getPath()));
      }
      Bitmap bmp = BitmapFactory.decodeStream(inputStream);
      inputStream.close();
      if (bmp == null) return null;

      ByteArrayOutputStream imageDataStream = new ByteArrayOutputStream();
      bmp.compress(Bitmap.CompressFormat.JPEG, 100, imageDataStream);

      File imageFile = createTemporaryFile(".jpeg");
      FileOutputStream fileOutput = new FileOutputStream(imageFile);
      fileOutput.write(imageDataStream.toByteArray());
      inputStream.close();
      fileOutput.close();

      return Uri.fromFile(imageFile);
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
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
