part of Icon;

class KeyIcon {
  var x = new svg.SvgElement.tag("svg");

  static const String _GREY_PATH =
      "m 367.5,32.57 -258.90235,0.15234 -48.95898,64.60743 -0.15235,-64.75782 -58.19726,0 0,143.69922 58.19726,0 0.15235,-64.83984 49.18945,64.8418 203.71094,-0.15235 0,-39.59961 -82.94922,-0.15234 0,-11.99609 82.94922,-0.1504 0.1543,-39.75 -83.10352,0 0,-12 82.72266,-0.26562 0.37109,-0.0352 0.15625,-31.91406 54.72852,86.65234 -30.89844,49.21094 59.24609,0.1543 0.35156,-0.37695 30.77735,-48.95118 -59.54492,-94.37695 z m -195.8086,6.33984 -0.0957,130.65626 -50.64258,-65.06641 50.73828,-65.58985 z";
  static const String _YELLOW_PATH =
      "m 439.6,12.65 -439.09952,-0.1504 0,-11.99959 506.69997,0.12036 -49.8523,79.22964 -59.97446,-0.0767";
  static const String _GREY_COLOR = "#5f5f5f";
  static const String _YELLOW_COLOR = "#ffb700";
  static const double _ASPECT_RATIO = 0.35;

  KeyIcon(int width) {
    var height = (width.toDouble() * KeyIcon._ASPECT_RATIO).toInt();
    this.x
      ..setAttribute("viewBox", "0 0 508 177")
      ..style.width = "${width}px"
      ..style.height = "${height}px";

    var greyPath = new svg.PathElement();
    var yellowPath = new svg.PathElement();

    greyPath.setAttribute("d", KeyIcon._GREY_PATH);
    yellowPath.setAttribute("d", KeyIcon._YELLOW_PATH);

    greyPath.style
      ..setProperty("fill", KeyIcon._GREY_COLOR)
      ..setProperty("stroke", KeyIcon._GREY_COLOR);
    yellowPath.style
      ..setProperty("fill", KeyIcon._YELLOW_COLOR)
      ..setProperty("stroke", KeyIcon._YELLOW_COLOR);

    this.x.append(yellowPath);
    this.x.append(greyPath);
  }
}
