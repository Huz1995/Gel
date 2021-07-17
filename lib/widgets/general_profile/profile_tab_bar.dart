import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ProfileTabBar extends StatelessWidget with PreferredSizeWidget {
  const ProfileTabBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(30),
      child: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Colors.black.withOpacity(0.4),
              width: 1,
            ),
          ),
        ),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black.withOpacity(0.5),
          tabs: [
            Tab(
              icon: Icon(
                FontAwesome5.images,
                size: 25,
              ),
            ),
            Tab(
              icon: Icon(
                FontAwesome5.address_card,
                size: 25,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.rate_review_outlined,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
