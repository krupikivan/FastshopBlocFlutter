import 'dart:convert';

import 'package:fastshop/connection.dart';
import 'package:fastshop/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Client;
import 'dart:async';

class ProductoProvider {

  Client client = Client();
  final _url = 'http://'+con.getUrl()+'/api/producto/readProductList.php';
  final _urlScann = 'http://'+con.getUrl()+'/api/producto/readBarcode.php';

  Future<List<Producto>> fetchProductList() async {
    final response = await client.get(_url);
    if (response.statusCode == 200) {
      print(response.body);
      return compute(productoFromJson, response.body);

    } else {
      throw Exception('Error en carga');
    }
  }

  Future<Producto> fetchProductScanned(barcode) async {
    final response = await client.get(_urlScann+"?codigo=$barcode");
    if (response.statusCode == 200) {
      //TODO solucionar error de compatibilidad mapa con lista
      Map productMap = jsonDecode(response.body);
      return Producto.fromJson(productMap);
    } else {
      throw Exception('Error en carga');
    }
  }

}

