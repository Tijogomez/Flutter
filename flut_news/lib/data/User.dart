class User {
  String _imageUrl, _firstName, _lastname, _username, _joinDate;

  String get imageUrl => this._imageUrl;
  String get firstName => this._firstName;
  String get lastName => this._lastname;
  String get username => this._username;
  String get joinDate => this._joinDate;

  User(this._firstName, this._lastname, this._username, this._imageUrl,
      this._joinDate);
}
