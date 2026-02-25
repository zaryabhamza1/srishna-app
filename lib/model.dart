// class CardsModel {
//   List<Assets>? assets;
//
//   CardsModel({this.assets});
//
//   CardsModel.fromJson(Map<String, dynamic> json) {
//     if (json['assets'] != null) {
//       assets = <Assets>[];
//       json['assets'].forEach((v) {
//         assets!.add(new Assets.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.assets != null) {
//       data['assets'] = this.assets!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Assets {
//   String? id;
//   String? imagePromptUsed;
//   String? createdAt;
//   int? dramaLevel;
//   bool? searchGrounding;
//   String? storageUrl;
//   String? caption;
//   String? finalImageBase64;
//   String? aspectRatio;
//   bool? thinkingProcess;
//   String? imageGenerator;
//   String? punchline;
//   String? inputText;
//   String? hiddenAngle;
//   String? imageUrl;
//   String? summary;
//
//   Assets({
//     this.id,
//     this.imagePromptUsed,
//     this.createdAt,
//     this.dramaLevel,
//     this.searchGrounding,
//     this.storageUrl,
//     this.caption,
//     this.finalImageBase64,
//     this.aspectRatio,
//     this.thinkingProcess,
//     this.imageGenerator,
//     this.punchline,
//     this.inputText,
//     this.hiddenAngle,
//     this.imageUrl,
//     this.summary,
//   });
//
//   Assets.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     imagePromptUsed = json['image_prompt_used'];
//     createdAt = json['created_at'];
//     dramaLevel = json['drama_level'];
//     searchGrounding = json['search_grounding'];
//     storageUrl = json['storage_url'];
//     caption = json['caption'];
//     finalImageBase64 = json['final_image_base64'];
//     aspectRatio = json['aspect_ratio'];
//     thinkingProcess = json['thinking_process'];
//     imageGenerator = json['image_generator'];
//     punchline = json['punchline'];
//     inputText = json['input_text'];
//     hiddenAngle = json['hidden_angle'];
//     imageUrl = json['image_url'];
//     summary = json['summary'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['image_prompt_used'] = this.imagePromptUsed;
//     data['created_at'] = this.createdAt;
//     data['drama_level'] = this.dramaLevel;
//     data['search_grounding'] = this.searchGrounding;
//     data['storage_url'] = this.storageUrl;
//     data['caption'] = this.caption;
//     data['final_image_base64'] = this.finalImageBase64;
//     data['aspect_ratio'] = this.aspectRatio;
//     data['thinking_process'] = this.thinkingProcess;
//     data['image_generator'] = this.imageGenerator;
//     data['punchline'] = this.punchline;
//     data['input_text'] = this.inputText;
//     data['hidden_angle'] = this.hiddenAngle;
//     data['image_url'] = this.imageUrl;
//     data['summary'] = this.summary;
//     return data;
//   }
// }
// CardsModel stays the same
class Posts {
  final dynamic id;
  final String? mediaUrl;
  final String? title;
  final String? caption;

  Posts({
    required this.id,
    this.mediaUrl,
    this.title,
    this.caption,
  });

  /// From JSON
  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      id: json['id'] ?? 0,
      mediaUrl: json['imageUrl'] ?? json['mediaUrl'],
      title: json['title'] ?? json['textContent'],
      caption: json['caption'] ?? json['textContent'],
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mediaUrl': mediaUrl,
      'title': title,
      'caption': caption,
    };
  }
}
class CardsModel {
  int? id;
  String? imageUrl;
  String? imagePath;
  String? textContent;
  bool? active;
  String? uploaderName;
  String? createdAt;

  CardsModel({
    this.id,
    this.imageUrl,
    this.imagePath,
    this.textContent,
    this.active,
    this.uploaderName,
    this.createdAt,
  });

  factory CardsModel.fromJson(Map<String, dynamic> json) {
    return CardsModel(
      id: json['id'],
      imageUrl: json['imageUrl'],
      imagePath: json['imagePath'],
      textContent: json['textContent'],
      active: json['active'],
      uploaderName: json['uploaderName'],
      createdAt: json['createdAt'],
    );
  }
}

// class CardsModel {
//   int? id;
//   String? imageUrl;
//   String? textContent;
//   bool? active;
//   String? createdAt;
//
//   CardsModel({this.id, this.imageUrl, this.textContent, this.active, this.createdAt});
//
//   factory CardsModel.fromJson(Map<String, dynamic> json) {
//     return CardsModel(
//       id: json['id'],
//       imageUrl: json['imageUrl'],
//       textContent: json['textContent'],
//       active: json['active'],
//       createdAt: json['createdAt'],
//     );
//   }
// }
