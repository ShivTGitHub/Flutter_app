import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_test_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Face Attendance System")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CameraTestScreen(cameras: cameras),
                  ),
                );
              },
              child: const Text("Add Student"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CameraTestScreen(cameras: cameras),
                  ),
                );
              },
              child: const Text("Take Attendance"),
            ),
          ],
        ),
      ),
    );
  }
}
