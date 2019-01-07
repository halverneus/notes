part of Page;

class CardPage extends Page {
  static const _PADDING = 60;
  static const _TWO_COLUMN_MIN =
      CardPage._PADDING + (280 * 2) + 150;

  html.TableSectionElement _layout;

  var _cards = new List<ui.Div>();
  var _columns = new List<html.TableCellElement>();
  var _lastCount = 0;

  CardPage({ui.Icon icon, String text}) : super(icon: icon, text: text) {
    var table = new html.TableElement();
    this.content.children.add(table);

    this._layout = table.createTBody();

    html.window.onResize.listen(this.handleResize);
  }

  void addCard(ui.Div card) {
    this._cards.add(card);
    this.handleResize();
  }

  void removeCard(ui.Div card) {
    this._cards.remove(card);
    this.handleResize();
  }

  void _appendCardToLayout(ui.Div card) {
    html.TableCellElement targetSection;
    for (var section in this._columns) {
      if (
        null == targetSection || 
        targetSection.children.length > section.children.length
      ) {
        targetSection = section;
      }
    }
    targetSection.children.add(card.x);
  }

  void _relayoutCards(int columns) {
    // Recreate the column layout.
    this._layout.children.clear();
    this._columns.clear();
    var row = this._layout.addRow();
    for (var i=0; i<columns; i++) {
      var cell = row.addCell();
      cell.classes = ["page"];
      this._columns.add(cell);
    }

    // Re-add the cards to the column layout.
    for (var card in this._cards) {
      this._appendCardToLayout(card);
    }
  }

  void handleResize([_]) {
    var expectedColumnCount = 1;
    var width = html.window.innerWidth;
    if (CardPage._TWO_COLUMN_MIN < width) {
      expectedColumnCount = 2;
    }

    if (this._cards.length != this._lastCount) {
      this._lastCount = this._cards.length;
      this._relayoutCards(expectedColumnCount);
    } else if (this._columns.length != expectedColumnCount) {
      this._relayoutCards(expectedColumnCount);
    }
  }
}
