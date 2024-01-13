import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:weather_app/dash_with_sign.dart';
import 'package:weather/weather.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:developer';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set AppGroup Id. This is needed for iOS Apps to talk to their WidgetExtensions
  await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');
  // Register an Interactivity Callback. It is necessary that this method is static and public
  await HomeWidget.registerInteractivityCallback(interactiveCallback);
  WeatherFactory wf = new WeatherFactory("b90fa66ffac0aaa5c738c8ac61f8ae04");
  Weather w = await wf.currentWeatherByCityName("Minneapolis");
  double degree = w.temperature!.celsius as double;
  double degree2 = w.temperature!.fahrenheit as double;

  int c = degree.toInt();
  int f = degree2.toInt();

  log('$c');
  HomeWidget.saveWidgetData(
    'weather_degree',
    c, //'${degree}°C',
  );
  HomeWidget.saveWidgetData(
    'x',
    f,
  );
  await HomeWidget.updateWidget(
    iOSName: 'CounterWidget',
    androidName: 'CounterWidgetProvider',
  );
  runApp(const MyApp());
}

/// Callback invoked by HomeWidget Plugin when performing interactive actions
/// The @pragma('vm:entry-point') Notification is required so that the Plugin can find it
@pragma('vm:entry-point')
Future<void> interactiveCallback(Uri? uri) async {
  // Set AppGroup Id. This is needed for iOS Apps to talk to their WidgetExtensions
  await HomeWidget.setAppGroupId('group.es.antonborri.homeWidgetCounter');
  WeatherFactory wf = new WeatherFactory("b90fa66ffac0aaa5c738c8ac61f8ae04");
  Weather w = await wf.currentWeatherByCityName("Minneapolis");
  int degree = w.temperature!.celsius as int;
  int degree2 = w.temperature!.fahrenheit as int;
  log('$degree2');
  HomeWidget.saveWidgetData(
    'weather_degree',
    degree, //'${degree}°C',
  );
  HomeWidget.saveWidgetData(
    'x',
    degree2,
  );
  await HomeWidget.updateWidget(
    iOSName: 'CounterWidget',
    androidName: 'CounterWidgetProvider',
  );
}

const _countKey = 'counter';

const _fKey = 'tempF';
const _cKey = 'tempC';

/// Gets the currently stored Value
Future<int> get _value async {
  WeatherFactory wf = new WeatherFactory("b90fa66ffac0aaa5c738c8ac61f8ae04");
  Weather w = await wf.currentWeatherByCityName("Minneapolis");
  double celsius = w.temperature!.fahrenheit as double;
  int j = celsius.toInt();
  HomeWidget.saveWidgetData('counter', j);
  final value = HomeWidget.getWidgetData<int>(_countKey, defaultValue: 0);
  return _value!;
}

//get fahrenheit
Future<int> get _valueF async {
  WeatherFactory wf = new WeatherFactory("b90fa66ffac0aaa5c738c8ac61f8ae04");
  Weather w = await wf.currentWeatherByCityName("Minneapolis");
  double fahrenheit = w.temperature!.fahrenheit as double;
  int valueF = fahrenheit.toInt();
  return valueF;
}

//get celcius
Future<int> get _valueC async {
  WeatherFactory wf = new WeatherFactory("b90fa66ffac0aaa5c738c8ac61f8ae04");
  Weather w = await wf.currentWeatherByCityName("Minneapolis");
  double f = w.temperature!.celsius as double;
  int valueC = f.toInt();
  return valueC;
}

/// Retrieves the current stored value
/// Increments it by one
/// Saves that new value
/// @returns the new saved value
Future<int> _increment() async {
  final oldValue = await _value;
  final newValue = oldValue + 1;
  await _sendAndUpdate(newValue);
  return newValue;
}

/// Stores [value] in the Widget Configuration
Future<void> _sendAndUpdate([int? value]) async {
  await HomeWidget.saveWidgetData<int>(_countKey, 44);
  await HomeWidget.saveWidgetData('tempF', _valueC);
  await HomeWidget.saveWidgetData('tempC', _valueF);
  // await HomeWidget.renderFlutterWidget(
  //   DashWithSign(count: value ?? 0),
  //   key: 'dash_counter',
  //   logicalSize: const Size(100, 100),
  // );

  await HomeWidget.updateWidget(
    iOSName: 'CounterWidget',
    androidName: 'CounterWidgetProvider',
  );
}

/// Clears the saved Counter Value
Future<void> _clear() async {
  await _sendAndUpdate();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark(
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Duo Unit Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _incrementCounter() async {
    await _increment();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Minneapolis Weather:',
            ),
            FutureBuilder<int>(
              future: _value,
              builder: (_, snapshot) => Column(
                children: [
                  Text(
                    (snapshot.data ?? 0).toString() + ' count',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            FutureBuilder<int>(
              future: _valueC,
              builder: (_, snapshot) => Column(
                children: [
                  Text(
                    (snapshot.data ?? 0).toString() + ' C',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            FutureBuilder<int>(
              future: _valueF,
              builder: (_, snapshot) => Column(
                children: [
                  Text(
                    (snapshot.data ?? 0).toString() + ' F',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            // TextButton(
            //   onPressed: () async {
            //     await _clear();
            //     setState(() {});
            //   },
            //   child: const Text('Refresh'),
            // ),
          ],
        ),
      ),
    );
  }
}
