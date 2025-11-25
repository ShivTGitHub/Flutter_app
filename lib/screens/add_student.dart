onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CameraView(
        onImageCaptured: (XFile img) {
          print("Image captured: ${img.path}");
          // TODO: continue with face detection + embedding
        },
      ),
    ),
  );
},
