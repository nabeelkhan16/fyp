import 'dart:ui';

import 'package:flutter/material.dart';

GlobalAppBar(BuildContext context,
    {required String title,
    bool leading = true,
    bool chatcreen = true,
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
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          )
        : const SizedBox(),
    title: chatcreen
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade400,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ],
          )
        : Text(
            title,
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontSize: 28,
            ),
          ),
    actions: [trallingWidget],
  );
}
