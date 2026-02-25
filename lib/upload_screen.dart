import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'api_services/services.dart'; // your uploadPost method

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({Key? key}) : super(key: key);

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  File? _imageFile;
  final TextEditingController _textController = TextEditingController();
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  /// Request gallery permissions
  Future<void> _requestPermissionAndPickImage() async {
    try {
      if (Platform.isAndroid) {
        PermissionStatus status;
        if (await Permission.photos.isDenied || await Permission.photos.isPermanentlyDenied) {
          // For Android 13+ use photos/media library permission
          status = await Permission.photos.request();
        } else {
          status = await Permission.photos.status;
        }

        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Storage permission denied. Please enable it in settings.')),
          );
          openAppSettings();
          return;
        }
      } else if (Platform.isIOS) {
        PermissionStatus status = await Permission.photos.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photos permission denied. Please enable it in settings.')),
          );
          openAppSettings();
          return;
        }
      }

      // Now pick the image
      final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } catch (e) {
      debugPrint('Permission or pick image error: $e');
    }
  }

  /// Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } catch (e) {
      debugPrint('Pick image error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  /// Upload method remains the same
  Future<void> _upload() async {
    if (_imageFile == null || _textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide both image and text')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      await CardsApiService.uploadPost(
        text: _textController.text.trim(),
        imageFile: _imageFile!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload successful')),
      );

      setState(() {
        _imageFile = null;
        _textController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }

    setState(() => _isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Image preview
            GestureDetector(
              onTap: _requestPermissionAndPickImage,
              child: _imageFile != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imageFile!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_a_photo,
                  size: 50,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Text input
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Upload button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _upload,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Upload',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
