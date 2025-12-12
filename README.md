# Flutter Weather App

This simple Flutter application fetches weather information for a specified city using the OpenWeatherMap API. The app features a splash screen and an animated user interface.

## Features

- A splash screen while the app opens.
- Fetches and displays current weather information including description, temperature, wind speed, humidity, etc.
- Allows users to enter a city name to get the weather details.
- Dynamic background images based on the current weather conditions.

## Screenshots

![Splash Screen](assets/splash_screen.png) 
![Weather Screen](assets/weather_screen.png)

## Run Locally

### Prerequisites

- Flutter SDK installed on your machine.
- An IDE like Android Studio, Visual Studio Code, or IntelliJ IDEA.
- An [OpenWeatherMap API key](https://openweathermap.org/api). You can sign up for a free account at [OpenWeatherMap](https://openweathermap.org/).

### Installation

1. Fork this repository

    Forking this repository will create a copy of it in your GitHub account.

2. Clone the forked repository

   ```bash
   git clone https://github.com/yourusername/flutter-weather-app.git
   ```

3. Create a new Flutter Project with the following structure

    ```bash
    weather_app/
    ├── android/                   # Android-specific files
    ├── ios/                       # iOS-specific files
    ├── lib/                       
    │   ├── main.dart              # Main Dart code
    ├── assets/                    # Assets used in the app
    │   ├── clouds.png             
    │   ├── partly_cloudy.jpg      
    │   ├── cloudy.jpg             
    │   ├── rain.jpg              
    │   ├── snow.jpg               
    │   └── default.png            
    ├── pubspec.yaml               # Flutter package configuration
    └── README.md                  # Project documentation
    ```

4. Navigate into the directory having the cloned files and open the files in your workspace

   ```bash
   cd flutter-weather-app
   code .
   ```
5. Copy the codes and paste them into your new Flutter Project's files

6. Install dependencies
    ```
    flutter pub get
    ```

7. Obtain an API key from OpenWeatherMap and replace the placeholder in the code in main.dart, line 147
    ```bash
    const String apiKey = 'YOUR_API_KEY';
    ```

8. Run the app
    ```bash
    flutter run
    ```

