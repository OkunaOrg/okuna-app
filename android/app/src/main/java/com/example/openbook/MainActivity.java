package social.openbook.app;

import android.content.Intent;
import android.os.Bundle;
import com.example.openbook.plugins.ImageConverterPlugin;
import com.example.openbook.plugins.SharePlugin;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.plugins.PluginRegistry;

public class MainActivity extends FlutterActivity {
    private SharePlugin sharePlugin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Register the ImageConverterPlugin manually. It won't register automatically since it isn't added as a plugin via
        // our pubspec.yaml.
        // Note: getFlutterEngine() should not be null here since it is created in super.onCreate().
        PluginRegistry pluginRegistry = getFlutterEngine().getPlugins();
        pluginRegistry.add(new ImageConverterPlugin());
        sharePlugin = new SharePlugin();
        pluginRegistry.add(sharePlugin);

        // Pass the intent that created this activity to the share plugin,
        // just in case it is an ACTION_SEND intent with share data.
        sharePlugin.handleIntent(getIntent());
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        sharePlugin.handleIntent(intent);
    }
}
