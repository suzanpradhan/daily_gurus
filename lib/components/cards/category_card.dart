import 'package:cached_network_image/cached_network_image.dart';
import 'package:dailygurus/constants.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final int index;
  final int categoryIndex;
  final String isImage;
  final String image;
  final Function categoryChanged;

  CategoryCard({
    this.name,
    this.index,
    this.categoryIndex,
    this.isImage,
    this.image,
    this.categoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: categoryChanged,
        child: Card(
          color: categoryIndex == index ? Colors.lightGreen[200] : kColorWhite,
          elevation: categoryIndex == index ? 3.0 : 1.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              isImage == null
                  ? Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                        child: Image.asset(
                          image,
                          height: 90.0,
                          width: 90.0,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: CachedNetworkImage(
                          imageUrl: '$isImage',
                          height: 90.0,
                          width: 90.0,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                            width: 90.0,
                            height: 90.0,
                            child: Center(
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/icons/vegetable.png',
                            height: 90.0,
                            width: 90.0,
                          ),
                        ),
                      ),
                    ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '${this.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: categoryIndex == index
                            ? kColorGreen
                            : kColorPureBlack,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
