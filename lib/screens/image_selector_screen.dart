import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../services/wallpaper_channel.dart';

class ImageSelectorScreen extends StatefulWidget {
  const ImageSelectorScreen({super.key});

  @override
  State<ImageSelectorScreen> createState() => _ImageSelectorScreenState();
}

class _ImageSelectorScreenState extends State<ImageSelectorScreen> {
  List<String> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSavedImages();
  }

  Future<void> _loadSavedImages() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedImages = prefs.getStringList('wallpaper_images') ?? [];
    });
  }

  Future<void> _pickImages() async {
    var status = await Permission.photos.request();
    if (status.isGranted || await Permission.storage.request().isGranted) {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          for (var img in images) {
            if (!_selectedImages.contains(img.path)) {
              _selectedImages.add(img.path);
            }
          }
        });
        _saveAndSync();
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    _saveAndSync();
  }

  Future<void> _saveAndSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('wallpaper_images', _selectedImages);
    await WallpaperChannel.sendImagePaths(_selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Apeiron")),
      body: Column(
        children: [
          if (_selectedImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.wallpaper),
                label: const Text("SET AS WALLPAPER"),
                onPressed: () => WallpaperChannel.openWallpaperSettings(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          Expanded(
            child: _selectedImages.isEmpty
                ? const Center(child: Text("No images selected"))
                : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8),
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_selectedImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImages,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add_photo_alternate, color: Colors.white),
      ),
    );
  }
}