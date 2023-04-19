import 'package:flutter/material.dart';

Scrollbar scrollbarWidget(dynamic widgets) {
  ScrollController controllerOutside = ScrollController();
  ScrollController controllerInside = ScrollController();
  return Scrollbar(
    thumbVisibility: true,
    radius: const Radius.circular(0),
    thickness: 10,
    controller: controllerOutside,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: controllerOutside,
      child: SingleChildScrollView(
        controller: controllerInside,
        scrollDirection: Axis.vertical,
        child: widgets,
      ),
    ),
  );
}
