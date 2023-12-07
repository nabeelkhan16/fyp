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
    leadingWidth: 60,
    leading: leading
        ? IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          )
        : const SizedBox(),
    title: chatcreen
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade400,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          )
        : Text(
            title,
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontSize: 18,
            ),
          ),
    actions: [trallingWidget],
  );
}
