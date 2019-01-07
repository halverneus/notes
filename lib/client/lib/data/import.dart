library Data;

import 'controller/import.dart';
import 'model/import.dart';

class Data {
  Controller controller;
  Model model = new Model();

  Data() {
    this.controller = new Controller(this.model);
  }
}
