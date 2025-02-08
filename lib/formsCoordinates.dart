import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model_app/home.dart';
import 'package:model_app/speechbuble.dart'; // For date picker

class InputFormScreen extends StatefulWidget {
  const InputFormScreen({super.key});

  @override
  State<InputFormScreen> createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender; // To store the selected gender (Male or Female)

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/background-fashion.jpg", // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // Speech Bubble with Robot Message
                Row(
                  children: [
                    const ImageIcon(
                      AssetImage("assets/robot.png"),
                      color: Color(0xFF3B1C32),
                      size: 55,
                    ),
                    CustomPaint(
                      painter: SpeechBubblePainter(),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin:
                            const EdgeInsets.only(left: 20, top: 10, right: 20),
                        child: const Text(
                          "Greetings, traveler! ",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Input form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Thy Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFFA64D79)),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const ImageIcon(
                            AssetImage("assets/la-personne.png"),
                            size: 10, // Replace with your asset path
                            color: Color(0xFF3B1C32),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth:
                                55, // Add space between the icon and the input
                            minHeight: 35, // Adjust height if needed
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter thy name, for it is required.';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // Submit button
                      ElevatedButton(
                        onPressed: () {
                          // Process the data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                  userName: _nameController
                                      .text), // Pass the text value
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom gender selection widget
  Widget _buildGenderOption(String gender) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedGender == gender
                ? const Color(0xFFA64D79) // Selected border color
                : Colors.grey, // Unselected border color
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _selectedGender == gender
                  ? const Color(0xFF3B1C32) // Selected text color
                  : Colors.black, // Unselected text color
            ),
          ),
        ),
      ),
    );
  }
}
