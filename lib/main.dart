import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _startSplashScreen();
  }

  void _startSplashScreen() async {
    await Future.delayed(Duration(seconds: 1), () {});
    _controller.forward();
    await Future.delayed(Duration(seconds: 3), () {});
    await Future.delayed(Duration(seconds: 1), () {});
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => WeatherScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _positionAnimation = Tween<double>(begin: -150.0, end: MediaQuery.of(context).size.width).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 82, 115),
      body: Center(
        child: Stack(
          children: [
            // Animated image
            AnimatedBuilder(
              animation: _positionAnimation,
              builder: (context, child) {
                return Positioned(
                  left: _positionAnimation.value,
                  top: 250.0,
                  child: Image.asset(
                    'assets/clouds.png',
                    width: 150,
                    height: 150,
                  ),
                );
              },
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Welcome to Weather App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> with SingleTickerProviderStateMixin {
  String _weatherDescription = 'Haze';
  String _mainDescription = 'Haze';
  String _cityName = 'Bangalore'; //default city and weather descriptions
  String _temperature = '26°C';
  String _windSpeed = '10 km/h';
  String _feelslike = '20°C';
  String _visibility = '4.85km';
  String _humidity = '58%';
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _cityFocusNode = FocusNode();
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    getWeather(_cityName); //fetch weather data when the app starts

    //fade animations to ease the eye and avoid flutter's default bright screens
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
  }

  Future<void> getWeather(String cityName) async {
    setState(() {
      _fadeController.reverse();
    });

    const String apiKey = ''; //replace with your OpenWeatherMap API key
    final String url = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _weatherDescription = data['weather'][0]['description'];
          _mainDescription = data['weather'][0]['main'];
          _temperature = '${data ['main']['temp']}°C';
          _windSpeed = '${data['wind']['speed']} km/h';
          _humidity = '${data['main']['humidity']}%';
          _visibility = '${data['visibility'] / 1000} km';
          _feelslike = '${data['main']['feels_like']}°C';
        });
      } else {
        setState(() {
          _weatherDescription = "Network Error!";
        });
      }
    } catch (e) {
      setState(() {
        _weatherDescription = 'Error fetching weather data';
      });
    } finally {
      setState(() {
        _fadeController.forward();
      });
    }
  }

  String capitalizeFirstLetter(String text) {
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String backgroundImage;

    switch (_mainDescription) {
      case 'Clouds':
      case 'Clear':
        backgroundImage = 'assets/partly_cloudy.jpg';
        break;
      case 'Rain':
        backgroundImage = 'assets/rain.jpg';
        break;
      case 'Drizzle':
        backgroundImage = 'assets/drizzle.jpg';
        break;
      case 'Thunderstorm':
        backgroundImage = 'assets/thunderstorm.jpg';
        break;
      case 'Snow':
        backgroundImage = 'assets/snow.jpg';
        break;
      default:
        backgroundImage = 'assets/default.png';
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 22, 82, 115),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 70),
                  Text(
                    capitalizeFirstLetter(_cityName),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _temperature,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    capitalizeFirstLetter(_weatherDescription),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '$_temperature feels like $_feelslike',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            ' ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Wind Speed: $_windSpeed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Visibility: $_visibility',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Humidity: $_humidity',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _cityController,
                      focusNode: _cityFocusNode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        hintText: _cityFocusNode.hasFocus ? '' : 'Enter City Name',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black, width : 0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black, width: 0.5),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_cityController.text.isNotEmpty) {
                        _cityName = _cityController.text.trim();
                        getWeather(_cityName);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Get Weather'),
                  ),
                  SizedBox(height: 20),
                  Text( //empty child for space
                    ' ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 5,
                    ),
                  ),
                  Text( //empty child for space
                    ' ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text( //creator credits
                    'Sayali Khapekar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text( //creator credits
                    'Shashwat Sahay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text( //creator credits
                    'Vaishnavi M Sankaran',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}