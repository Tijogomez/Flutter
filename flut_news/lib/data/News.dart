class News {
  String _title, _author, _content, _imageUrl;
  bool _isFavourite = false;

  bool get isFavourite => this._isFavourite;

  set isFavourite(bool value) => this._isFavourite = value;

  String get title => this._title;
  String get author => this._author;
  String get content => this._content;
  String get imageUrl => this._imageUrl;

  News(this._title, this._author, this._content, this._imageUrl);
}
