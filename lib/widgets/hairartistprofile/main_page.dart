import 'package:flutter/material.dart';

class HairArtistProfileMainPage extends StatelessWidget {
  const HairArtistProfileMainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
          ),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.width / 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      MediaQuery.of(context).size.width / 4,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.078,
                bottom: MediaQuery.of(context).size.width * 0.078,

                //bottom: MediaQuery.of(context).size.width / 4,
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
