import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import '../api_services/services.dart';
import '../model.dart';

class ShareBottomSheet extends StatelessWidget {
  final int id;
  final String imageUrl;
  final String headline;
  final String description;

  ShareBottomSheet({
    required this.id,
    required this.imageUrl,
    required this.headline,
    required this.description,
  });


  String _generateDeepLink() {
    return 'https://srishna.com/post/${id}';
  }

  // Generate share text
  String _generateShareText() {
    return '${imageUrl}\n${headline}\n${description}\n\n📱 Open in app: ${_generateDeepLink()}';
  }

  Future<void> _handleShare(BuildContext context, String platform) async {
    final deepLink = _generateDeepLink();
    final shareText = _generateShareText();
    Navigator.pop(context);

    if (platform == 'Copy') {
      // Copy link to clipboard
      await Clipboard.setData(ClipboardData(text: deepLink));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Link copied!\n$deepLink'),
            duration: const Duration(seconds: 3),
            backgroundColor: const Color(0xFF34C759),
          ),
        );
      }
    } else if (platform == 'WhatsApp') {
      await _openWhatsApp(shareText);
    } else if (platform == 'Instagram') {
      await _openInstagram(shareText);
    } else if (platform == 'Telegram') {
      await _openTelegram(shareText);
    } else if (platform == 'Twitter') {
      await _openTwitter(shareText);
    } else if (platform == 'Facebook') {
      await _openFacebook(shareText);
    } else if (platform == 'SMS') {
      await _openSMS(shareText);
    } else if (platform == 'Email') {
      await _openEmail(shareText);
    } else {
      // More options - use native share
      await _openNativeShare(shareText);
    }
  }

  Future<void> _openWhatsApp(String text) async {
    final encodedText = Uri.encodeComponent(text);
    final url = Uri.parse('whatsapp://send?text=$encodedText');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await Clipboard.setData(ClipboardData(text: text));
      }
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }

  Future<void> _openInstagram(String text) async {
    try {
      await Share.share(text);
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }

  Future<void> _openTelegram(String text) async {
    final encodedText = Uri.encodeComponent(text);
    final url = Uri.parse('tg://msg?text=$encodedText');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await Clipboard.setData(ClipboardData(text: text));
      }
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }

  Future<void> _openTwitter(String text) async {
    final encodedText = Uri.encodeComponent(text);
    final url = Uri.parse('twitter://post?message=$encodedText');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to web
        final webUrl = Uri.parse(
          'https://twitter.com/intent/tweet?text=$encodedText',
        );
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }

  Future<void> _openFacebook(String text) async {
    try {
      await Share.share(text);
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }

  Future<void> _openSMS(String text) async {
    final encodedText = Uri.encodeComponent(text);
    final url = Uri.parse('sms:?body=$encodedText');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await Clipboard.setData(ClipboardData(text: text));
      }
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }

  Future<void> _openEmail(String text) async {
    final encodedSubject = Uri.encodeComponent(headline);
    final encodedBody = Uri.encodeComponent(text);
    final url = Uri.parse('mailto:?subject=$encodedSubject&body=$encodedBody');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await Clipboard.setData(ClipboardData(text: text));
      }
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }

  Future<void> _openNativeShare(String text) async {
    try {
      await Share.share(text);
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Share to',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Share Options Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildShareOption(
                      context,
                      'WhatsApp',
                      Icons.chat,
                      const Color(0xFF25D366),
                    ),
                    _buildShareOption(
                      context,
                      'Instagram',
                      Icons.camera_alt,
                      const Color(0xFFE4405F),
                    ),
                    _buildShareOption(
                      context,
                      'Telegram',
                      Icons.send,
                      const Color(0xFF0088CC),
                    ),
                    _buildShareOption(
                      context,
                      'Twitter',
                      Icons.message,
                      const Color(0xFF1DA1F2),
                    ),
                    _buildShareOption(
                      context,
                      'Facebook',
                      Icons.facebook,
                      const Color(0xFF1877F2),
                    ),
                    _buildShareOption(
                      context,
                      'SMS',
                      Icons.sms,
                      const Color(0xFF34C759),
                    ),
                    _buildShareOption(
                      context,
                      'Email',
                      Icons.email,
                      const Color(0xFFFF9500),
                    ),
                    _buildShareOption(
                      context,
                      'Copy',
                      Icons.copy,
                      const Color(0xFF8E8E93),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // More Options Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  onTap: () => _handleShare(context, 'More'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'More Options',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareOption(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth < 350 ? 50.0 : 60.0;
    final iconInnerSize = screenWidth < 350 ? 24.0 : 28.0;

    return InkWell(
      onTap: () => _handleShare(context, title),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.white, size: iconInnerSize),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 11),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// News Card Model
class NewsCard {
  final int id;
  final String imageUrl;
  final String headline;
  final String description;

  NewsCard({
    required this.id,
    required this.imageUrl,
    required this.headline,
    required this.description,
  });
}

class FeedScreen extends StatefulWidget {
  final String id;
  const FeedScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late PageController _pageController;
  final List<CardsModel> _posts = [];
  final Set<int> _expandedPosts = {};

  bool _isLoading = false;
  bool _hasMore = true;
  String? _nextCursor;

  bool _isExpanded(CardsModel post) => _expandedPosts.contains(post.id);

  void _toggleExpanded(CardsModel post) {
    setState(() {
      _expandedPosts.contains(post.id)
          ? _expandedPosts.remove(post.id)
          : _expandedPosts.add(post.id!);
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    if (widget.id.isNotEmpty) {
      _fetchPostById(widget.id);
    } else {
      _fetchInitialData();
    }

    _pageController.addListener(() {
      final page = _pageController.page ?? 0;
      if (page >= _posts.length - 2 && !_isLoading && _hasMore) {
        _fetchMoreData();
      }
    });
  }

  Future<void> _fetchPostById(String id) async {
    setState(() => _isLoading = true);
    try {
      final post = await CardsApiService.fetchCardById(id);
      setState(() {
        _posts
          ..clear()
          ..add(post);
        _hasMore = false;
      });
    } catch (e) {
      debugPrint('Fetch by ID error: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    try {
      final posts = await CardsApiService.fetchCards(limit: 10);
      setState(() {
        _posts.addAll(posts);
        _hasMore = false; // No cursor-based pagination
      });
    } catch (e) {
      debugPrint('Feed load error: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _fetchMoreData() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);
    try {
      final posts = await CardsApiService.fetchCards(limit: 10);
      setState(() {
        _posts.addAll(posts);
        _hasMore = false;
      });
    } catch (e) {
      debugPrint('Pagination error: $e');
    }
    setState(() => _isLoading = false);
  }

  /// --- SHARE FUNCTIONALITY ---
  String _generateDeepLink(String id) {
    // Public URL of your post for OG previews
    return 'https://srishna-image-upload-712085419978.asia-south1.run.app/post/$id/view';
    // return 'https://srishna.com/post/$id/view';``
  }

  String _generateShareText({
    required String headline,
    required String description,
    required String id,
    required String imageUrl,
  }) {
    // Format: image + headline + description + deep link
    return '$headline\n$description\n\n📱 Open in app: ${_generateDeepLink(id)}';
  }

  Future<void> _handleShare({
    required String headline,
    required String description,
    required String id,
    required String imageUrl,
  }) async {
    final shareText = _generateShareText(
        headline: headline, description: description, id: id, imageUrl: imageUrl);

    try {
      await Share.share(shareText);
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: shareText));
    }
  }

  void _preloadNextImage(int index) {
    if (index + 1 < _posts.length) {
      final nextPost = _posts[index + 1];
      if (nextPost.imageUrl != null) {
        precacheImage(
          CachedNetworkImageProvider(nextPost.imageUrl!),
          context,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _posts.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _hasMore ? _posts.length + 1 : _posts.length,
        itemBuilder: (context, index) {
          if (index >= _posts.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final post = _posts[index];

          // Preload next image
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _preloadNextImage(index);
          });

          return Stack(
            children: [
              /// FULLSCREEN IMAGE
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl ?? '',
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                  placeholder: (context, url) => Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                  const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),

              /// TOP SAFE AREA
              const SafeArea(
                bottom: false,
                child: SizedBox(),
              ),

              /// BOTTOM GRADIENT + TEXT
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black87,
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ONE LINE TEXT + SEE MORE
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              post.textContent ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showFullTextDialog(post),
                            child: const Text(
                              'See more',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// SHARE BUTTON
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            _handleShare(
                              headline: post.uploaderName ?? 'News',
                              description: post.textContent ?? '',
                              id: post.id.toString(),
                              imageUrl: post.imageUrl ?? '',
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.share,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text('Share',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFullTextDialog(CardsModel post) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                /// TEXT CONTENT
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 30),
                  child: SingleChildScrollView(
                    child: Text(
                      post.textContent ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                /// CLOSE BUTTON
                Positioned(
                  right: 0,
                  top: 0,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class FeedScreen extends StatefulWidget {
//   final String id;
//   const FeedScreen({Key? key, required this.id}) : super(key: key);
//
//   @override
//   State<FeedScreen> createState() => _FeedScreenState();
// }
//
// class _FeedScreenState extends State<FeedScreen> {
//   late PageController _pageController;
//   final List<CardsModel> _posts = [];
//   final Set<int> _expandedPosts = {};
//
//   bool _isLoading = false;
//   bool _hasMore = true;
//   String? _nextCursor;
//
//   bool _isExpanded(CardsModel post) => _expandedPosts.contains(post.id);
//
//   void _toggleExpanded(CardsModel post) {
//     setState(() {
//       _expandedPosts.contains(post.id)
//           ? _expandedPosts.remove(post.id)
//           : _expandedPosts.add(post.id!);
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//
//     if (widget.id.isNotEmpty) {
//       _fetchPostById(widget.id);
//     } else {
//       _fetchInitialData();
//     }
//
//     _pageController.addListener(() {
//       final page = _pageController.page ?? 0;
//       if (page >= _posts.length - 2 && !_isLoading && _hasMore) {
//         _fetchMoreData();
//       }
//     });
//   }
//
//   Future<void> _fetchPostById(String id) async {
//     setState(() => _isLoading = true);
//     try {
//       final post = await CardsApiService.fetchCardById(id);
//       setState(() {
//         _posts
//           ..clear()
//           ..add(post);
//         _hasMore = false;
//       });
//     } catch (e) {
//       debugPrint('Fetch by ID error: $e');
//     }
//     setState(() => _isLoading = false);
//   }
//
//   Future<void> _fetchInitialData() async {
//     setState(() => _isLoading = true);
//     try {
//       final posts = await CardsApiService.fetchCards(limit: 10);
//       setState(() {
//         _posts.addAll(posts);
//         _hasMore =
//         false; // Your API has no nextCursor, so just disable pagination
//       });
//     } catch (e) {
//       debugPrint('Feed load error: $e');
//     }
//     setState(() => _isLoading = false);
//   }
//
//   Future<void> _fetchMoreData() async {
//     if (_isLoading || !_hasMore) return;
//
//     setState(() => _isLoading = true);
//     try {
//       final posts = await CardsApiService.fetchCards(limit: 10);
//       setState(() {
//         _posts.addAll(posts);
//         _hasMore = false; // No cursor-based pagination
//       });
//     } catch (e) {
//       debugPrint('Pagination error: $e');
//     }
//     setState(() => _isLoading = false);
//   }
//
//
//   void _showShareSheet(Posts post) {
//     final newsCard = NewsCard(
//       id: post.id,
//       imageUrl: post.mediaUrl ?? '',
//       headline: post.title ?? '',
//       description: post.caption ?? '',
//     );
//
//   }
//   String _generateDeepLink(String id) {
//     // Using a simple subdomain format that you can host anywhere
//     // For testing, this will just trigger the app to open
//     // return 'https://srishna.com/post/${id}';
//     return 'https://srishna.com/post/$id/view';
//
//   }
//
//   String _generateShareText({dynamic headline, dynamic description, dynamic id,dynamic imageUrl}) {
//     return '${imageUrl}\n${headline}\n${description}\n📱 Open in app: ${_generateDeepLink(id)}';
//   }
//
//   // return '${imageUrl}\n${headline}\n${description}\n\n📱 Open in app: ${_generateDeepLink()}';
//
//   Future<void> _handleShare(BuildContext context,{dynamic headline, dynamic description, dynamic id,dynamic imageUrl}) async {
//     final shareText = _generateShareText(description: description,headline: headline,id: id,imageUrl: imageUrl);
//
//     // Navigator.pop(context);
//     await _openNativeShare(shareText);
//   }
//
//   Future<void> _openNativeShare(String text) async {
//     try {
//       await Share.share(text);
//     } catch (e) {
//       await Clipboard.setData(ClipboardData(text: text));
//     }
//   }
//   void _preloadNextImage(int index) {
//     if (index + 1 < _posts.length) {
//       final nextPost = _posts[index + 1];
//       if (nextPost.imageUrl != null) {
//         precacheImage(
//           CachedNetworkImageProvider(nextPost.imageUrl!),
//           context,
//         );
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: _posts.isEmpty && _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : PageView.builder(
//         controller: _pageController,
//         scrollDirection: Axis.vertical,
//         itemCount: _hasMore ? _posts.length + 1 : _posts.length,
//         itemBuilder: (context, index) {
//           if (index >= _posts.length) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final post = _posts[index];
//
//           // Preload next image
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _preloadNextImage(index);
//           });
//
//           return Stack(
//             children: [
//               /// FULLSCREEN IMAGE
//               Positioned.fill(
//                 child: CachedNetworkImage(
//                   imageUrl: post.imageUrl ?? '',
//                   fit: BoxFit.cover,
//                   fadeInDuration: const Duration(milliseconds: 300),
//                   placeholder: (context, url) => Container(
//                     color: Colors.black,
//                     child: const Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),
//                   errorWidget: (context, url, error) =>
//                   const Center(
//                     child: Icon(
//                       Icons.broken_image,
//                       color: Colors.white,
//                       size: 40,
//                     ),
//                   ),
//                 ),
//               ),
//
//               /// TOP SAFE AREA
//               const SafeArea(
//                 bottom: false,
//                 child: SizedBox(),
//               ),
//
//               /// BOTTOM GRADIENT + TEXT
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                       colors: [
//                         Colors.black87,
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       /// ONE LINE TEXT + SEE MORE
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               post.textContent ?? '',
//                               maxLines: 1,
//                               overflow:
//                               TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           GestureDetector(
//                             onTap: () =>
//                                 _showFullTextDialog(post),
//                             child: const Text(
//                               'See more',
//                               style: TextStyle(
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 12),
//
//                       /// SHARE BUTTON
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: InkWell(
//                           onTap: () {
//                             _handleShare(
//                               context,
//                               headline:
//                               post.uploaderName,
//                               description:
//                               post.textContent,
//                               id: post.id.toString(),
//                               imageUrl:
//                               post.imageUrl,
//                             );
//                           },
//                           child: Container(
//                             padding:
//                             const EdgeInsets.symmetric(
//                                 horizontal: 24,
//                                 vertical: 12),
//                             decoration: BoxDecoration(
//                               color: Colors.white
//                                   .withOpacity(0.2),
//                               borderRadius:
//                               BorderRadius.circular(
//                                   30),
//                             ),
//                             child: const Row(
//                               mainAxisSize:
//                               MainAxisSize.min,
//                               children: [
//                                 Icon(Icons.share,
//                                     color: Colors.white,
//                                     size: 20),
//                                 SizedBox(width: 8),
//                                 Text('Share',
//                                     style: TextStyle(
//                                         color: Colors
//                                             .white)),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//
//   }
//   void _showFullTextDialog(CardsModel post) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: const Color(0xFF1C1C1E),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           insetPadding:
//           const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Stack(
//               children: [
//                 /// TEXT CONTENT
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10, right: 30),
//                   child: SingleChildScrollView(
//                     child: Text(
//                       post.textContent ?? '',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         height: 1.5,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// CLOSE BUTTON
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   child: InkWell(
//                     onTap: () => Navigator.pop(context),
//                     child: const Icon(
//                       Icons.close,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
// // @override
// // Widget build(BuildContext context) {
// //   return Scaffold(
// //     backgroundColor: Colors.black,
// //     body: _posts.isEmpty && _isLoading
// //         ? const Center(child: CircularProgressIndicator())
// //         : PageView.builder(
// //       controller: _pageController,
// //       scrollDirection: Axis.vertical,
// //       itemCount: _hasMore ? _posts.length + 1 : _posts.length,
// //       itemBuilder: (context, index) {
// //         if (index >= _posts.length) {
// //           return const Center(child: CircularProgressIndicator());
// //         }
// //         final post = _posts[index];
// //         final isExpanded = _isExpanded(post);
// //         // Preload next image
// //         WidgetsBinding.instance.addPostFrameCallback((_) {
// //           _preloadNextImage(index);
// //         });
// //         return Column(
// //           children: [
// //             /// TOP BAR
// //             const SafeArea(
// //               bottom: false,
// //               child: SizedBox(),
// //             ),
// //
// //             /// IMAGE AREA (fixed height)
// //             SizedBox(
// //               height: MediaQuery.of(context).size.height * 0.65,
// //               width: double.infinity,
// //               child: Container(
// //                 color: Colors.black,
// //                 child: CachedNetworkImage(
// //                   imageUrl: post.imageUrl ?? '',
// //                   fit: BoxFit.fill,
// //                   fadeInDuration: const Duration(milliseconds: 300),
// //                   placeholder: (context, url) => Container(
// //                     color: Colors.black,
// //                     child: const Center(
// //                       child: Icon(
// //                         Icons.image,
// //                         color: Colors.white24,
// //                         size: 60,
// //                       ),
// //                     ),
// //                   ),
// //                   errorWidget: (context, url, error) => const Center(
// //                     child: Icon(
// //                       Icons.broken_image,
// //                       color: Colors.white,
// //                       size: 40,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //
// //             /// TEXT + SHARE AREA (expands freely)
// //             Expanded(
// //               child: Container(
// //                 width: double.infinity,
// //                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// //                 color: Colors.black,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     /// SCROLLABLE TEXT AREA
// //                     Expanded(
// //                       child: SingleChildScrollView(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               post.textContent ?? '',
// //                               maxLines: isExpanded ? null : 3,
// //                               overflow: isExpanded
// //                                   ? TextOverflow.visible
// //                                   : TextOverflow.ellipsis,
// //                               style: TextStyle(
// //                                 color: Colors.white.withOpacity(0.9),
// //                                 fontSize:
// //                                 MediaQuery.of(context).size.width * 0.04,
// //                                 height: 1.4,
// //                               ),
// //                             ),
// //
// //                             if ((post.textContent ?? '').length > 120)
// //                               GestureDetector(
// //                                 onTap: () => _toggleExpanded(post),
// //                                 child: Padding(
// //                                   padding: const EdgeInsets.only(top: 6),
// //                                   child: Text(
// //                                     isExpanded ? 'See less' : 'See more',
// //                                     style: const TextStyle(
// //                                       color: Colors.blueAccent,
// //                                       fontWeight: FontWeight.w600,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //
// //                     const SizedBox(height: 16),
// //
// //                     /// SHARE BUTTON (fixed at bottom)
// //                     Align(
// //                       alignment: Alignment.centerRight,
// //                       child: InkWell(
// //                         onTap: () {
// //                           _handleShare(
// //                             context,
// //                             headline: post.uploaderName,
// //                             description: post.textContent,
// //                             id: post.id.toString(),
// //                             imageUrl: post.imageUrl,
// //                           );
// //                         },
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 24, vertical: 12),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(0.2),
// //                             borderRadius: BorderRadius.circular(30),
// //                           ),
// //                           child: const Row(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               Icon(Icons.share,
// //                                   color: Colors.white, size: 20),
// //                               SizedBox(width: 8),
// //                               Text('Share',
// //                                   style: TextStyle(color: Colors.white)),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //
// //             // Expanded(
// //             //   child: Container(
// //             //     width: double.infinity,
// //             //     padding:
// //             //     const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// //             //     color: Colors.black,
// //             //     child: Column(
// //             //       crossAxisAlignment: CrossAxisAlignment.start,
// //             //       children: [
// //             //         Text(
// //             //           post.textContent ?? '',
// //             //           maxLines: isExpanded ? null : 3,
// //             //           overflow: isExpanded
// //             //               ? TextOverflow.visible
// //             //               : TextOverflow.ellipsis,
// //             //           style: TextStyle(
// //             //             color: Colors.white.withOpacity(0.9),
// //             //             fontSize:
// //             //             MediaQuery.of(context).size.width * 0.04,
// //             //             height: 1.4,
// //             //           ),
// //             //         ),
// //             //
// //             //         if ((post.textContent ?? '').length > 120)
// //             //           GestureDetector(
// //             //             onTap: () => _toggleExpanded(post),
// //             //             child: Padding(
// //             //               padding: const EdgeInsets.only(top: 6),
// //             //               child: Text(
// //             //                 isExpanded ? 'See less' : 'See more',
// //             //                 style: const TextStyle(
// //             //                   color: Colors.blueAccent,
// //             //                   fontWeight: FontWeight.w600,
// //             //                 ),
// //             //               ),
// //             //             ),
// //             //           ),
// //             //
// //             //         const Spacer(),
// //             //
// //             //         Align(
// //             //           alignment: Alignment.centerRight,
// //             //           child: InkWell(
// //             //             onTap: () {
// //             //               _handleShare(
// //             //                 context,
// //             //                 headline: post.uploaderName,
// //             //                 description: post.textContent,
// //             //                 id: post.id.toString(),
// //             //                 imageUrl: post.imageUrl,
// //             //               );
// //             //             },
// //             //             child: Container(
// //             //               padding: const EdgeInsets.symmetric(
// //             //                   horizontal: 24, vertical: 12),
// //             //               decoration: BoxDecoration(
// //             //                 color: Colors.white.withOpacity(0.2),
// //             //                 borderRadius: BorderRadius.circular(30),
// //             //               ),
// //             //               child: const Row(
// //             //                 mainAxisSize: MainAxisSize.min,
// //             //                 children: [
// //             //                   Icon(Icons.share,
// //             //                       color: Colors.white, size: 20),
// //             //                   SizedBox(width: 8),
// //             //                   Text('Share',
// //             //                       style: TextStyle(color: Colors.white)),
// //             //                 ],
// //             //               ),
// //             //             ),
// //             //           ),
// //             //         ),
// //             //       ],
// //             //     ),
// //             //   ),
// //             // ),
// //
// //           ],
// //         );
// //
// //         // return Column(
// //         //   children: [
// //         //     /// TOP BAR
// //         //     SafeArea(
// //         //       bottom: false,
// //         //       child: SizedBox(),
// //         //       // child: Padding(
// //         //       //   padding: const EdgeInsets.symmetric(
// //         //       //       horizontal: 16, vertical: 8),
// //         //       //   child: Row(
// //         //       //     mainAxisAlignment: MainAxisAlignment.end,
// //         //       //     children: [
// //         //       //       GestureDetector(
// //         //       //         onTap: () {
// //         //       //           Navigator.push(
// //         //       //             context,
// //         //       //             MaterialPageRoute(
// //         //       //               builder: (context) =>
// //         //       //               const UploadPostScreen(),
// //         //       //             ),
// //         //       //           );
// //         //       //         },
// //         //       //         child: const Icon(
// //         //       //           Icons.add,
// //         //       //           color: Colors.white,
// //         //       //           size: 28,
// //         //       //         ),
// //         //       //       ),
// //         //       //     ],
// //         //       //   ),
// //         //       // ),
// //         //     ),
// //         //
// //         //     /// IMAGE AREA
// //         //     Expanded(
// //         //       child: Container(
// //         //         width: double.infinity,
// //         //         color: Colors.black,
// //         //         child: CachedNetworkImage(
// //         //           imageUrl: post.imageUrl ?? '',
// //         //           fit: BoxFit.fill,
// //         //           fadeInDuration: const Duration(milliseconds: 300),
// //         //           placeholder: (context, url) => Container(
// //         //             color: Colors.black,
// //         //             child: const Center(
// //         //               child: Icon(
// //         //                 Icons.image,
// //         //                 color: Colors.white24,
// //         //                 size: 60,
// //         //               ),
// //         //             ),
// //         //           ),
// //         //           errorWidget: (context, url, error) => const Center(
// //         //             child: Icon(
// //         //               Icons.broken_image,
// //         //               color: Colors.white,
// //         //               size: 40,
// //         //             ),
// //         //           ),
// //         //         ),
// //         //       ),
// //         //     ),
// //         //
// //         //
// //         //
// //         //
// //         //     /// TEXT + SHARE AREA
// //         //     Container(
// //         //       width: double.infinity,
// //         //       padding:
// //         //       const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// //         //       color: Colors.black,
// //         //       child: Column(
// //         //         crossAxisAlignment: CrossAxisAlignment.start,
// //         //         children: [
// //         //           Text(
// //         //             post.textContent ?? '',
// //         //             maxLines: isExpanded ? null : 3,
// //         //             overflow: isExpanded
// //         //                 ? TextOverflow.visible
// //         //                 : TextOverflow.ellipsis,
// //         //             style: TextStyle(
// //         //               color: Colors.white.withOpacity(0.9),
// //         //               fontSize:
// //         //               MediaQuery.of(context).size.width * 0.04,
// //         //               height: 1.4,
// //         //             ),
// //         //           ),
// //         //
// //         //           if ((post.textContent ?? '').length > 120)
// //         //             GestureDetector(
// //         //               onTap: () => _toggleExpanded(post),
// //         //               child: const Padding(
// //         //                 padding: EdgeInsets.only(top: 6),
// //         //                 child: Text(
// //         //                   'See more',
// //         //                   style: TextStyle(
// //         //                     color: Colors.blueAccent,
// //         //                     fontWeight: FontWeight.w600,
// //         //                   ),
// //         //                 ),
// //         //               ),
// //         //             ),
// //         //
// //         //           const SizedBox(height: 16),
// //         //
// //         //           Align(
// //         //             alignment: Alignment.centerRight,
// //         //             child: InkWell(
// //         //               onTap: () {
// //         //                 _handleShare(
// //         //                   context,
// //         //                   headline: post.uploaderName,
// //         //                   description: post.textContent,
// //         //                   id: post.id.toString(),
// //         //                   imageUrl: post.imageUrl,
// //         //                 );
// //         //               },
// //         //               child: Container(
// //         //                 padding: const EdgeInsets.symmetric(
// //         //                     horizontal: 24, vertical: 12),
// //         //                 decoration: BoxDecoration(
// //         //                   color: Colors.white.withOpacity(0.2),
// //         //                   borderRadius: BorderRadius.circular(30),
// //         //                 ),
// //         //                 child: const Row(
// //         //                   mainAxisSize: MainAxisSize.min,
// //         //                   children: [
// //         //                     Icon(Icons.share,
// //         //                         color: Colors.white, size: 20),
// //         //                     SizedBox(width: 8),
// //         //                     Text('Share',
// //         //                         style: TextStyle(color: Colors.white)),
// //         //                   ],
// //         //                 ),
// //         //               ),
// //         //             ),
// //         //           ),
// //         //         ],
// //         //       ),
// //         //     ),
// //         //   ],
// //         // );
// //       },
// //     ),
// //   );
// // }
// }

///
///
///

// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.black,
//     body: _posts.isEmpty && _isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : PageView.builder(
//             controller: _pageController,
//             scrollDirection: Axis.vertical,
//             itemCount: _hasMore ? _posts.length + 1 : _posts.length,
//             itemBuilder: (context, index) {
//               if (index >= _posts.length) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               final post = _posts[index];
//               final isExpanded = _isExpanded(post);
//
//               return Stack(
//                 children: [
//                   Positioned.fill(
//                     child: Image.network(
//                       post.imageUrl ?? '',
//                       fit: BoxFit.contain,
//                       errorBuilder: (_, __, ___) =>
//                           const Icon(Icons.broken_image, color: Colors.white),
//                     ),
//                   ),
//                   Positioned.fill(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             Colors.black.withOpacity(0.3),
//                             Colors.black.withOpacity(0.8),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 50,
//                     right: 20,
//                     child: Column(
//                       children: [
//                         GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         const UploadPostScreen()),
//                               );
//                             },
//                             child: Icon(
//                               Icons.add,
//                               color: Colors.white,
//                             )),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.5),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           // child: const Text(
//                           //   'NEWS',
//                           //   style: TextStyle(color: Colors.white),
//                           // ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                     left: 20,
//                     right: 20,
//                     bottom: 50,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           post.textContent ?? '',
//                           maxLines: isExpanded ? null : 3,
//                           overflow: isExpanded
//                               ? TextOverflow.visible
//                               : TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.9),
//                             fontSize:
//                                 MediaQuery.of(context).size.width * 0.04,
//                             height: 1.4,
//                           ),
//                         ),
//                         if ((post.textContent ?? '').length > 120)
//                           GestureDetector(
//                             onTap: () => _toggleExpanded(post),
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 6),
//                               child: Text(
//                                 isExpanded ? 'See less' : 'See more',
//                                 style: const TextStyle(
//                                   color: Colors.blueAccent,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         const SizedBox(height: 16),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: InkWell(
//                             onTap: () {
//                               _handleShare(
//                                 context,
//                                 headline: post.uploaderName,
//                                 description: post.textContent,
//                                 id: post.id.toString(),
//                                 imageUrl: post.imageUrl,
//                               );
//                               // showModalBottomSheet(
//                               //   context: context,
//                               //   backgroundColor: Colors.transparent,
//                               //   isScrollControlled: true,
//                               //   builder: (_) => ShareBottomSheet(
//                               //     id: post.id!,
//                               //     description: post.textContent!,
//                               //     headline: post.uploaderName!,
//                               //     imageUrl:post.imagePath! ,
//                               //   ),
//                               // );
//                             },
//                             // onTap: () => _showShareSheet(post.id),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 24, vertical: 12),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               child: const Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(Icons.share,
//                                       color: Colors.white, size: 20),
//                                   SizedBox(width: 8),
//                                   Text('Share',
//                                       style: TextStyle(color: Colors.white)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//   );
// }
class NewsCardWidget extends StatefulWidget {
  final NewsCard newsCard;
  final VoidCallback onShare;

  const NewsCardWidget({
    Key? key,
    required this.newsCard,
    required this.onShare,
  }) : super(key: key);

  @override
  State<NewsCardWidget> createState() => _NewsCardWidgetState();
}

class _NewsCardWidgetState extends State<NewsCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.network(
          widget.newsCard.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[900],
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 80,
                  color: Colors.white24,
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.8),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Headline
                Text(
                  widget.newsCard.headline,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Description with Show More/Less
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.newsCard.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        height: 1.4,
                      ),
                      maxLines: _isExpanded ? null : 3,
                      overflow: _isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                    // Show More/Less Button
                    if (widget.newsCard.description.length > 100)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _isExpanded ? 'Show less' : 'Show more',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),

                // Share Button
                Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onShare,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.06,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.share, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Share',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),

        // Watermark (Top Right)
        Positioned(
          top: 50,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'NEWS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
