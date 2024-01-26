import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/params/params.dart';
import '../../../../core/constants/constants.dart';
import '../models/pokemon_image_model.dart';
import 'package:path_provider/path_provider.dart';

abstract class PokemonImageRemoteDataSource {
  Future<PokemonImageModel> getPokemonImage(
      {required PokemonImageParams pokemonImageParams});
}

class PokemonImageRemoteDataSourceImpl implements PokemonImageRemoteDataSource {
  final Dio dio;

  PokemonImageRemoteDataSourceImpl({required this.dio});

  @override
  Future<PokemonImageModel> getPokemonImage(
      {required PokemonImageParams pokemonImageParams}) async {
    // gave us the location where we can save the pokemon image
    Directory directory = await getApplicationDocumentsDirectory();
    //deletes any data saved in the directory of the application
    directory.deleteSync(recursive: true);
    // define what will be the path associated to the pokemon image that we want to save in the local application
    final String pathFile = '${directory.path}/${pokemonImageParams.name}.png}';

    final response = await dio.download(
      // the location of the image we want to download {www}
      pokemonImageParams.imageUrl,
      pathFile, // the path to store
    );

    if (response.statusCode == 200) {
      // save the image locally
      return PokemonImageModel.fromJson(json: {kPath: pathFile});
    } else {
      throw ServerException();
    }
  }
}
