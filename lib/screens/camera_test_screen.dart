import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../widgets/camera_preview_widget.dart';

class CameraTestScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const CameraTestScreen({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Test")),
      body: CameraPreviewWidget(cameras: cameras),
    );
  }
}
