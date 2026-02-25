import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:srishnaapp/model.dart';

class CardsResponse {
  final List<CardsModel> cards;
  final String? nextCursor;

  CardsResponse({required this.cards, this.nextCursor});

  factory CardsResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return CardsResponse(
      cards: dataList.map((e) => CardsModel.fromJson(e)).toList(),
      nextCursor: json['nextCursor'],
    );
  }
}
class CardsApiService {

  static const baseUrls = 'https://srishna-image-upload-712085419978.asia-south1.run.app/api/posts';

  /// Upload image with text
  static Future<void> uploadPost({required String text, required File imageFile}) async {
    final request = http.MultipartRequest('POST', Uri.parse(baseUrls));

    // Add headers (if text needs to be sent via headers)
    request.headers['text'] = text;

    // Add file
    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Upload successful');
    } else {
      throw Exception('Upload failed with status: ${response.statusCode}');
    }
  }
  static const baseUrl =
      'https://srishna-image-upload-712085419978.asia-south1.run.app/api/posts/list';

  static Future<List<CardsModel>> fetchCards({int limit = 10}) async {
    final url = '$baseUrl?limit=$limit';
    final response = await http.get(Uri.parse(url));

    debugPrint('fetchCards response: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData is List) {
        return jsonData.map((e) => CardsModel.fromJson(e)).toList();
      } else {
        throw Exception('Unexpected API format, expected a list');
      }
    } else {
      throw Exception('Failed to load cards');
    }
  }

  static Future<CardsModel> fetchCardById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    debugPrint('fetchCardById response: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData is List && jsonData.isNotEmpty) {
        return CardsModel.fromJson(jsonData[0]);
      } else {
        throw Exception('Card not found');
      }
    } else {
      throw Exception('Failed to load card');
    }
  }
}

