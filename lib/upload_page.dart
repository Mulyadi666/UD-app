import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _imageFile;
//pilihgambar
  Future pickImage() async {
    //picker
    final ImagePicker picker = ImagePicker();
    //pilih dari galeri
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    //updateimage
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future uploadImage() async {
    //upload image
    if (_imageFile == null) return;
    //generate filename
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'uploads/$fileName';
    //upload image to supabase
    await Supabase.instance.client.storage
        .from('images')
        .upload(path, _imageFile!)
        .then((value) => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Upload Success'))));
  }

//uploadgambar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard');
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            //image priview
            _imageFile != null
                ? Image.file(_imageFile!)
                : const Text('No Image Selected'),
            //pilihgambar
            ElevatedButton(
                onPressed: pickImage, child: const Text('Pick Image')),
            //upload image
            ElevatedButton(onPressed: uploadImage, child: const Text('Upload'))
          ],
        ),
      ),
    );
  }
}
