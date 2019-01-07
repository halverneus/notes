library Div;

import 'dart:html' as html;

class Div {
  var x = new html.DivElement();

  Div() {}

  html.CssClassSet get classes => this.x.classes;
  void set classes(Iterable<String> classes) {
    this.x.classes = classes;
  }

  html.CssStyleDeclaration get style => this.x.style;

  List<html.Element> get children => this.x.children;
  void set children(List<html.Element> children) {
    this.x.children = children;
  }

  html.ElementStream<html.MouseEvent> get onClick => this.x.onClick;

  void click([_]) {
    this.x.click();
  }
}
