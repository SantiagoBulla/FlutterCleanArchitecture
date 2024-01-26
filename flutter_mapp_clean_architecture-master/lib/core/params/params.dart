class NoParams {}

class TemplateParams {}

class PokemonParams {
  final String id;

  const PokemonParams({
    required this.id,
  });
}

class PokemonImageParams {
  final String name;
  final String imageUrl;
  PokemonImageParams({required this.name, required this.imageUrl});
}
