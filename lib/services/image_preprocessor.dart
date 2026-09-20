import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

class ImagePreprocessor {
  static Float32List preprocess(File imageFile) {
    final bytes = imageFile.readAsBytesSync();

    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception("Unable to decode image");
    }

    //IMPORTANT
    image=img.bakeOrientation(image);
    image = img.copyResize(
      image,
      width: 224,
      height: 224,
    );

    final input = Float32List(1 * 224 * 224 * 3);

    int index = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {

        final pixel = image.getPixel(x, y);

        input[index++] = pixel.r.toDouble();
        input[index++] = pixel.g.toDouble();
        input[index++] = pixel.b.toDouble();
      }
    }

    return input;
  }
}