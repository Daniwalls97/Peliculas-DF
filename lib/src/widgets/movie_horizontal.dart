import 'package:flutter/material.dart';
import 'package:peliculas/src/models/peliculas_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({ @required this.peliculas, @required this.siguientePagina });

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3 
  );

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() { 
      if( _pageController.position.pixels >= _pageController.position.maxScrollExtent - 200 ){
        siguientePagina();
      }
     });

    return Container(
      
      height: _screenSize.height * 0.25,
      //  PageView.builder es mejor que PageView, solo crea cuando haga falta
      child: PageView.builder(
        pageSnapping: false,
        // scrollDirection: Axis.horizontal,
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context, i){
          return _tarjeta(context, peliculas[i]);
        },
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula p){

    p.uniqueId = '${ p.id }-poster';

    final tarjeta = Container(
        margin: EdgeInsets.only(right: 15.0),
        // Tuve que poner el column dentro de SingleChildScrollView, porque daba render error
        // child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Hero(
                  tag: p.uniqueId,
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'), 
                    image: NetworkImage( p.getPosterImg()),
                    fit: BoxFit.cover,
                    height: 160.0,
                  ),
                ),
              ),
              SizedBox(height: 5.0,),
              Text(
                p.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
        // ),
        );

      return GestureDetector(
        child: tarjeta,
        onTap: (){
          
          Navigator.pushNamed(context, 'detalle', arguments: p);

        },
      );
    }

  // List<Widget> _tarjetas(BuildContext context){

  //   return peliculas.map((p){
  //     _tarjeta(context, p);
  //   }).toList();

  // }
}