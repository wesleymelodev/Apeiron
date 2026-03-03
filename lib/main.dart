import 'package:apeiron/services/wallpaper_channel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const ApeironApp());
}

class ApeironApp extends StatelessWidget {
  const ApeironApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const ImageSelectorScreen(),
    );
  }
}

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
    _loadSavedImages(); // Carrega as imagens ao abrir o app
  }

  // Carrega imagens salvas anteriormente
  Future<void> _loadSavedImages() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedImages = prefs.getStringList('wallpaper_images') ?? [];
    });
  }

  // Função para selecionar múltiplas imagens
  Future<void> _pickImages() async {
    var status = await Permission.photos.request();
    if (status.isGranted || await Permission.storage.request().isGranted) {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          // Adiciona apenas se o caminho ainda não existir (evita duplicados)
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

  // Remove uma imagem específica
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    _saveAndSync();
  }

  // Salva no SharedPreferences e envia para o Kotlin (Wallpaper)
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
                ),
              ),
            ),
          Expanded(
            child: _selectedImages.isEmpty
                ? const Center(child: Text("No images selected"))
                : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                Image.file(
                    File(_selectedImages[index]),
                    fit: BoxFit.cover
                );
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
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }
}