import 'dart:convert';
import 'package:fastshop/connection.dart';
import 'package:fastshop/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'dart:async';

class ListadoProvider {

  Client client = Client();
  Listado listadoNuevo = Listado();
  ListadoXCategoria listadoXCategoria = ListadoXCategoria();
  List<ListadoXCategoria> listCat;
  Categoria categoria = Categoria();

  //URL para traer los nombres de los listados del cliente logueado
  final _url = 'http://'+con.getUrl()+'/api/listado/readListName.php';
  final _urlCategory = 'http://'+con.getUrl()+'/api/listado/readListCategoryName.php';
  final _urlNewList = 'http://'+con.getUrl()+'/api/listado/insertListado.php';
  final _urlInsertCat = 'http://'+con.getUrl()+'/api/listado/insertListadoSubcategoria.php';
  final _urlInsertListXClie = 'http://'+con.getUrl()+'/api/listado/insertListadoXCliente.php';
  final _urlGetIdUser = 'http://'+con.getUrl()+'/api/cliente/readIdcliente.php';
  final _urlExistList = 'http://'+con.getUrl()+'/api/listado/getListExist.php';
  final _urlDeleteList = 'http://'+con.getUrl()+'/api/listado/deleteListadoCompra.php';

  var headers = {"accept" : "application/json"};


  //Este es nuestro metodo para mandarle el usuario activo y que devuelva los nombres de los listados
  Future<List<Listado>> fetchUserListNames(var user) async {
    final response = await client.get(_url+"?username=$user");
    if (response.statusCode == 200) {
      print(response.body);
      return compute(listadoFromJson, response.body);

    } else {
      throw Exception('Error trayendo listado de compras');
    }
  }

  //Este es nuestro metodo para mandarle el id de la lista seleccionada y que devuelva los productos
  Future<List<ListCategory>> fetchListCategoryNames(var id) async {
    final response = await client.get(_urlCategory+"?idListado=$id");
    if (response.statusCode == 200) {
      print(response.body);
      return compute(listCategoriesFromJson, response.body);
    } else {
      throw Exception('Error en carga');
    }
  }

  //Metodo para borrar el listado con sus 3 tablas
  Future<List<Listado>> deleteList(idListado) async {
    await Future.delayed(Duration(seconds: 1));
    final response = await client.post(_urlDeleteList+"?idListado=$idListado");
    if (response.statusCode == 200) {
      //Eliminado
    } else {
      throw new Exception('El listado no se borro!');
    }
  }

  Future<bool> deleteUserList({
    @required String idListado,
  }) async {

    await Future.delayed(Duration(seconds: 1));
    final response = await client.post(_urlDeleteList+"?idListado=$idListado");
    if (response.statusCode == 400) {
      return false;
    }
    return true;
  }


  //Para agregar el nombre de una lista de compra (PRIMERA TABLA)
  Future<List<Listado>> addList(nombre, selected, user) async {
    var body = {'nombre': nombre};
    await Future.delayed(Duration(seconds: 1));
    final response = await client.post(_urlNewList, body: jsonEncode(body));
    if (response.statusCode == 200) {
      List<Listado> listado = listadoFromJson(response.body);
      listCat = listadoXCategoria.createListXCate(listado[0].idListado, selected);
      await addCategories(listCat, user);
      String idCliente = await getIdClien(user);
      await addListXClien(listado[0].idListado, idCliente);
      return listado;
    } else {
      throw new Exception('El nombre ya existe!');
    }
  }

  //Luego de agregar el nombre, agregamos las categorias de una lista de compra (SEGUNDA TABLA)
  Future addCategories(listCat, user) async {
    var body = jsonEncode(listCat);
    await Future.delayed(Duration(seconds: 1));
    final response = await client.post(_urlInsertCat, body: body);
    if (response.statusCode == 200) {
      var id = jsonDecode(response.body);
      return id;
    } else {
      throw new Exception('No se agregaron categorias');
    }
  }

  //Luego de agregar las subcategorias agregamos el cliente con listado (TERCERA TABLA)
  Future<String> getIdClien(user) async {
    final responseId = await client.get(_urlGetIdUser+"?username=$user");
    if (responseId.statusCode == 200) {
      return jsonDecode(responseId.body);
    } else {
      throw new Exception('No se encontro el id');
    }
  }

  //Luego de agregar las subcategorias agregamos el cliente con listado (TERCERA TABLA)
  Future addListXClien(idListado, idCliente) async {
    var body = jsonEncode({'idListado': idListado, 'idCliente': idCliente});
    print(body);
    await Future.delayed(Duration(seconds: 1));
    final response = await client.post(_urlInsertListXClie, body: body);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw new Exception('No se agregaron clientes x listados');
    }
  }

  Future<List<Listado>> fetchExistList(var idListado) async {
    final response = await client.get(_urlExistList+"?idListado=$idListado");
    if (response.statusCode == 200) {
      var exist = jsonDecode(response.body);
      return exist;
    } else {
      throw Exception('Verificar carga de usuario');
    }
  }

/*
  Future updateInsert(ids) async {
    print('$_url$ids/update');
    final response = await client.put("$_url$ids/update", body: {'done': "true"});
    if (response.statusCode == 200) {
      print('berhasil di update');
      return response;
    } else {
      throw Exception('Failed to update data');
    }
  }*/

}

