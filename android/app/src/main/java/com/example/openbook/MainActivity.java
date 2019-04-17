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

import social.openbook.app.plugins.Permissions;

public class MainActivity extends FlutterActivity {

  public static final String SHARE_STREAM = "openbook.social/receive_share";

  private EventChannel.EventSink eventSink = null;
  private List<Intent> intentBacklog = new ArrayList<>();
  private boolean streamCanceled = false;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    Permissions.registerWith(this.registrarFor("social.openbook.app.plugins.Permissions"));

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
        args.put("path", uri.toString());
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
