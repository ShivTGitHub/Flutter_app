import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class EmbeddingService {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    // Load the TFLite model from assets
    _interpreter = await Interpreter.fromAsset(
      'models/mobilefacenet.tflite',
      options: InterpreterOptions()..threads = 4, // use more CPU threads
    );
    print("MobileFaceNet model loaded!");
  }

  // This function will later accept a face image tensor
  List<double> getEmbedding(Float32List input) {
    // Input shape example: [1,112,112,3]
    var inputShape = _interpreter.getInputTensor(0).shape;
    var outputShape = _interpreter.getOutputTensor(0).shape;

    // Output buffer based on model shape
    var output = List<double>.filled(outputShape[1], 0);

    _interpreter.run(input, output);

    return output; // 128-D embedding
  }
}
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class EmbeddingService {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    // Load the TFLite model from assets
    _interpreter = await Interpreter.fromAsset(
      'models/mobilefacenet.tflite',
      options: InterpreterOptions()..threads = 4, // use more CPU threads
    );
    print("MobileFaceNet model loaded!");
  }

  // This function will later accept a face image tensor
  List<double> getEmbedding(Float32List input) {
    // Input shape example: [1,112,112,3]
    var inputShape = _interpreter.getInputTensor(0).shape;
    var outputShape = _interpreter.getOutputTensor(0).shape;

    // Output buffer based on model shape
    var output = List<double>.filled(outputShape[1], 0);

    _interpreter.run(input, output);

    return output; // 128-D embedding
  }
}
