import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final int? selectAlbumid;

  const FilterScreen({super.key, this.selectAlbumid});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late TextEditingController _albumIdComtroller;
  int? _selectedAlbumId;

  @override
  void initState() {
    super.initState();
    _selectedAlbumId = widget.selectAlbumid;
    _albumIdComtroller = TextEditingController(
      text: _selectedAlbumId?.toString() ?? ' ',
    );
  }

  @override
  void dispose() {
    _albumIdComtroller.dispose();
    super.dispose();
  }

  void _connectFilters() {
    Navigator.pop(context, {
      'albumId': _selectedAlbumId,
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedAlbumId = null;
      _albumIdComtroller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Photos'),
        actions: [
          TextButton(
            onPressed: _connectFilters,
            child: Text(
              'Apply',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Filter by Album ID',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _albumIdComtroller,
            decoration: InputDecoration(
              labelText: 'Enter Album Id',
              border: OutlineInputBorder(),
              hintText: 'e.g., 1, 2, 3...  ',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _selectedAlbumId = value.isEmpty ? null : int.tryParse(value);
              });
            },
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _clearFilters,
            label: Text('Clear Filters'),
            icon: Icon(Icons.clear_outlined),
          )
        ],
      ),
    );
  }
}
