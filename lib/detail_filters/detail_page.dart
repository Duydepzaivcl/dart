import 'package:flutter/material.dart';
import 'package:image_api_hero_animation/model/model.dart';
import 'package:image_api_hero_animation/widgets/custom_image_widget.dart';

class DetailPage extends StatelessWidget {
  final Photo photo;
  const DetailPage({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CustomImageWidget(
                imageUrl: photo.url,
                heroTag: 'photo-${photo.id}',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfo('ID', photo.id.toString()),
                  SizedBox(height: 4),
                  _buildInfo('AlbumId', photo.albumId.toString()),
                  SizedBox(height: 4),
                  _buildInfo('Tittle', photo.title),
                  SizedBox(height: 8),
                  _buildUrl('Image URl', photo.url),
                  SizedBox(height: 8),
                  _buildUrl('Thumbnail Url', photo.thumbnailUrl)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value),
        )
      ],
    );
  }

  Widget _buildUrl(String label, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2),
        Text(
          url,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        )
      ],
    );
  }
}
