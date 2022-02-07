abstract class NewsEvents {}

class NewsCategoryChanged extends NewsEvents {
  int index = 0;
  NewsCategoryChanged(this.index);
}

class SearchQueryChanged extends NewsEvents {
  String query = "";
  SearchQueryChanged(this.query);
}
