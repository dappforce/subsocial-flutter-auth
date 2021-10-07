import 'package:example/home_page.dart';
import 'package:example/locator.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:subsocial_flutter_auth/subsocial_flutter_auth.dart';

void main() {
  setUpLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subsocial Auth Example',
      theme: FlexColorScheme.light(scheme: FlexScheme.mandyRed).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.mandyRed).toTheme,
      themeMode: ThemeMode.system,
      home: const SplashPage(),
    );
  }
}

class SplashPage extends HookWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _waitForLocatorSetupAndNavigate(context);
    }, []);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _waitForLocatorSetupAndNavigate(BuildContext context) async {
    await sl.allReady();
    await sl.get<SubsocialAuth>().update();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const HomePage();
    }));
  }
}
