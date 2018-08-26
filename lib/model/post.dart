class Post {
  String _id;
  String _body;
  String _image;
  int _order;
  int _favorite;

  Post(this._id, this._body, this._image, this._order, this._favorite);

  String get id => _id;
  String get body => _body;
  String get image => _image;
  int get order => _order;
  int get favorite => _favorite;

  Post.map(dynamic obj) {
    this._id = obj['id'];
    this._body = obj['body'];
    this._image = obj['image'];
    this._order = obj['order'];
    this._favorite = obj['favorite'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['body'] = _body;
    map['image'] = _image;
    map['order'] = _order;
    map['favorite'] = _favorite;

    return map;
  }
}
