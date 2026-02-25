import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:srishnaapp/feed%20screen/feed_screenby_id.dart';
import 'package:srishnaapp/pages/book.dart';
import 'package:srishnaapp/pages/book_detail_page.dart';
import 'package:srishnaapp/splash%20screen/splash_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:http/http.dart' as http;
import 'package:srishnaapp/splash%20screen/splash_screen.dart';

import 'package:flutter/material.dart';

import 'deep_linking_listener/deeplinking_listener.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       routes: {
//         '/book': (context) => const BookListPage(),
//         '/bookDetails': (context) => const BookDetailPage(
//           // bookId: 'undefined',
//         )
//       },
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const DeepLinkListener(
//           child: MyHomePage(title: 'Flutter Demo Home Page')),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,

      routes: {
        '/book': (context) => const BookListPage(),
        '/bookDetails': (context) => const BookDetailPage(
          // bookId: 'undefined',
        )
      },
      title: 'News Feed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      // home: const SplashScreen(),

            home: const DeepLinkListener(
          // child: FeedByIdScreen(postId: '4ad99a8c-ea27-4bfc-aff6-3228f829d9fb')),
          child: SplashScreen()),

    );
  }
}

//
// <manifest xmlns:android="http://schemas.android.com/apk/res/android">
// <application
// android:label="Srishna Telugu"
// android:name="${applicationName}"
// android:icon="@mipmap/ic_launcher">
// android:usesCleartextTraffic="true"
//
// <activity
// android:name=".MainActivity"
// android:exported="true"
// android:launchMode="singleTop"
// android:taskAffinity=""
// android:theme="@style/LaunchTheme"
// android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
// android:hardwareAccelerated="true"
// android:windowSoftInputMode="adjustResize">
// <!-- Specifies an Android theme to apply to this Activity as soon as
// the Android process has started. This theme is visible to the user
// while the Flutter UI initializes. After that, this theme continues
// to determine the Window background behind the Flutter UI. -->
// <meta-data
// android:name="io.flutter.embedding.android.NormalTheme"
// android:resource="@style/NormalTheme"
// />
//
//
//
//
//
// <!-- App Link sample -->
// <intent-filter android:autoVerify="true">
// <action android:name="android.intent.action.VIEW" />
// <category android:name="android.intent.category.DEFAULT" />
// <category android:name="android.intent.category.BROWSABLE" />
// <data android:scheme="https" android:host="www.news.srishnatelugu.com" />
// <!--                <data android:scheme="https" android:host="www.``````````````````````flutter-deep-link.com" />-->
// </intent-filter>
//
// <!-- Deep Link sample -->
// <intent-filter>
// <action android:name="android.intent.action.VIEW" />
// <category android:name="android.intent.category.DEFAULT" />
// <category android:name="android.intent.category.BROWSABLE" />
// <!-- Add optional android:host to distinguish your app
// from others in case of conflicting scheme name -->
// <data android:scheme="flutterDeepLink" android:host="srishnatelugu" />
// <!-- <data android:scheme="sample" /> -->
// </intent-filter>
//
//
//
//
//
// <intent-filter>
// <action android:name="android.intent.action.MAIN"/>
// <category android:name="android.intent.category.LAUNCHER"/>
// </intent-filter>
// </activity>
// <!-- Don't delete the meta-data below.
// This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
// <meta-data
// android:name="flutterEmbedding"
// android:value="2" />
// </application>
// <!-- Required to query activities that can process text, see:
// https://developer.android.com/training/package-visibility and
// https://developer.android.com/reference/android/content/Intent#ACTION_PROCESS_TEXT.
//
// In particular, this is used by the Flutter engine in io.flutter.plugin.text.ProcessTextPlugin. -->
// <queries>
// <intent>
// <action android:name="android.intent.action.PROCESS_TEXT"/>
// <data android:mimeType="text/plain"/>
// </intent>
// </queries>
// </manifest>
