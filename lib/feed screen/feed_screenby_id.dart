// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../api_services/services.dart';
// import '../model.dart';
// import 'feed_screen.dart';
//
// // Import your FeedScreen - adjust the path as needed
// // import 'feed_screen.dart'; // Uncomment and adjust path
//
// class FeedByIdScreen extends StatefulWidget {
//   final String postId;
//
//   const FeedByIdScreen({
//     Key? key,
//     required this.postId,
//   }) : super(key: key);
//
//   @override
//   State<FeedByIdScreen> createState() => _FeedByIdScreenState();
// }
//
// class _FeedByIdScreenState extends State<FeedByIdScreen> {
//   bool _isLoading = false;
//   Posts? _post;
//
//   @override
//   void initState() {
//     debugPrint('0 id ${widget.postId}');
//     super.initState();
//     _fetchPostById();
//   }
//
//   Future<void> _fetchPostById() async {
//     setState(() => _isLoading = true);
//
//     try {
//       final post = await CardsApiService.fetchCardById(widget.postId);
//
//       setState(() {
//         _post = post;
//       });
//     } catch (e) {
//       debugPrint('Fetch post by id error: $e');
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _post == null
//           ? const Center(
//         child: Text(
//           'Post not found',
//           style: TextStyle(color: Colors.white),
//         ),
//       )
//           : PageView(
//         scrollDirection: Axis.vertical,
//         children: [
//           _PostItem(post: _post!),
//         ],
//       ),
//     );
//   }
// }
//
// class _PostItem extends StatelessWidget {
//   final Posts post;
//
//   const _PostItem({required this.post});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background Image
//         Positioned.fill(
//           child: post.mediaUrl != null
//               ? Image.network(
//             post.mediaUrl!,
//             fit: BoxFit.contain,
//             errorBuilder: (_, __, ___) => const Center(
//               child: Icon(
//                 Icons.broken_image,
//                 color: Colors.white,
//                 size: 48,
//               ),
//             ),
//           )
//               : const Center(
//             child: Icon(
//               Icons.image_not_supported,
//               color: Colors.white,
//               size: 48,
//             ),
//           ),
//         ),
//
//         // Back Button (Top Left)
//         Positioned(
//           top: 0,
//           left: 0,
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: () {
//                     // Navigate back to FeedScreen
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => FeedScreen(id: ''),
//                       ),
//                     );
//                   },
//                   borderRadius: BorderRadius.circular(30),
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.3),
//                         width: 1,
//                       ),
//                     ),
//                     child: const Icon(
//                       Icons.arrow_back,
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//
//         // Watermark (Top Right) - Optional
//         Positioned(
//           top: 0,
//           right: 0,
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text(
//                   'NEWS',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../api_services/services.dart';
import '../model.dart';

class FeedByIdScreen extends StatefulWidget {
  final dynamic cardId;

  const FeedByIdScreen({
    Key? key,
    required this.cardId,
  }) : super(key: key);

  @override
  State<FeedByIdScreen> createState() => _FeedByIdScreenState();
}

class _FeedByIdScreenState extends State<FeedByIdScreen> {
  bool _isLoading = false;
  CardsModel? _card; // using CardsModel
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _fetchCardById();
  }

  Future<void> _fetchCardById() async {
    setState(() => _isLoading = true);

    try {
      final card =
      await CardsApiService.fetchCardById(widget.cardId.toString());
      setState(() => _card = card);
    } catch (e) {
      debugPrint('Fetch card error: $e');
    }

    setState(() => _isLoading = false);
  }

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _card == null
          ? const Center(
        child: Text(
          'Card not found',
          style: TextStyle(color: Colors.white),
        ),
      )
          : PageView(
        scrollDirection: Axis.vertical,
        children: [
          _CardItem(
            card: _card!,
            isExpanded: _isExpanded,
            onToggle: _toggleExpanded,
          ),
        ],
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  final CardsModel card;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _CardItem({
    required this.card,
    required this.isExpanded,
    required this.onToggle,
  });

  Widget _buildCardImage() {
    if (card.imageUrl != null && card.imageUrl!.isNotEmpty) {
      return Image.network(
        card.imageUrl!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image, color: Colors.white, size: 48),
        ),
      );
    }

    return const Center(
      child: Icon(Icons.image_not_supported, color: Colors.white, size: 48),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textContent = card.textContent ?? '';

    return Stack(
      children: [
        Positioned.fill(child: _buildCardImage()),

        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.85),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.6),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ),
        ),

        Positioned(
          left: 20,
          right: 20,
          bottom: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textContent,
                maxLines: isExpanded ? null : 3,
                overflow:
                isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  height: 1.4,
                ),
              ),
              if (textContent.length > 120)
                GestureDetector(
                  onTap: onToggle,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      isExpanded ? 'See less' : 'See more',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// class FeedByIdScreen extends StatefulWidget {
//   final String postId;
//
//   const FeedByIdScreen({
//     Key? key,
//     required this.postId,
//   }) : super(key: key);
//
//   @override
//   State<FeedByIdScreen> createState() => _FeedByIdScreenState();
// }
//
// class _FeedByIdScreenState extends State<FeedByIdScreen> {
//   bool _isLoading = false;
//   Posts? _post;
//
//   /// 🔹 See more / less state
//   bool _isExpanded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     debugPrint('0 id ${widget.postId}');
//     _fetchPostById();
//   }
//
//   Future<void> _fetchPostById() async {
//     setState(() => _isLoading = true);
//
//     try {
//       final post = await CardsApiService.fetchCardById(widget.postId);
//       setState(() {
//         _post = post;
//       });
//     } catch (e) {
//       debugPrint('Fetch post by id error: $e');
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   void _toggleExpanded() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _post == null
//           ? const Center(
//         child: Text(
//           'Post not found',
//           style: TextStyle(color: Colors.white),
//         ),
//       )
//           : PageView(
//         scrollDirection: Axis.vertical,
//         children: [
//           _PostItem(
//             post: _post!,
//             isExpanded: _isExpanded,
//             onToggle: _toggleExpanded,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _PostItem extends StatelessWidget {
//   final Posts post;
//   final bool isExpanded;
//   final VoidCallback onToggle;
//
//   const _PostItem({
//     required this.post,
//     required this.isExpanded,
//     required this.onToggle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final caption = post.caption ?? '';
//
//     return Stack(
//       children: [
//         /// 🔹 Background Image
//         Positioned.fill(
//           child: post.mediaUrl != null
//               ? Image.network(
//             post.mediaUrl!,
//             fit: BoxFit.contain,
//             errorBuilder: (_, __, ___) => const Center(
//               child: Icon(
//                 Icons.broken_image,
//                 color: Colors.white,
//                 size: 48,
//               ),
//             ),
//           )
//               : const Center(
//             child: Icon(
//               Icons.image_not_supported,
//               color: Colors.white,
//               size: 48,
//             ),
//           ),
//         ),
//
//         /// 🔹 Gradient Overlay
//         Positioned.fill(
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.transparent,
//                   Colors.black.withOpacity(0.3),
//                   Colors.black.withOpacity(0.85),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//         /// 🔹 Back Button
//         Positioned(
//           top: 0,
//           left: 0,
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => FeedScreen(id: ''),
//                     ),
//                   );
//                 },
//                 borderRadius: BorderRadius.circular(30),
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.6),
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.3),
//                     ),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//
//         /// 🔹 Watermark
//         Positioned(
//           top: 0,
//           right: 0,
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text(
//                   'NEWS',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//
//         /// 🔹 Bottom Content
//         Positioned(
//           left: 20,
//           right: 20,
//           bottom: 50,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Title
//               Text(
//                 post.title ?? '',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: MediaQuery.of(context).size.width * 0.06,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//               /// Caption with See More / Less
//               Text(
//                 caption,
//                 maxLines: isExpanded ? null : 3,
//                 overflow:
//                 isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.9),
//                   fontSize: MediaQuery.of(context).size.width * 0.04,
//                   height: 1.4,
//                 ),
//               ),
//
//               if (caption.length > 120)
//                 GestureDetector(
//                   onTap: onToggle,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 6),
//                     child: Text(
//                       isExpanded ? 'See less' : 'See more',
//                       style: const TextStyle(
//                         color: Colors.blueAccent,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
