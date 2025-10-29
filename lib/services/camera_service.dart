import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  CameraController? get controller => _controller;

  Future<bool> initializeCamera() async {
    try {
      // Request camera permission
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        return false;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        return false;
      }

      // Initialize with front camera if available, otherwise use first camera
      final frontCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      return false;
    }
  }

  Future<String?> takePicture() async {
    if (!_isInitialized || _controller == null) {
      final initialized = await initializeCamera();
      if (!initialized) {
        return null;
      }
    }

    try {
      // Get application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final attendanceDir = Directory(
        path.join(directory.path, 'attendance_photos'),
      );

      if (!await attendanceDir.exists()) {
        await attendanceDir.create(recursive: true);
      }

      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'attendance_$timestamp.jpg';
      final filePath = path.join(attendanceDir.path, fileName);

      // Take picture
      final XFile picture = await _controller!.takePicture();

      // Move to permanent location
      final File newFile = await File(picture.path).copy(filePath);

      // Delete temporary file
      await File(picture.path).delete();

      return newFile.path;
    } catch (e) {
      debugPrint('Error taking picture: $e');
      return null;
    }
  }

  Future<String?> takePictureWithRetry({int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      final result = await takePicture();
      if (result != null) {
        return result;
      }

      // Wait before retry
      await Future.delayed(Duration(seconds: i + 1));
    }
    return null;
  }

  void dispose() {
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }

  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length <= 1) return;

    try {
      final currentLensDirection = _controller?.description.lensDirection;
      final newCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection != currentLensDirection,
        orElse: () => _cameras!.first,
      );

      await _controller?.dispose();

      _controller = CameraController(
        newCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
    } catch (e) {
      debugPrint('Error switching camera: $e');
    }
  }

  Future<bool> hasPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }
}
