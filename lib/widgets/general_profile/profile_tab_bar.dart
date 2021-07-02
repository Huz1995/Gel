import 'package:flutter/material.dart';

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
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.black.withOpacity(0.5),
          tabs: [
            Tab(
              icon: Icon(
                Icons.photo_album_outlined,
                size: 35,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.info_outline,
                size: 35,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.rate_review_outlined,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
