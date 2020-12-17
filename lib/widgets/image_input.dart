import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectedImage;

  ImageInput(this.onSelectedImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: _storedImage == null
              ? Text(
                  'No Image chosen',
                  textAlign: TextAlign.center,
                )
              : Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            label: Text('Take Picture'),
            icon: Icon(Icons.camera_alt),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
      imageQuality: 80,
    );

    if (imageFile != null) {
      setState(() {
        _storedImage = File(imageFile.path);
      });
      if (_storedImage != null) {
        final appDir = await syspaths.getApplicationDocumentsDirectory();
        final fileName = path.basename(_storedImage.path);
        final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
        print(savedImage.path);
        widget.onSelectedImage(savedImage);
      }
    }
  }
}
