part of Controller;

class Controller {
  Note note;

  final model.Model _model;

  Controller(model.Model this._model) {
    this.note = new Note(this._model);
  }
}