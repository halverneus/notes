part of Icon;

class Icon {
  var x = new svg.SvgElement.tag("svg");

  Icon(String icon, int size, [int verticalIfDifferent = null]) {
    this.setSize(size, verticalIfDifferent);
    this.icon = icon;
  }

  String get icon => this.x.innerHtml;
  void set icon(String icon) {
    this.x.innerHtml = icon;
  }

  html.CssClassSet get classes => this.x.classes;
  void set classes(Iterable<String> classes) {
    this.x.classes = classes;
  }

  html.CssStyleDeclaration get style => this.x.style;

  html.ElementStream<html.MouseEvent> get onClick => this.x.onClick;

  void setSize(int size, [int verticalIfDifferent = null]) {
    if (null == verticalIfDifferent) {
      verticalIfDifferent = size;
    }

    this.x
      ..setAttribute("viewBox", "0 0 24 24")
      ..style.width = "${size}px"
      ..style.height = "${verticalIfDifferent}px";
  }
}
