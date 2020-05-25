package social.openbook.app;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.io.InputStream;
import java.io.ByteArrayOutputStream;

public class ImageConverter {
    public enum TargetFormat {
        JPEG,
        PNG
    }

    public static byte[] convertImageData(InputStream imageData, TargetFormat format) {
        Bitmap bmp = BitmapFactory.decodeStream(imageData);
        if (bmp == null) return null;

        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        switch (format) {
            case JPEG:
                bmp.compress(Bitmap.CompressFormat.JPEG, 100, outputStream);
                break;
            case PNG:
                bmp.compress(Bitmap.CompressFormat.PNG, 100, outputStream);
                break;
        }

        return outputStream.toByteArray();
    }
}
