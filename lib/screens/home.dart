import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:wheather/constants/constans.dart';
import 'package:wheather/refactoring.dart/containers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoaded = false;
  num temp = 0;
  num press = 0;
  num hum = 0;
  num cover = 0;
  String cityName = 'Not Available';

  final controller = TextEditingController();

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    try {
      var p = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          forceAndroidLocationManager: true);

      log('Lat:${p.latitude}, Long:${p.longitude}');
      getCurrentCityWeather(p);
    } catch (e) {
      log('Error getting current location: $e');
    }
  }

  getCityWeather(String cityName) async {
    try {
      var client = http.Client();
      var uri = '${domain}q=$cityName&appid=$apiKey';

      var url = Uri.parse(uri);
      var response = await client.get(url);
      if (response.statusCode == 200) {
        var data = response.body;
        var decodeData = jsonDecode(data);
        log(data);
        updateUI(decodeData);
        setState(() {
          isLoaded = true;
        });
      } else {
        log('Weather API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching city weather: $e');
    }
  }

  getCurrentCityWeather(Position position) async {
    try {
      var client = http.Client();
      var uri =
          '${domain}lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey';
      var url = Uri.parse(uri);
      var response = await client.get(url);
      if (response.statusCode == 200) {
        var data = response.body;
        var decodeData = jsonDecode(data);
        log(data);
        updateUI(decodeData);
        setState(() {
          isLoaded = true;
        });
      } else {
        log('Weather API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching current city weather: $e');
    }
  }

  void updateUI(var decodedData) {
    setState(() {
      if (decodedData == null) {
        temp = 0;
        press = 0;
        hum = 0;
        cover = 0;
        cityName = 'Not Available';
      } else {
        temp = (decodedData['main']['temp'] ?? 0) - 273;
        press = decodedData['main']['pressure'] ?? 0;
        hum = decodedData['main']['humidity'] ?? 0;
        cover = decodedData['clouds']['all'] ?? 0;
        cityName = decodedData['name'] ?? 'Not Available';
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Drawer Header',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: () {
            // Add functionality for the first drawer item
          },
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {
            // Add functionality for the second drawer item
          },
        ),
        // Add more ListTiles for additional drawer items
      ],
    ),
  ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: kBgcolor),
        child: Visibility(
          visible: isLoaded,
          replacement: const Center(child: CircularProgressIndicator()),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    child: const ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60)),
                      child: Image(
                        image: AssetImage('assets/images/map.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 70),
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: TextFormField(
                          onFieldSubmitted: (String value) {
                            setState(() {
                              cityName = value;
                              getCityWeather(value);
                              controller.clear();
                            });
                          },
                          cursorColor: kBlack,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: kBlack,
                          ),
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Search City',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: kGrey,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 25,
                              color: kGrey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.pin_drop,
                      color: Color.fromARGB(255, 255, 174, 174),
                      size: 40,
                    ),
                    Text(
                      cityName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: kWhite,
                          fontFamily: 'Righteous'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Containers(
                  value: temp,
                  title: 'Temperature',
                  lastText: '℃',
                  image: 'assets/temp.png'),
              Containers(
                  value: press,
                  lastText: 'hPa',
                  title: 'Pressure',
                  image: 'assets/barometer.png'),
              Containers(
                  value: hum,
                  lastText: '%',
                  title: 'Humidity',
                  image: 'assets/humidity.png'),
              Containers(
                  value: cover,
                  lastText: '%',
                  title: 'Cloud Cover',
                  image: 'assets/cloud cover.png'),
            ],
          ),
        ),
      ),
    );
  }
}
