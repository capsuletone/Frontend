// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:image_picker/image_picker.dart';

// import 'scan_result_screen.dart';

// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   CameraController? _controller;
//   List<CameraDescription>? _cameras;
//   bool _isCameraInitialized = false;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     _cameras = await availableCameras();
//     if (_cameras != null && _cameras!.isNotEmpty) {
//       _controller = CameraController(_cameras![0], ResolutionPreset.medium);
//       await _controller!.initialize();
//       if (!mounted) return;
//       setState(() {
//         _isCameraInitialized = true;
//       });
//     }
//   }

//   Future<void> _takePicture() async {
//     if (_controller != null && _controller!.value.isInitialized) {
//       try {
//         final XFile image = await _controller!.takePicture();
//         if (!mounted) return;

//         File imageFile = File(image.path);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TextRecognitionScreen(imageFile: imageFile),
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('사진 촬영 실패: $e')),
//         );
//       }
//     }
//   }

//   //갤러리에서 사진 가져옴
//   Future _getFromGallery() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile == null) return;
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('카메라 화면')),
//       body: _isCameraInitialized
//           ? Stack(
//               children: [
//                 CameraPreview(_controller!),
//                 Positioned(
//                   bottom: 30,
//                   left: MediaQuery.of(context).size.width / 3 - 30,
//                   child: FloatingActionButton(
//                     heroTag: 'camera',
//                     onPressed: _takePicture,
//                     child: Icon(Icons.camera),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 30,
//                   right: MediaQuery.of(context).size.width / 3 - 30,
//                   child: FloatingActionButton(
//                     heroTag: 'gallery',
//                     onPressed: _pickImageFromGallery,
//                     child: Icon(Icons.image),
//                   ),
//                 ),
//               ],
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }
