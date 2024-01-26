import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon_image/business/entities/pokemon_image_entity.dart';
import 'package:provider/provider.dart';

import '../../../../../core/errors/failure.dart';
import '../providers/pokemon_image_provider.dart';

class PokemonImageWidget extends StatelessWidget {
  const PokemonImageWidget({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    /**
     * we create instances of the two options that return the call method of the use cases
     * if the response is an pokemonEntity we could use the first option, but if not we could use
     * the failure one
     */
    PokemonImageEntity? pokemonImageEntity =
        Provider.of<PokemonImageProvider>(context).pokemonImage;
    Failure? failure = Provider.of<PokemonImageProvider>(context).failure;

    late Widget widget;
    /**
     * Create the widget logic, if the entity is true the application will show the pokemon image
     * if the pokemon image is false, then evaluate if exist any error and if is true, the app
     * will show an message error
     * But if any of the previous options is true that means that the image are loading therefore the
     * application will show an loading widget
     */
    if (pokemonImageEntity != null) {
      widget = Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.orange,
            image: DecorationImage(
              image: FileImage(File(pokemonImageEntity.path)),
            ),
          ),
          child: child,
        ),
      );
    } else if (failure != null) {
      widget = Expanded(
        child: Center(
          child: Text(failure.errorMessage, style: TextStyle(fontSize: 20)),
        ),
      );
    } else {
      widget = const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return widget;
  }
}
