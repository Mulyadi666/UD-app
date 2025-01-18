import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<String> imageUrls = [];
  final String bucketName = 'images';

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future fetchImages() async {
    try {
      final files = await Supabase.instance.client.storage
          .from(bucketName)
          .list(path: 'uploads');

      final List<String> urls = files.map((file) {
        return Supabase.instance.client.storage
            .from(bucketName)
            .getPublicUrl('uploads/${file.name}');
      }).toList();

      setState(() {
        imageUrls = urls;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to fetch images: $e')));
    }
  }

  Future deleteImage(String imagePath) async {
    try {
      await Supabase.instance.client.storage
          .from(bucketName)
          .remove([imagePath]);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Image deleted')));
      fetchImages();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: imageUrls.isEmpty
          ? const Center(child: Text('No images found'))
          : ListView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                final imageUrl = imageUrls[index];
                final fileName = imageUrl.split('/').last;

                return ListTile(
                  leading: Image.network(imageUrl, width: 50, height: 50),
                  title: Text(fileName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
                          // Download functionality is browser-dependent
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteImage('uploads/$fileName');
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
