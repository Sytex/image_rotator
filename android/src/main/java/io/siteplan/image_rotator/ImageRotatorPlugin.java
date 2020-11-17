package io.siteplan.image_rotator;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import java.io.FileOutputStream;
import java.io.IOException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** ImageRotatorPlugin */
public class ImageRotatorPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "io.siteplan.image_rotator");
    channel.setMethodCallHandler(new ImageRotatorPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("rotate")) {
      rotate((String) call.argument("imagePath"), (String) call.argument("targetPath"), (double) call.argument("angle"), (int) call.argument("format"), result);
    } else {
      result.notImplemented();
    }
  }

  private Bitmap rotateImage(Bitmap source, double angle) {
      Matrix matrix = new Matrix();
      matrix.postRotate((float)angle);
      return Bitmap.createBitmap(
        source, 0, 0, source.getWidth(), source.getHeight(),matrix, true
      );
  }

  private void rotate(String imagePath, String targetPath, double angle, int format, final Result result) {
    Bitmap imageBitmap = BitmapFactory.decodeFile(imagePath);
    
    try (FileOutputStream out = new FileOutputStream(targetPath)) {
      Bitmap rotatedBitmap = null;
      rotatedBitmap = rotateImage(imageBitmap, angle);

      rotatedBitmap.compress(format == 0 ? Bitmap.CompressFormat.JPEG : Bitmap.CompressFormat.PNG, 100, out);
      result.success(null);
    } catch (IOException e) {
      result.error("IOError", "Failed saving image", e.getMessage());
    }
  }
}
