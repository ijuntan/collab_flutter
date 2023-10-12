import 'package:flutter/material.dart';

class ProfilePic extends StatefulWidget {
  final pic;
  final double? size;
  const ProfilePic({super.key, this.pic, required this.size});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  late final pic = super.widget.pic;
  late final double? size = super.widget.size;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: pic != null && pic != ''
          ? Image.network(pic!, height: size, width: size, fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                  child: CircularProgressIndicator(
                color: Color.fromARGB(255, 99, 58, 1),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ));
            })
          : Image.asset('assets/images/profile.png',
              height: size, width: size, fit: BoxFit.cover),
    );
  }
}
