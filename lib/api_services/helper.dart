import '../feed screen/feed_screen.dart' show NewsCard;
import '../model.dart';

// NewsCard convertToNewsCard(Posts post) {
//   return NewsCard(
//     id: post.id ?? "",
//     imageUrl: post.mediaUrl ?? post.thumbnailUrl ?? "",
//     headline: post.title ?? "No Title",
//     description: post.caption ?? "",
//   );
// }
NewsCard convertToNewsCard(Posts post) {
  return NewsCard(
    id: post.id ?? "",
    imageUrl: post.mediaUrl ??  "",
    headline: post.title ?? "No Title",
    description: post.caption ?? "",
  );
}

