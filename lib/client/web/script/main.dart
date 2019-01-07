import 'dart:async' as async;
import 'dart:html' as html;

import 'package:notes/data/import.dart' as info;

import 'package:notes/ui/widget/display/import.dart' as ui;
import 'package:notes/ui/widget/icon/import.dart' as ui;
import 'package:notes/ui/widget/menu/import.dart' as ui;
import 'package:notes/ui/widget/page/import.dart' as ui;

import 'package:notes/ui/view/note/import.dart' as view;

class App {
  final _data = new info.Data();
  final _display = new ui.Display();
  final _menu = new ui.Menu();

  App() {
    html.document.body.children = [this._display.x];

    this._setupPages();

    this._display.headerText = "Notes";
    this._display.menu = this._menu;
    this._display.menuEnabled = false;

    new async.Timer(new Duration(milliseconds: 20), () {
      this._display.menuEnabled = true;
    });
  }

  void setPage(ui.Page page) {
    this._display.setPage(page, ui.Transition.NONE);
  }

  void _setupPages() {
    var notes = new ui.IconMenuItem(ui.Icons.INSERT_DRIVE_FILE, "Notes");
    notes.onClick.listen((_) {
      this.setPage(new view.Note(this._data));
    });

    this._menu.addToTop(notes);

    notes.select();
    this.setPage(new view.Note(this._data));
  }
}

void main() {
  new App();
}