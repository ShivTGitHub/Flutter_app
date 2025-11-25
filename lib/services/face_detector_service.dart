import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorService {
  final FaceDetector _detector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableTracking: true,
      enableClassification: true,
      enableContours: false,
      minFaceSize: 0.15,
    ),
  );

  Future<List<Face>> detectFaces(InputImage image) async {
    final faces = await _detector.processImage(image);
    return faces;
  }

  void dispose() {
    _detector.close();
  }
}
