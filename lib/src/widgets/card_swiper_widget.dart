import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/peliculas_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;

  CardSwiper({ @required this.peliculas });

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      
      padding: EdgeInsets.only(top: 10.0),
      child: new Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width * 0.7,
          itemHeight: _screenSize.height * 0.5,
          itemBuilder: (BuildContext context,int index){

            peliculas[index].uniqueId = '${ peliculas[index].id }-tarjeta';

            // Hero es la animación
            return Hero(
                tag: peliculas[index].uniqueId,
                child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  child: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'), 
                    image: NetworkImage( peliculas[index].getPosterImg() ),
                    fit: BoxFit.cover,                  
                  ),
                  onTap: (){        
                    Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]);
                  },
                )
                // new Image.network("http://via.placeholder.com/350x150", fit: BoxFit.cover,),
                // child: Text (peliculas[index].toString())
              ),
            ); 
          },
          itemCount: peliculas.length,
          // pagination -> puntitos de abajo, indicando en cual estás
          // pagination: new SwiperPagination(), 
          // control -> las flechitas para cambiar de 'page'
          // control: new SwiperControl(),
        ),
    );
  }
}