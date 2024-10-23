import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenHelper {
  static const String selectedAlbumId = 'selectedAlbumId';

  static Future<SharedPreferences> getInstance() async =>
      await SharedPreferences.getInstance();

  static Future<int?> getSelectedAlbumId() async {
    final prefs = await getInstance();
    int? albumId = prefs.getInt(selectedAlbumId);
    return albumId == -1 ? null : albumId;
  }

  static Future<void> setSelectedAlbumId(int? albumId) async {
    final prefs = await getInstance();
    await prefs.setInt(selectedAlbumId, albumId ?? -1);
  }
}
