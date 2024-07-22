import 'dart:convert';

import 'package:crud_usuarios/view/cuadro_busqueda.dart';
import 'package:flutter/material.dart';
import 'package:crud_usuarios/bd/mongo_crud.dart';
import 'package:crud_usuarios/view/user_model.dart';
import 'package:crud_usuarios/view/cuadro_texto.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nombreTextEditingController = TextEditingController();
  TextEditingController edadTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  MongoCrud mongoCrud = MongoCrud();
  List<dynamic>? listaUsuarios;

  @override
  void initState() {
    fetchData();
    debugPrint('----');
    super.initState();
  }

  Future<void> fetchData() async {
    listaUsuarios = await mongoCrud.getLista('usuarios');
    jsonEncode(listaUsuarios);
    debugPrint(listaUsuarios.toString());
    setState(() {      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Operaciones CRUD')),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await mongoCrud.insertarItem(
                'usuarios',
                UserModel(
                        nombre: nombreTextEditingController.text.toString(),
                        edad: int.parse(edadTextEditingController.text),
                        email: emailTextEditingController.text.toString())
                    .toJson());
            listaUsuarios = await mongoCrud.getLista('usuarios');
            debugPrint(listaUsuarios.toString());
            setState(() {});

            nombreTextEditingController.clear();
            edadTextEditingController.clear();
            emailTextEditingController.clear();
          },
          child: const Icon(Icons.add)),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          CuadroPersonalizado(
              campoText: nombreTextEditingController, hintText: 'nombre'),
          const SizedBox(
            height: 20,
          ),
          CuadroPersonalizado(
              campoText: edadTextEditingController, hintText: 'edad'),
          const SizedBox(
            height: 20,
          ),
          CuadroPersonalizado(
              campoText: emailTextEditingController, hintText: 'email'),
          const SizedBox(height: 10),

          //* Search TextField
          CuadroBusqueda(
              onChanged: (p0) {
                setState(() {
                  mongoCrud.onSearchTextChanged(p0, listaUsuarios ?? <dynamic>[]);
                });
              },
              hintText: 'Buscar'),

          //* Search Result
          mongoCrud.resultadoBusqueda.isNotEmpty
              ? ListView.builder(
                  controller: ScrollController(),
                  shrinkWrap: true,
                  itemCount: mongoCrud.resultadoBusqueda.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title:
                            Text(mongoCrud.resultadoBusqueda[index]['nombre']),
                        subtitle: RichText(
                          text: TextSpan(
                              text: mongoCrud.resultadoBusqueda[index]
                                  ['email'],
                              style: const TextStyle(color: Colors.black),
                              children: [
                                const TextSpan(
                                    text: ' - ',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: mongoCrud.resultadoBusqueda[index]
                                            ['edad']
                                        .toString(),
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ]),
                        ),
                        trailing: Wrap(
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await mongoCrud.actualizarItem(
                                      mongoCrud.resultadoBusqueda[index]
                                          ['_id'],
                                      'usuarios',
                                      UserModel(
                                              nombre: nombreTextEditingController
                                                  .text
                                                  .toString(),
                                              edad: int.parse(
                                                  edadTextEditingController
                                                      .text),
                                              email: emailTextEditingController
                                                  .text
                                                  .toString())
                                          .toJson());
                                  listaUsuarios = await mongoCrud.getLista('usuarios');
                                  //setState(() {});
                                  fetchData();
                                },
                                icon: const Icon(Icons.update)),
                            IconButton(
                                onPressed: () async {
                                  await mongoCrud.eliminarItem(
                                      mongoCrud.resultadoBusqueda[index]
                                          ['_id'],
                                      'usuarios');
                                  listaUsuarios = await mongoCrud.getLista('usuarios');
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      ),
                    );
                  })
              //* User List
              : listaUsuarios != null
                  ? ListView.builder(
                      controller: ScrollController(),
                      shrinkWrap: true,
                      itemCount: listaUsuarios!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(listaUsuarios![index]['nombre']),
                              subtitle: RichText(
                                text: TextSpan(
                                    text: listaUsuarios![index]['email'],
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                      const TextSpan(
                                          text: ' - ',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      TextSpan(
                                          text: listaUsuarios![index]['edad']
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    ]),
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        await mongoCrud.eliminarItem(
                                            listaUsuarios![index]['_id'], 'usuarios');
                                        listaUsuarios =
                                            await mongoCrud.getLista('usuarios');
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.delete)),
                                  IconButton(
                                      onPressed: () async {
                                        await mongoCrud.actualizarItem(
                                            listaUsuarios![index]['_id'],
                                            'usuarios',
                                            UserModel(
                                                    nombre:
                                                        nombreTextEditingController
                                                            .text
                                                            .toString(),
                                                    edad: int.parse(
                                                        edadTextEditingController
                                                            .text),
                                                    email:
                                                        emailTextEditingController
                                                            .text
                                                            .toString())
                                                .toJson());
                                        listaUsuarios =
                                            await mongoCrud.getLista('usuarios');
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.update)),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : const CircularProgressIndicator()
        ]),
      ),
    );
  }
}
