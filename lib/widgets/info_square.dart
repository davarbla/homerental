import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:homerental/models/rental_model.dart';
import 'package:homerental/widgets/icon_text.dart';

class InfoSquare extends StatelessWidget {
  final RentalModel rental;
  final double iconSize;
  final double spaceWidth;
  InfoSquare({required this.rental, this.iconSize = 18, this.spaceWidth = 10});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconText(
          icon: Icon(MaterialIcons.king_bed,
              color: Colors.black45, size: this.iconSize),
          text: "${rental.beds} Beds ",
        ),
        SizedBox(width: this.spaceWidth),
        IconText(
          icon: Icon(MaterialIcons.bathtub,
              color: Colors.black45, size: this.iconSize),
          text: "${rental.baths} Baths ",
        ),
        SizedBox(width: this.spaceWidth),
        IconText(
          icon: Icon(MaterialIcons.square_foot,
              color: Colors.black45, size: this.iconSize),
          text: "${rental.sqft} sqft ",
        ),
      ],
    );
  }
}
