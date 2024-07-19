import 'package:mongo_dart/mongo_dart.dart';

abstract class MongoProvider<T> {
  Future<Db> open(String nombreColeccion);
  Future<void> close();
  Future<void> insertarItem(String nombreColeccion, Map<String, dynamic> documento);
  Future<void> eliminarItem(ObjectId id, String nombreColeccion);
  Future<void> actualizarItem(ObjectId id, String nombreColeccion, T documento);
  Future<List<T?>> getLista(String nombreColeccion);
    void onSearchTextChanged(String searchText, 
  List<dynamic> collectionList) ;
}
