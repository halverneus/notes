part of Layout;

class HorizontalLayout extends ui.Div {

  html.TableRowElement _layout;

  HorizontalLayout() : super() {
    var table = new html.TableElement();
    table.classes = ["fill-space"];
    this._layout = table.createTBody().addRow();

    this.classes = ["layout"];

    this.children = [table];
  }

  html.Element add([html.Element element]) {
    var cell = this._layout.addCell();
    if (null != element) {
      cell.children = [element];
    }
    return cell;
  }

  void addStretch() {
    var stretch = new html.DivElement();
    stretch.style.width = "100%";
    this._layout.addCell().children = [stretch];
  }
}