import 'package:fastshop/functions/getUsername.dart';
import 'package:fastshop/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fastshop/blocs/home/listado_bloc.dart';

import 'listado_details.dart';

class LisCompra extends StatelessWidget {

 // var user;

  //LisCompra({this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListadoCompras(),
    );
  }
}

class ListadoCompras extends StatefulWidget {

  //var user;
  //ListadoCompras(this.user, {Key key}) : super(key: key);
  @override
  ListadoComprasState createState() => ListadoComprasState();
}


class ListadoComprasState extends State<ListadoCompras> {

  var user;

  Future<void> fetchListados() async {
    user = await getUsername();
    await bloc.fetchAllListados(user);
  }

  @override
  void initState() {
    super.initState();
    //Trae solamente los nombres de los listados
    fetchListados();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        //Estamos escuchando al stream,
        //cuando el valor sale afuera del stream largamos la lista por pantalla
        stream: bloc.allListNames,
        builder: (context, AsyncSnapshot<List<Listado>> snapshot) {
          if (snapshot.hasData) {
            //Aca largamos la lista a la pantalla
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text('Error es:${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
        floatingActionButton: FloatingActionButton.extended(onPressed: null, backgroundColor: Colors.blueAccent, icon: Icon(Icons.add), label: Text('Nuevo'))
    );
  }

  Widget buildList(AsyncSnapshot<List<Listado>> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: InkResponse(
              enableFeedback: true,
              child: new Container(
                  alignment: Alignment.centerLeft,
                  margin: new EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 10.0),
                  child: new Text(snapshot.data[index].nombre)
              ),
              onTap: () => openDetailListPage(snapshot.data, index),
          ),
        );
      },
    );
  }

  openDetailListPage(List<Listado> data, int index) {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) {
        return ListDetail(
          nombre: data[index].nombre,
          idListado: data[index].idListado,
        );
      }),
    );
  }
}