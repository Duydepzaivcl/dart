import 'package:flutter/material.dart';
import 'package:image_api_hero_animation/model/model.dart';
import 'home_screen_helper.dart';
import 'package:image_api_hero_animation/service/photo_service.dart';
import 'package:image_api_hero_animation/widgets/custom_image_widget.dart';
import 'package:image_api_hero_animation/detail_filters/detail_page.dart';
import 'package:image_api_hero_animation/detail_filters/filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PhotoService _photoService = PhotoService();
  List<Photo> _photos = [];
  List<Photo> _filteredPhoto = [];
  int? _selectedAlbumId;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _initPerfs();
    await _loadPhotos();
  }

  Future<void> _initPerfs() async {
    try {
      _selectedAlbumId = await HomeScreenHelper.getSelectedAlbumId();
      setState(() {});
    } catch (e) {
      print('Error initializing $e');
    }
  }

  Future<void> _loadPhotos() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final photos = await _photoService.getPhotos();

      setState(() {
        _photos = photos;
        _connectFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _connectFilter() {
    setState(() {
      _filteredPhoto = _photos.where((photo) {
        if (_selectedAlbumId != null) {
          return photo.albumId == _selectedAlbumId;
        }
        return true;
      }).toList();
    });
  }

  Future<void> _openFilterScreen() async {
    final connect = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterScreen(selectAlbumid: _selectedAlbumId),
      ),
    );

    if (connect != null && mounted) {
      _selectedAlbumId = connect['albumId'];
      await HomeScreenHelper.setSelectedAlbumId(_selectedAlbumId);
      _connectFilter();
    }
  }

  void _openDetail(Photo photo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(photo: photo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery'),
        actions: [
          IconButton(
            onPressed: () => _openFilterScreen(),
            icon: Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: _loadPhotos,
            icon: Icon(Icons.refresh_outlined),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadPhotos,
              child: Text('Retry'),
            )
          ],
        ),
      );
    }
    if (_filteredPhoto.isEmpty) {
      return Center(
        child: Text('No photos found'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPhotos,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _filteredPhoto.length,
        itemBuilder: (context, index) => _buildPhotoItem(_filteredPhoto[index]),
      ),
    );
  }

  Widget _buildPhotoItem(Photo photo) {
    return GestureDetector(
      onTap: () => _openDetail(photo),
      child: CustomImageWidget(
        imageUrl: photo.thumbnailUrl,
        heroTag: 'photo-${photo.id}',
      ),
    );
  }
}
