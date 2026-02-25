import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../feed screen/feed_screen.dart';
import '../feed screen/feed_screenby_id.dart';
import '../main.dart';
import '../pages/book.dart';
import '../pages/book_detail_page.dart';

class DeepLinkListener extends StatefulWidget {
  const DeepLinkListener({super.key, required this.child});
  final Widget child;

  @override
  State<DeepLinkListener> createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends State<DeepLinkListener> {
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _handleInitialLink();   // ✅ terminated
    _listenToLinks();       // ✅ running
  }

  /// App was killed
  Future<void> _handleInitialLink() async {
    final Uri? uri = await _appLinks.getInitialLink();
    if (uri != null) {
      _handleUri(uri);
    }
  }

  /// App is running / background
  void _listenToLinks() {
    _appLinks.uriLinkStream.listen((Uri uri) {
      _handleUri(uri);
    });
  }

  void _handleUri(Uri uri) {
    debugPrint('Deep link received: $uri');

    if (uri.pathSegments.isEmpty) {
      debugPrint('No path segments found');
      return;
    }

    final postId = uri.pathSegments[1];
    // final postId = uri.pathSegments.first;

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => FeedByIdScreen( cardId: postId,),
      ),
    );
  }

  // void _handleUri(Uri uri) {
  //   debugPrint('Deep link received: $uri');
  //
  //   if (uri.pathSegments.length >= 2 && uri.pathSegments.first == 'feed') {
  //     final postId = uri.pathSegments[1];
  //
  //     navigatorKey.currentState?.pushReplacement(
  //       MaterialPageRoute(
  //         builder: (_) => FeedByIdScreen(postId: postId),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}


// class DeepLinkListener extends StatefulWidget {
//   const DeepLinkListener({super.key, required this.child});
//   final Widget child;
//
//   @override
//   State<DeepLinkListener> createState() => _DeepLinkListenerState();
// }
//
// class _DeepLinkListenerState extends State<DeepLinkListener> {
//   late final AppLinks _appLinks;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _appLinks = AppLinks();
//
//     _appLinks.uriLinkStream.listen((uri) {
//       if (uri.pathSegments.isEmpty) return;
//
//       final first = uri.pathSegments.first;
//
//       // example: /feed/{id}
//       if (first == 'feed' && uri.pathSegments.length > 1) {
//         final postId = uri.pathSegments[1];
//
//         navigatorKey.currentState?.pushReplacement(
//           MaterialPageRoute(
//             builder: (_) => FeedByIdScreen(postId: postId),
//           ),
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }

//
// class DeepLinkListener extends StatefulWidget {
//   const DeepLinkListener({super.key, required this.child});
//   final Widget child;
//
//   @override
//   State<DeepLinkListener> createState() => _DeepLinkListenerState();
// }
//
// class _DeepLinkListenerState extends State<DeepLinkListener> {
//   @override
//   void initState() {
//     // TODO: implement initState
//
//     final appLinks = AppLinks(); // AppLinks is singleton
//
// // Subscribe to all events (initial link and further)
//     final sub = appLinks.uriLinkStream.listen((uri) {
//       log('URI: ${uri.pathSegments.first}');
//       if (uri.pathSegments.last == 'feed' && mounted) {
//         Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) =>  FeedByIdScreen( postId: uri.pathSegments.last,)));
//         final id = uri.pathSegments.lastOrNull;
//         if (id != null && int.tryParse(id) != null) {
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => BookDetailPage()));
//               // builder: (context) => BookDetailPage(bookId: id)));
//         }
//       }
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }

// import 'dart:developer';
//
// import 'package:app_links/app_links.dart';
// import 'package:flutter/material.dart';
//
// import '../pages/book.dart';
// import '../pages/book_detail_page.dart';
//
// class DeepLinkListener extends StatefulWidget {
//   const DeepLinkListener({super.key, required this.child});
//   final Widget child;
//
//   @override
//   State<DeepLinkListener> createState() => _DeepLinkListenerState();
// }
//
// class _DeepLinkListenerState extends State<DeepLinkListener> {
//   @override
//   void initState() {
//     // TODO: implement initState
//
//     final appLinks = AppLinks(); // AppLinks is singleton
//
// // Subscribe to all events (initial link and further)
//     final sub = appLinks.uriLinkStream.listen((uri) {
//       log('URI: ${uri.pathSegments.first}');
//       if (uri.pathSegments.first == 'book' && mounted) {
//         Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => const BookListPage()));
//         final id = uri.pathSegments.lastOrNull;
//         if (id != null && int.tryParse(id) != null) {
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => BookDetailPage()));
//           // builder: (context) => BookDetailPage(bookId: id)));
//         }
//       }
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }