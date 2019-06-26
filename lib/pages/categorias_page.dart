import 'package:fastshop/blocs/home/categoria_bloc.dart';
import 'package:fastshop/models/models.dart';
import 'package:flutter/material.dart';

import 'listados/new_list_details.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoryPageState(
    );
  }
}

class _CategoryPageState extends State<CategoryPage> {

  TextEditingController searchController = new TextEditingController();
  String filter;

  List<Categoria> selected;

  @override
  void initState() {
    selected = new List();
    bloc_categories_name.fetchAllTodo();
    searchController.addListener((){
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }
  @override
  void dispose() {
    searchController.dispose();
    bloc_categories_name.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: new Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  labelText: "Buscar",
                  hintText: "Buscar",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
                  StreamBuilder(
                    stream: bloc_categories_name.allTodo,
                    builder: (context, AsyncSnapshot<List<Categoria>> snapshot) {
                      if (snapshot.hasData) {
                        //Aca largamos la lista a la pantalla
                            return buildList(snapshot);
                      } else if (snapshot.hasError) {
                        return Text('Error es:${snapshot.error}');
                      }
                      return Center(child: CircularProgressIndicator());
                    }
                  ),
          Expanded(
            flex: 2,
            child: Scaffold(
                floatingActionButton: FloatingActionButton.extended(onPressed: (){createList();}, backgroundColor: Colors.blueAccent, icon: Icon(Icons.add), label: Text('Nuevo'))
            ),
          ),
        ],
      ),
    );
  }

  createList(){
    if(selected.isEmpty){
      return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error!'),
            content: const Text(
                'Debe seleccionar al menos un elemento para poder crear un listado'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    else {
      Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return NewListDetails(
            selected: selected,
          );
        }),
      );
    }
  }

  Widget buildList(AsyncSnapshot<List<Categoria>> snapshot) {
    return new Expanded(
      flex: 8,
      child: ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          if(filter == null || filter == ""){
            return new ListTile(
                trailing: InkWell(
                    onTap: () {
                      selected.contains(snapshot.data[index]) ? makeUnCheck(snapshot.data[index])
                          : makeCheck(snapshot.data[index]);
                    },
                    child: (selected.contains(snapshot.data[index])) ?
                    Icon(Icons.check_circle, color: Colors.green, size: 35.0,) :
                    Icon(Icons.check_circle, size: 35.0,)
                ),
                title: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),//EdgeInsets.all(8.0),
                              child: new Text(snapshot.data[index].descripcion),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      height: 2.0,
                      color: Colors.grey,
                    )
                  ],
                )
            );
          }
          if(snapshot.data[index].descripcion.toLowerCase().contains(filter.toLowerCase())){
            return new ListTile(
                trailing: InkWell(
                    onTap: () {
                      selected.contains(snapshot.data[index]) ? makeUnCheck(snapshot.data[index])
                          : makeCheck(snapshot.data[index]);
                    },
                    child: (selected.contains(snapshot.data[index])) ?
                    Icon(Icons.check_circle, color: Colors.green, size: 35.0,) :
                    Icon(Icons.check_circle, size: 35.0,)
                ),
                title: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),//EdgeInsets.all(8.0),
                              child: new Text(snapshot.data[index].descripcion),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      height: 2.0,
                      color: Colors.grey,
                    )
                  ],
                )
            );
          }
          else{
            return new Container(
            );
          }
        },
      ),
    );
  }


  makeCheck(var snapshot) {
    // operations to be performed
    // end of operations to be performed
    setState(() {
      selected.add(snapshot);
    });
  }

  makeUnCheck(var snapshot) {
    // operations to be performed
    // end of operations to be performed
    setState(() {
      selected.remove(snapshot);
    });
  }

}