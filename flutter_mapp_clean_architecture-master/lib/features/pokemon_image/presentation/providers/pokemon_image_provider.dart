import 'package:data_connection_checker_tv/data_connection_checker.dart';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mapp_clean_architecture/core/constants/constants.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon/business/entities/pokemon_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../business/entities/pokemon_image_entity.dart';
import '../../business/usecases/get_pokemon_image.dart';
import '../../data/datasources/pokemon_image_local_data_source.dart';
import '../../data/datasources/pokemon_image_remote_data_source.dart';
import '../../data/repositories/pokemon_image_repository_impl.dart';

class PokemonImageProvider extends ChangeNotifier {
  PokemonImageEntity? pokemonImage;
  Failure? failure;

  PokemonImageProvider({
    this.pokemonImage,
    this.failure,
  });

  void eitherFailureOrPokemonImage(
      {required PokemonEntity pokemonEntity}) async {
    //create a repository from the data layer, this is the implementation of the business's repository
    PokemonImageRepositoryImpl repository = PokemonImageRepositoryImpl(
      remoteDataSource: PokemonImageRemoteDataSourceImpl(
        dio: Dio(),
      ),
      localDataSource: PokemonImageLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    /**
     * We decided if the image that will be render on the application will be big or small and accord to that
     * passed to the imageUrl variable the pokemonEntity value
     */
    String imageUrl = isShiny
        ? pokemonEntity.sprites.other.officialArtwork.frontShiny
        : pokemonEntity.sprites.other.officialArtwork.frontDefault;

    /**
     *  We use the use case, with the method call, that received a repository as argument
     *  And the call method can return a failure or an pokemon image entity
     *  Through the PokemonImageParams we send the whole information that requires the use case
     */
    final failureOrPokemonImage =
        await GetPokemonImage(pokemonImageRepository: repository).call(
      pokemonImageParams:
          PokemonImageParams(name: pokemonEntity.name, imageUrl: imageUrl),
    );

    /**
     * according with the response of the use case through the either wen can dispatch
     * a failure or the pokemonImageEntity
     */
    failureOrPokemonImage.fold(
      // if is left dispatch a failure
      (Failure newFailure) {
        pokemonImage = null;
        failure = newFailure;
        // notify the listener to refresh the screen
        notifyListeners();
      },
      // if is right dispatch a pokemonImageEntity
      (PokemonImageEntity newPokemonImage) {
        pokemonImage = newPokemonImage;
        failure = null;
        notifyListeners();
      },
    );
  }
}
