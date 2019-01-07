part of TextInput;

class TextInput extends ui.Div {

  var _input = new html.TextInputElement();
  var _label = new html.LabelElement();

  TextInput() : super() {
    this.classes = ["text-input"];

    this._input.required = true;

    var highlight = new html.SpanElement();
    highlight.classes = ["highlight"];

    var bar = new html.SpanElement();
    bar.classes = ["bar"];

    this.children = [
      this._input,
      highlight,
      bar,
      this._label,
    ];

  }

  html.ElementStream<html.KeyboardEvent> get onKeyUp => this.x.onKeyUp;

  String get text => this._label.text;
  void set text(String text) {
    this._label.text = text;
  }

  String get value => this._input.value;
  void set value(String text) {
    this._input.value = text;
  }

  void focus([_]) {
    this._input.focus();
  }
}