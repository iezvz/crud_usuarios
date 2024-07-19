import 'package:crud_usuarios/bd/constantes.dart';
import 'package:crud_usuarios/bd/mongo_provider.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter/material.dart';

class MongoCrud extends MongoProvider {
  Db? db;
  List resultadoBusqueda = [];

  /// metodos
  @override
  // abrir coneccion a base de datos y asignar nombre de la coleccion
  Future<Db> open(String nombreColeccion) async {
    try {
      db = await Db.create(CONECCION);
      await db!.open();
      db!.collection(nombreColeccion);
      debugPrint('Base de datos conectada');
      return db!;
    } catch (e) {
      debugPrint('+error+ ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> close() {
    try {
      db!.close();
      debugPrint('base de datos cerrada con exito');
    } catch (e) {
      debugPrint('error de cerrado ${e.toString()}');
    }
    return Future.value();
  }

  @override
  Future<void> insertarItem(
      String nombreColeccion, Map<String, dynamic> documento) async {
    try {
      await open(nombreColeccion);
      await db!.collection(nombreColeccion).insert(documento);
      debugPrint('documento agregado con exito');
    } catch (e) {
      debugPrint('error de insercion ${e.toString()}');
    }
  }

  @override
  Future<void> eliminarItem(ObjectId id, String nombreColeccion) async {
    try {
      await open(nombreColeccion);
      await db!.collection(nombreColeccion).remove(where.id(id));
      debugPrint('documento eliminado con exito');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> actualizarItem(
      ObjectId id, String nombreColeccion, documento) async {
    try {
      await open(nombreColeccion);
      await db!.collection(nombreColeccion).update(where.id(id), documento);
      debugPrint('documento actualizado con exito');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List> getLista(String nombreColeccion) async {
    try {
      await open(nombreColeccion);
      var listaUsuarios = await db!.collection(nombreColeccion).find().toList();
      debugPrint('documento encontrado');
      return listaUsuarios;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  void onSearchTextChanged(String searchText, List<dynamic> collectionList) {
    debugPrint('.......');
    resultadoBusqueda.clear();
    if (searchText.isEmpty) {
      resultadoBusqueda = [];
    }

    resultadoBusqueda = collectionList
        .where((element) => element['nombre']
            .toString()
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
  }
}
