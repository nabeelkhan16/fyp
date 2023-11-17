import 'dart:ui';

import 'package:flutter/material.dart';

GlobalAppBar(BuildContext context,
    {required String title,
    bool leading = true,
    Widget trallingWidget = const SizedBox(
      width: 12,
    )}) {
  return AppBar(
    forceMaterialTransparency: true,
    centerTitle: true,
    elevation: 0,
    flexibleSpace: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    ),
    leading: leading
        ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
          )
        : const SizedBox(),
    title: Text(
      title,
      style: TextStyle(
        color: Theme.of(context).scaffoldBackgroundColor,
        fontSize: 18,
      ),
    ),
    actions: [trallingWidget],
  );
}
