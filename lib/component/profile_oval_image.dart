import 'package:first_snow/view/profile_edit_screen.dart';
import 'package:first_snow/provider/profile_oval_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:first_snow/provider/client_user_provider.dart';

class ProfileOvalImage extends StatelessWidget {
  final double size;

  ProfileOvalImage({
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final clientUserProvider = Provider.of<ClientUserProvider>(context);
    return GestureDetector(
      onTap: () => context.read<ProfileOvalImageProvider>().pickImage(),
      child: Stack(children: [
        Consumer<ProfileOvalImageProvider>(builder: (context, provider, child) {
          return ClipOval(
            child: provider.imageFile == null
                ? SizedBox(
                    width: 200.0,
                    height: 200.0,
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: clientUserProvider.profileImage,
                    ),
            )
                : Image.file(
                provider.imageFile!,
                fit: BoxFit.cover,
                width: size,
                height: size,
            ),

          );
        }),
        Positioned(
          bottom: size / 32,
          right: size / 32,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400]!,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Container(
                width: size / 4,
                height: size / 4,
                color: Colors.white,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey[400],
                  size: size * 3 / 16,
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

