import 'package:flutter/material.dart';
import 'package:peliculas/src/models/peliculas_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  String selectionWord = '';

  final peliculasProvider = new PeliculasProvider();

  final peliculas = ['Spiderman', 'Batman', 'Aquaman', 'Superman'];

  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
      // Las acciones de nuestro
      return [
        IconButton(
          icon: Icon (Icons.clear),
          onPressed: (){
            query = '';
          },
        )
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      // Icono a la izquierda del appbar
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ), 
        onPressed: (){
          close(context, null);
        }
      );
    }
  
    @override
    Widget buildResults( BuildContext context) {
      // Crea los resultados que vamos a mostrar
      return Center(
        child: Container(
          height: 100.0,
          width: 100.0,
          color: Colors.redAccent,
          child: Text(selectionWord),
        ),
      );
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty){
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        
        if(snapshot.hasData){

          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'), 
                  image: NetworkImage(pelicula.getPosterImg()),
                  width: 50.0,
                  fit: BoxFit.contain
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  // Se le pone vacío porque el tag de la animación no puede ser vacío
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );

        } else {
          return Center(
            child: CircularProgressIndicator()
          );
        }

      },
    );

    // ---------------------------------------------- EJEMPLO DE PRUENBA ---------------------------------------------------------
    // Retorna una lista de películas que coincidan con el query "lo que escriba en el cuadro de texto"
    // final listaSugerida = query.isEmpty 
    //                     ? peliculasRecientes 
    //                     : peliculas.where((pelicula) => pelicula.toLowerCase().startsWith(query.toLowerCase())).toList();

    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (context, i){
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listaSugerida[i]),
    //       onTap: (){
    //         selectionWord = listaSugerida[i];
    //         showResults(context);
    //       },
    //     );
    //   }
    // );
  }
}