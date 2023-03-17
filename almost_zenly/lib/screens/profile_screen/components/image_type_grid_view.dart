import 'package:almost_zenly/types/image_type.dart';
import 'package:flutter/material.dart';

class ImageTypeGridView extends StatelessWidget {
  const ImageTypeGridView({
    super.key,
    required this.selectedImageType,
    required this.onTap,
  });

  final ImageType selectedImageType;
  final ValueChanged<ImageType> onTap;

  @override
  Widget build(BuildContext context) {
    const images = ImageType.values;

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: [
        for (final imageType in images)
          GestureDetector(
            onTap: () => onTap(imageType),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: imageType == selectedImageType
                    ? Colors.blue
                    : Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Image.asset(imageType.path),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
