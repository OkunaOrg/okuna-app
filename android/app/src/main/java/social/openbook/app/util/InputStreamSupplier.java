package social.openbook.app.util;

import java.io.FileNotFoundException;
import java.io.InputStream;

@FunctionalInterface
public interface InputStreamSupplier {
    public InputStream get() throws FileNotFoundException;
}