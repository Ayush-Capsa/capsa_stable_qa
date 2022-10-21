import 'package:flutter/material.dart';import 'package:capsa/functions/custom_print.dart';

void showNotificationBar(BuildContext context) {
  OverlayEntry overlayEntry;
  if (overlayEntry == null) {
    overlayEntry = OverlayEntry(builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
              child: GestureDetector(
            onTap: () {
              return dismissMenu(overlayEntry);
            },
            child: Container(
              color: Colors.transparent,
            ),
          )),
          Positioned(
            right: 0,
            width: MediaQuery.of(context).size.width * 0.27,
            child: Material(
              elevation: 5,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    title: Text('Notification 1'),
                  ),
                  ListTile(
                    title: Text('Notification 1'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Overlay.of(context).insert(overlayEntry);
}

void dismissMenu(overlayEntry) {
  if (overlayEntry != null) {
    overlayEntry.remove();
    overlayEntry = null;
  }
}
