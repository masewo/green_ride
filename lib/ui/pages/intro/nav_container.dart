import 'dart:io';

import 'package:flutter/material.dart';
import 'package:green_ride/ui/pages/intro/nav_route_view.dart';
import 'package:green_ride/ui/pages/intro/navigation_bus.dart';
import 'package:green_ride/ui/pages/settings_page.dart';
import 'package:green_ride/ui/theme/app_theme.dart';

class NavContainer extends StatefulWidget {
  NavContainer({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  _NavContainerState createState() => _NavContainerState();
}

class _NavContainerState extends State<NavContainer>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int _currentIndex = 0;

  late Animation<double> _animation;

//  List<Tab> get _tabs {
//
//    int _index = 0;
//    Iterable<Tab> _map = widget.children.map<Tab>((Widget child) {
//
//      Tab _tab = Tab(
//        icon: new NavTabIcon(
//            index: _index,
//            name: name,
//            animation: _animation
//        ),
//      );
//
//      _index++;
//      return _tab;
//    });
//
//    return _map.toList();
//  }

  List<NavRouteView> get _routes {
    int _index = 0;
    Iterable<NavRouteView> _map =
        widget.children.map<NavRouteView>((Widget child) {
      NavRouteView _view = NavRouteView(
          index: _index,
          child: Container(
              constraints: BoxConstraints.expand(),
              child: Center(
                  child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Spacer(),
                        Expanded(flex: 3, child: Center(child: child)),
                        Spacer(),
                      ],
                    ),
                  ),
                  Spacer()
                ],
              ))),
          animation: _animation);

      _index++;
      return _view;
    });

    return _map.toList();
  }

  @override
  void initState() {
    super.initState();

    _controller =
        new TabController(vsync: this, length: widget.children.length);
//    _controller.animation.addListener(() {
//      print(_controller.offset.toString());
//    });
    _controller.animation?.addListener(() {
//      print(_controller.index.toString());
      setState(() {
//        _currentIndex = _controller.index;
        _currentIndex = (_controller.animation!.value).round();
      });
    });
    _animation = _controller.animation!;
    NavigationBus.registerTabController(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.black45,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40.0),
      side: BorderSide(color: Colors.white, width: 2.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        padding: Platform.isAndroid
            ? EdgeInsets.only(bottom: 48)
            : EdgeInsets.only(bottom: 64),
        constraints: BoxConstraints.expand(),
        child: TabBarView(
          controller: _controller,
          children: _routes,
        ),
      ),
      SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < widget.children.length; i++)
              if (i == _currentIndex) ...[buildCircleBar(true)] else
                buildCircleBar(false),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(SettingsPage.route),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Text(
                        _currentIndex != widget.children.length - 1
                            ? "Skip Intro"
                            : "Start",
                        style: AppTheme.textStyleWhite),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    )
                  ],
                )),
            SizedBox(
              width: 8,
            )
          ],
        )
      ]))
//          Column(
//              mainAxisAlignment: MainAxisAlignment.end,
//              crossAxisAlignment: CrossAxisAlignment.stretch,
//              children: [
//
//                ( Platform.isAndroid )
//
//                    ? TabBar(
//                    indicatorPadding: EdgeInsets.all(1),
//                    labelPadding: EdgeInsets.zero,
//                    controller: _controller,
//                    indicatorWeight: 4,
//                    tabs: _tabs
//                )
//
//                    : Container(
//                    decoration: BoxDecoration(
//                        gradient: LinearGradient(
//                            begin: Alignment.topCenter,
//                            end: Alignment.bottomCenter,
//                            colors: [
//                              const Color.fromARGB(8, 16, 32, 16),
//                              const Color.fromARGB(192, 32, 16, 32)
//                            ]
//                        )
//                    ),
//                    child: TabBar(
//
//                        indicator: BoxDecoration(),
//                        labelPadding: EdgeInsets.only(bottom: 6, top: 4),
//                        indicatorPadding: EdgeInsets.only(top: 6, bottom: 12),
//                        controller: _controller,
//                        tabs: _tabs
//                    )
//                )
//              ]
//          )
    ]);
  }

  Widget buildCircleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: isActive ? 8 : 8,
      width: isActive ? 8 : 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(8))),
    );
  }
}
