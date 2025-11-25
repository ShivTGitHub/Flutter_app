import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';
import 'dart:ui' as ui;
late FaceDetector _faceDetector;
bool _isBusy = false;
List<Face> _faces = [];


class CameraPreviewWidget extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPreviewWidget({super.key, required this.cameras});

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() {
    _controller = CameraController(
      widget.cameras[_selectedCameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }
  @override
void initState() {
  super.initState();

  _controller = CameraController(
    widget.camera,
    ResolutionPreset.medium,
    enableAudio: false,
  );

  _initializeControllerFuture = _controller.initialize().then((_) {
    _controller.startImageStream(_processCameraImage);
  });

  _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
}


  void _switchCamera() {
    _selectedCameraIndex =
        (_selectedCameraIndex + 1) % widget.cameras.length;
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              CameraPreview(_controller),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: _switchCamera,
                  child: const Icon(Icons.cameraswitch),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
  @override
Widget build(BuildContext context) {
  return FutureBuilder(
    future: _initializeControllerFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Stack(
          children: [
            CameraPreview(_controller),
            CustomPaint(
              painter: FacePainter(_faces),
              child: Container(),
            ),
          ],
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}


InputImage _convertCameraImage(CameraImage image, CameraDescription description) {
  final WriteBuffer allBytes = WriteBuffer();
  for (final Plane plane in image.planes) {
    allBytes.putUint8List(plane.bytes);
  }

  final bytes = allBytes.done().buffer.asUint8List();

  final Size imageSize = Size(
    image.width.toDouble(),
    image.height.toDouble(),
  );

  final camera = description;
  final imageRotation =
      InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
          InputImageRotation.rotation0deg;

  final inputImageFormat =
      InputImageFormatValue.fromRawValue(image.format.raw) ??
          InputImageFormat.nv21;

  final planeData = image.planes.map(
    (plane) {
      return InputImagePlaneMetadata(
        bytesPerRow: plane.bytesPerRow,
        height: plane.height,
        width: plane.width,
      );
    },
  ).toList();

  final inputImageData = InputImageData(
    size: imageSize,
    imageRotation: imageRotation,
    inputImageFormat: inputImageFormat,
    planeData: planeData,
  );

  return InputImage.fromBytes(
    bytes: bytes,
    inputImageData: inputImageData,
  );
}

Future<void> _processCameraImage(CameraImage image) async {
  if (_isBusy) return;
  _isBusy = true;

  try {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final InputImageRotation rotation =
        InputImageRotation.rotation0deg; // Adjust later per camera

    final InputImageFormat format =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: rotation,
      inputImageFormat: format,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );

    final faces = await _faceDetector.processImage(inputImage);

    setState(() {
      _faces = faces;
    });
  } catch (e) {
    print("Face detection error: $e");
  }

  _isBusy = false;
}
