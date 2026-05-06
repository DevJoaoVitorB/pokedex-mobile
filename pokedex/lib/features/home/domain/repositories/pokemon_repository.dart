import 'package:pokedex/features/home/domain/entities/pokemon.dart';

abstract class PokemonRepository {
  Future<List<Pokemon>> getCachedPokemonList({
    required int limit,
    required int offset,
  });

  Future<List<Pokemon>> refreshPokemonList({
    required int limit,
    required int offset,
  });
}
