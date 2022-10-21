import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_html/html.dart' as html;

class HandCursor extends MouseRegion {
  static final appContainer = html.window.document.querySelectorAll('flt-glass-pane')[0];
  HandCursor({Widget child}) : super(
      onHover: (PointerHoverEvent evt) {
        appContainer.style.cursor='pointer';
      },
      onExit: (PointerExitEvent evt) {
        appContainer.style.cursor='default';
      },
      child: child
  );
}