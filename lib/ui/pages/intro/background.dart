import 'package:flutter/material.dart';
import 'package:green_ride/ui/pages/intro/navigation_bus.dart';

class Background extends StatefulWidget {
  const Background({Key key, @required String assetName})
      : _assetName = assetName,
        super(key: key);

  @override
  BackgroundState createState() => new BackgroundState();

  final String _assetName;
}

class BackgroundState extends State<Background> {
  double get _aspectRatio {
    return 2;
  }

  @override
  void initState() {
    super.initState();

    Function listener = (ControllerAttachedEvent event) {
      setState(() {});
    };
    NavigationBus.registerControllerAttachedListener(listener);
  }

  @override
  void dispose() {
    NavigationBus.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Animation animation = NavigationBus.animation;

    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          double offset = animation.value * -0.28 + 0.5;

          return OverflowBox(
              maxWidth: double.infinity,
              alignment: Alignment(offset, 0),
              child: AspectRatio(
                  aspectRatio: _aspectRatio,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(widget._assetName))))));
        });
  }
}
