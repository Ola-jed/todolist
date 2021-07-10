/// Serializable objects for api communication
abstract class Serializable{
  Serializable();
  Serializable.fromJson(final Map<String,dynamic> json);
  Map<String,dynamic> toJson();
}