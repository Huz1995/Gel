import 'package:flutter/material.dart';
import 'package:gel/providers/authentication_provider.dart';
import 'package:gel/widgets/general/small_button.dart';
import 'package:provider/provider.dart';

class HairArtistProfileMainPage extends StatelessWidget {
  const HairArtistProfileMainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationProvider>(context, listen: false);
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
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.width / 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      MediaQuery.of(context).size.width / 5,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.060,
                bottom: MediaQuery.of(context).size.width * 0.060,

                //bottom: MediaQuery.of(context).size.width / 4,
                child: Icon(
                  Icons.person,
                  size: 35,
                ),
              ),
            ],
          ),
          SmallButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Text("      Edit Profile      "),
            onPressed: () => print(auth.idToken),
          )
        ],
      ),
    );
  }
}
