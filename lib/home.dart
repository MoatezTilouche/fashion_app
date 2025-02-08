import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:model_app/appBar.dart';
import 'package:model_app/outfit_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController _occasionController = TextEditingController();
  String? _selectedTheme;
  File? _pickedImage;
  String? _pickedImageUrl;
  bool _isLoading = false;

  final List<String> _themes = [
    'Astrophysics 🌌',
    'Neuroscience 🧠',
    'Bioinformatics 💻🧬',
    'Renewable Energy ☀️💨',
    'Nanotechnology 🏗️',
    'Black Holes 🕳️',
  ];

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? const Color(0xFF6A1E55) : const Color(0xFFA64D79),
        ),
      );
    },
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _occasionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _isLoading = true);

    if (kIsWeb) {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((event) {
        final file = uploadInput.files!.first;
        final reader = html.FileReader();

        reader.onLoadEnd.listen((event) {
          setState(() {
            _pickedImageUrl = reader.result as String;
            _isLoading = false;
          });
        });

        reader.readAsDataUrl(file);
      });
    } else {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showPopup(BuildContext context) async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://127.0.0.1:5000/generate-outfit"), // Flask API URL
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', _pickedImage!.path),
    );

    request.fields['theme'] = _selectedTheme ?? "default";

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonData = json.decode(responseData);
        setState(() {
          _isLoading = false;
        });

        _showResultsPopup(context, jsonData);
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network Error: $e")),
      );
    }
  }

  void _showResultsPopup(BuildContext context, Map<String, dynamic> jsonData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color(0xFFFBE8E7),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Detection Results",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                _buildResultRow("assets/la-personne.png", "Age: ${jsonData['age']}"),
                _buildResultRow("assets/male-et-femelle.png", "Sexe: ${jsonData['gender']}"),
                _buildResultRow("assets/bonne-humeur.png", "Mood: ${jsonData['emotion']}"),
                _buildResultRow("assets/tenue.png", "Outfit Suggestion: ${jsonData['outfit_suggestion']}"),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OutfitResultPage(outfitImages: jsonData["images"]),
                          ),
                        );
                      },
                      icon: const ImageIcon(
                        AssetImage("assets/ai-cerveau.png"),
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        "Generate Images",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultRow(String asset, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ImageIcon(
            AssetImage(asset),
            color: const Color(0xFF3B1C32),
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/background-fashion.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: _animation,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.waving_hand,
                            color: Color(0xFF3B1C32),
                            size: 40,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Welcome, ${widget.userName}!',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B1C32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Occasion Theme Selection Card
                FadeTransition(
                  opacity: _animation,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select a Theme or Type Your Own:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B1C32),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _themes.map((theme) {
                              return ChoiceChip(
                                label: Text(theme),
                                selected: _selectedTheme == theme,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedTheme = selected ? theme : null;
                                  });
                                },
                                selectedColor: const Color(0xFF3B1C32),
                                labelStyle: TextStyle(
                                  color: _selectedTheme == theme ? Colors.white : Colors.black,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _occasionController,
                            decoration: InputDecoration(
                              hintText: 'Type your own theme...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Image Upload Card
                FadeTransition(
                  opacity: _animation,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upload an Image:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B1C32),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: _pickedImage != null || _pickedImageUrl != null
                                  ? kIsWeb
                                      ? Image.network(
                                          _pickedImageUrl!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          _pickedImage!,
                                          fit: BoxFit.cover,
                                        )
                                  : const Center(
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Loading Indicator or Generate Button
                _isLoading
                    ? Center(child: spinkit)
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _showPopup(context),
                              icon: const Icon(Icons.check, color: Colors.white),
                              label: const Text(
                                'Get Outfit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Add functionality for "Your aged Self" button
                              },
                              icon: const ImageIcon(
                                AssetImage('assets/vieil-homme.png'),
                                color: Colors.white,
                                size: 24,
                              ),
                              label: const Text(
                                'Your aged Self',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}