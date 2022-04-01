import 'package:flutter/material.dart';
import 'package:acumen_mbanking/Screens/login_screen.dart';

class FadePageRoute<T> extends MaterialPageRoute<T> {
  FadePageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 800);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == LoginScreen) {
      return child;
    }

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
