import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

 
showModelBottomSheet(BuildContext context, String fileName) async {
  var image = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext bc) {
        return CupertinoActionSheet(
          title: const Text('Choose Photo From'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () async {
                var image = await _getFromGallery(fileName);
             
                Navigator.of(context).pop(image);
              },
              child: const Text('Photo Library'),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                var image = await _getFromCamera(fileName);
                Navigator.of(context).pop(image);
              },
              child: const Text('Camera'),
            ),
          ],
        );
      });
  return image;
}

_getFromGallery(fileName) async {
  XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800, requestFullMetadata: false);
  if (pickedFile != null) {
    File file = File('${(await getApplicationDocumentsDirectory()).path}/$fileName.${pickedFile.path.split('.').last}');
    file.writeAsBytesSync(await pickedFile.readAsBytes());
    return file;
  }
}

/// Get from Camera
_getFromCamera(fileName) async {
  XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1800, maxHeight: 1800, requestFullMetadata: false);
  if (pickedFile != null) {
    File file = File('${(await getApplicationDocumentsDirectory()).path}/$fileName.${pickedFile.path.split('.').last}');
    file.writeAsBytesSync(await pickedFile.readAsBytes());
    return file;
  }
}
