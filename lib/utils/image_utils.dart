import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageUtils {

  // Preprocess image for MobileFaceNet
  static Float32List preprocess(img.Image faceImage) {
    // Resize to 112x112
    final img.Image resized = img.copyResize(
      faceImage,
      width: 112,
      height: 112,
    );

    // Convert to float32 and normalize
    final Float32List input = Float32List(1 * 112 * 112 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < 112; y++) {
      for (int x = 0; x < 112; x++) {
        final pixel = resized.getPixel(x, y);

        input[pixelIndex++] = (img.getRed(pixel) / 255.0);
        input[pixelIndex++] = (img.getGreen(pixel) / 255.0);
        input[pixelIndex++] = (img.getBlue(pixel) / 255.0);
      }
    }

    return input;
  }
}
