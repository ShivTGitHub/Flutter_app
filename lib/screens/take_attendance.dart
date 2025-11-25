onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CameraView(
        onImageCaptured: (XFile img) {
          print("Group image captured: ${img.path}");
          // TODO: face detection + multiple recognition
        },
      ),
    ),
  );
},
