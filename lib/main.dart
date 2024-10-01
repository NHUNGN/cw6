import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AgeCounter(),  // Providing AgeCounter model
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Age Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

/// AgeCounter model with ChangeNotifier
class AgeCounter with ChangeNotifier {
  int age = 7;  // Initial age value

  void increaseAge() {
    age++;
    notifyListeners();
  }

  void decreaseAge() {
    if (age > 0) {
      age--;
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AgeCounterPage(),
    );
  }
}

class AgeCounterPage extends StatelessWidget {
  const AgeCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the current age
            Consumer<AgeCounter>(
              builder: (context, ageCounter, child) {
                return Text(
                  'I am ${ageCounter.age} years old',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Increase Age Button
            ElevatedButton(
              onPressed: () {
                context.read<AgeCounter>().increaseAge();
              },
              child: const Text('Increase Age'),
            ),
            const SizedBox(height: 10),
            // Reduce age switch with label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Reduce age'),
                Switch(
                  value: context.watch<AgeCounter>().age > 0,
                  onChanged: (value) {
                    if (value) {
                      context.read<AgeCounter>().decreaseAge();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
