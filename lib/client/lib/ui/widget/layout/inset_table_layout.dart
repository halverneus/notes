part of Layout;

class InsetTableLayout extends ui.Div {

  int _columns;
  static const int MIN_COLUMNS = 1;
  static const int MAX_COLUMNS = 10;

  var _items = new List<ui.Div>();
  html.TableSectionElement _layout;
  html.TableRowElement _lastRow;

  InsetTableLayout({int columns=1}) : super() {
    this.classes = ['layout', 'inset-layout'];

    var table = new html.TableElement();
    table.classes = ["table-layout"];
    this._layout = table.createTBody();

    this.children.add(table);

    this.columns = columns;
  }

  int get columns => this._columns;
  void set columns(int columns) {
    if (InsetTableLayout.MIN_COLUMNS > columns) {
      columns = InsetTableLayout.MIN_COLUMNS;
    }
    if (InsetTableLayout.MAX_COLUMNS < columns) {
      columns = InsetTableLayout.MAX_COLUMNS;
    }

    if (this._columns != columns) {
      this._columns = columns;
      this._relayout();
    }
  }

  void add(ui.Div item) {
    this._items.add(item);
    this._placeItem(item);
  }

  void remove(ui.Div item) {
    this._items.remove(item);
    this._relayout();
  }

  void _placeItem(ui.Div item) {
    if (null == this._lastRow || this._columns == this._lastRow.cells.length) {
      this._lastRow = this._layout.addRow();
    }
    this._lastRow.addCell().children = [item.x];
  }

  void _relayout() {
    this._layout.children.clear();
    this._lastRow = null;

    for (ui.Div item in this._items) {
      this._placeItem(item);
    }
  }
}