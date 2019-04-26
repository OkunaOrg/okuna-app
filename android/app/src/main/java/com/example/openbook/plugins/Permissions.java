package social.openbook.app.plugins;

import android.Manifest;
import android.content.pm.PackageManager;
import android.util.SparseArray;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class Permissions implements MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {
    private Registrar registrar;
    private SparseArray<Result> result;

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "openbook.social/permissions");
        Permissions permissions = new Permissions(registrar);
        channel.setMethodCallHandler(permissions);
        registrar.addRequestPermissionsResultListener(permissions);
    }

    private Permissions(Registrar registrar) {
        this.registrar = registrar;
        this.result = new SparseArray<>();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "checkPermission":
                result.success(checkPermission(call.argument("permission")));
                break;
            case "requestPermission":
                requestPermission(call.argument("permission"), result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private String getManifestPermission(String permission) {
        switch (permission) {
            case "WRITE_EXTERNAL_STORAGE":
                return Manifest.permission.WRITE_EXTERNAL_STORAGE;
            default:
                return permission;
        }
    }

    private boolean checkPermission(String permission) {
        return ContextCompat.checkSelfPermission(registrar.activity(), getManifestPermission(permission)) == PackageManager.PERMISSION_GRANTED;
    }

    private void requestPermission(String permission, Result result) {
        permission = getManifestPermission(permission);
        this.result.put(permission.hashCode(), result);
        ActivityCompat.requestPermissions(registrar.activity(), new String[] {permission}, permission.hashCode());
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        Result result = this.result.get(requestCode);
        if (result != null && permissions.length == 1 && permissions[0].hashCode() == requestCode) {
            boolean value = grantResults[0] == PackageManager.PERMISSION_GRANTED;
            result.success(value);
            this.result.delete(requestCode);
            return value;
        }
        return false;
    }
}