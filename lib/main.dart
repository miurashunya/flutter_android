import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  static const platform = MethodChannel('com.example.flutter_android/bridge');

  int _count = 0;

  void _incrementCounter() => setState(() => _count++);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _restoreCount();
  }

  Future<void> _restoreCount() async {
    try {
      final count = await platform.invokeMethod<int>('getCount');
      if (count != null && mounted) {
        setState(() {
          _count = count;
        });
      }
    } catch (e) {
      debugPrint("カウントの初期復元に失敗しました: $e");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint("アプリのライフサイクルが変化しました: $state");
    if (state == AppLifecycleState.resumed) {
      try {
        final count = await platform.invokeMethod<int>('getCount');
        if (count != null) {
          setState(() {
            _count = count;
          });
        }
      } catch (e) {
        debugPrint("カウントの復元に失敗しました: $e");
      }
    }
  }

  Future<void> _openNativeScreen() async {
    try {
      // _countをKotlin側に送信して保存
      await platform.invokeMethod('saveCount', {'count': _count});
      await platform.invokeMethod('openNativeScreen');
    } catch (e) {
      // エラー処理
      debugPrint("ネイティブ画面の呼び出しに失敗しました: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter画面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _openNativeScreen,
              child: const Text('Kotlin画面を開く'),
            ),
            SizedBox(height: 16),
            Text('カウンター: $_count'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
