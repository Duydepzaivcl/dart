import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_api_hero_animation/model/model.dart';

class PhotoService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/photos';

  Future<List<Photo>> getPhotos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Photo.formJson(json)).toList();
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error $e');
    }
  }
}
