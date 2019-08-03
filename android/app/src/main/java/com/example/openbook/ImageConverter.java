package com.example.openbook;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.io.*;

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

    public static byte[] convertImageDataFile(File file, TargetFormat format) throws FileNotFoundException {
        return convertImageData(new FileInputStream(file), format);
    }
}
