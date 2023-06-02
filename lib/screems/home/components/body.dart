import 'package:flutter/material.dart';
import 'package:furniture_app/constants.dart';
import 'package:furniture_app/size_config.dart';

import '../../../components/title_text.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double? defaultSize = SizeConfig.defaultSize;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(defaultSize! * 2),
            child: TitleText(
              title: "Browse by Categories",
              key: key!,
            ),
          ),
          SizedBox(
            width: defaultSize * 20.5,
            child: AspectRatio(
              aspectRatio: 0.83,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    color: Colors.blueAccent,
                  ),
                  ClipPath(
                    child: AspectRatio(
                      aspectRatio: 1.025,
                      child: Container(
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double height = size.height;
    double width = size.width;
    int cornerSize = 30;

    path.lineTo(0, height - cornerSize);

    path.lineTo(width, height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
