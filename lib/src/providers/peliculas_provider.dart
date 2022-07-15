

import 'dart:async';

import 'package:peliculas/src/models/actores_models.dart';
import 'package:peliculas/src/models/peliculas_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PeliculasProvider {

  String _apikey = '342eb86c4d5e1d99aa3bb5e70b54803a';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  // Si se le pone broadcast, muchas personas podrán escuchar el stream, si no, sería un single stream
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  // Function(List<Pelicula>) es la regla de la función, si no petaría o tomaría dynamic pudiendo dar errores
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    // Si tiene algún valor o tiene el método close, lo llama, es decir, si tiene valor
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarResponse(Uri url) async {
    final response = await http.get( url );
    final decodedData = json.decode(response.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }


  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'     : _apikey,
      'language'    : _language
    });

    return await _procesarResponse(url);
  }

   Future<List<Pelicula>> buscarPelicula( String query ) async {

    final url = Uri.https(_url, '3/search/movie/', {
      'api_key'     : _apikey,
      'language'    : _language,
      'query'       : query
    });

    return await _procesarResponse(url);
  }

  Future<List<Actor>> getCast( String peliId) async {
 
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key'     : _apikey,
      'language'    : _language
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actores;
  }

  Future<List<Pelicula>> getPopulares() async {

    if ( _cargando ) return [];

    _cargando = true;

    _popularesPage++;

    // print('Cargando siguientes...');

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'     : _apikey,
      'language'    : _language,
      'page'        : _popularesPage.toString()
    });

    final response = await _procesarResponse(url);

    _populares.addAll(response);
    popularesSink(_populares);

    _cargando = false;
    return response;
  }




}