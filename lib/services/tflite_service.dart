import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/models/model.tflite',
      
    );
  }

  double predict(Float32List input) {
    final inputTensor = List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) => List.generate(
            3,
            (c) => input[(y * 224 + x) * 3 + c],
          ),
        ),
      ),
    );

    final output = List.generate(
      1,
      (_) => List.filled(1, 0.0),
    );

    _interpreter!.run(inputTensor, output);

    return output[0][0];
  }

  void close() {
    _interpreter?.close();
  }
}