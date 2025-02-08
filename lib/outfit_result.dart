import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:model_app/appBar.dart';

class OutfitResultPage extends StatefulWidget {
    final Map<String, dynamic> outfitImages;

  const OutfitResultPage({super.key,required this.outfitImages});

  @override
  State<OutfitResultPage> createState() => _OutfitResultPageState();
}

class _OutfitResultPageState extends State<OutfitResultPage> {

  bool _isLoading = true;
  String _outfitTitle = "Outfit generated for the theme selected";
  String _outfitImage = "assets/outfit_gen.png"; // Default placeholder
  List<Map<String, String>> _outfitPieces = [];

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color:
              index.isEven ? const Color(0xFF6A1E55) : const Color(0xFFA64D79),
        ),
      );
    },
  );

  @override
  void initState() {
    super.initState();
    _generateOutfit();
  }

 void _generateOutfit() {
    setState(() {
      _isLoading = false;
      _outfitImage = widget.outfitImages["outfit"] ?? "assets/outfit_gen.png";
      _outfitPieces = [
        {"icon": "👕", "name": "Top", "image": widget.outfitImages["top"] ?? "assets/shirt.jpg"},
        {"icon": "👖", "name": "Bottom", "image": widget.outfitImages["pants"] ?? "assets/jeans.jpg"},
        {"icon": "👟", "name": "Shoes", "image": widget.outfitImages["shoes"] ?? "assets/shoes.jpg"},
      ];
    });
  }

  Widget _buildOutfitItem(Map<String, String> item) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(item["icon"]!, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item["name"]!,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: item["image"]!.startsWith("http")
                  ? Image.network("http://127.0.0.1:5000${item["image"]!}", fit: BoxFit.cover, height: 120)
                  : Image.asset(item["image"]!, fit: BoxFit.cover, height: 120),
            ),
          ],
        ),
      ),
    );
  }
  /// **🔹 Display outfit image**

  Widget _buildOutfitImage() {
    return _outfitImage.startsWith("http")
        ? Image.network("http://127.0.0.1:5000$_outfitImage", fit: BoxFit.cover, height: 250)
        : Image.asset(_outfitImage, fit: BoxFit.cover, height: 250);
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
                "assets/background-fashion.jpg", // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    _outfitTitle,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Outfit Image Card
                  _isLoading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            spinkit,
                            const SizedBox(height: 20),
                            const Text(
                              "Outfit is generating...",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ],
                        )
                      : _buildOutfitImage(),

                  const SizedBox(height: 20),

                  // Clothing Items Displayed in Cards
                  if (!_isLoading)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _outfitPieces.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _outfitPieces[index]["icon"]!,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _outfitPieces[index]["name"]!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.check_circle,
                                        color: Colors.green),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    _outfitPieces[index]["image"]!,
                                    fit: BoxFit.cover,
                                    height: 120,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  // Buttons
                  if (!_isLoading)
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _generateOutfit,
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text(
                            "Generate Another Outfit",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B1C32),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
