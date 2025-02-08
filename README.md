# Fashion app - Flutter Frontend for Outfit Recommendation App  

## Overview  

Fashion app  is a Flutter-based mobile application that serves as the frontend for an AI-powered outfit recommendation system. The app connects to a backend API to analyze user images, detect clothing, and generate personalized outfit recommendations. With a sleek and modern design, Fashionista provides a seamless user experience, complete with a spinner animation to indicate AI processing.

---

## Features  

- **Modern UI/UX Design**: Clean and intuitive user interface with smooth animations.  
- **Image Upload**: Users can upload images for outfit analysis.  
- **Backend Integration**: Connects to a Flask backend for AI-powered outfit recommendations.  
- **Spinner Animation**: Displays a loading spinner while the backend processes the image and generates recommendations.  
- **Outfit Display**: Shows AI-generated outfit recommendations with images and descriptions.  

---

## Technologies Used  

- **Flutter**: Framework for building cross-platform mobile applications.  
- **Dart**: Programming language used for Flutter development.  
- **HTTP Package**: For making API requests to the backend.  
- **Provider**: State management for managing app state.  
- **Lottie**: For displaying animations (e.g., spinner during loading).  
- **Flask Backend**: For AI-powered outfit recommendations (person detection, clothing classification, facial analysis, and outfit generation).  

---

## Installation  

### Prerequisites  

- Flutter SDK installed on your machine.  
- Backend API running (Flask-based outfit recommendation API).  

### Steps  

1. Clone the repository:  
   ```bash
   git clone https://github.com/your-username/fashionista-flutter.git
   cd fashionista-flutter
2. Install dependencies:
  ```bash
  flutter pub ge
  ```
3. Update backend URL:
  Open the configuration file and replace `YOUR_BACKEND_URL` with your backend API URL.

4. Run the app:
  ```bash
  flutter run
  ```
### Usage

1. Home Screen:

The app opens to a home screen with a welcome message and a button to upload an image.

2. Image Upload:

Tap the "Upload Image" button to select or capture an image.

3. AI Processing:

After uploading the image, the app displays a spinner animation while the backend processes the image and generates outfit recommendations.

4. Outfit Recommendation:

Once processing is complete, the app displays the AI-generated outfit recommendations, including images and descriptions.


### Backend Integration:
The app communicates with a Flask-based backend API to:

1. Upload user images for analysis.

2. Receive AI-generated outfit recommendations.

3. Display the results in a user-friendly format.

4. Ensure the backend is running and accessible before using the app.

### License:
This project is licensed under the MIT License.

### Contact :
For questions or feedback, please reach out to:

Moatez Tlilouch: moateztilouch@gmail.com 
