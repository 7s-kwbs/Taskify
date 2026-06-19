


class Todo {
  String title;
  bool done;
  bool selected;

  Todo({
    required this.title,
    this.done = false,
    this.selected = false,
  });


Map<String, dynamic> toJson(){
  return{
    "title":title,
    "done" :done,
    "selected": selected,
  };
}

factory Todo.fromJson(Map<String, dynamic> json){
  return Todo(title: json['title'] ?? "",
  done: json["done"] ?? false,
  selected: json["selected"] ?? false);
}

}
