import 'package:pokedex/features/home/domain/entities/pokemon.dart';
import 'package:pokedex/features/home/domain/repositories/pokemon_repository.dart';

class GetPokemonList {
  const GetPokemonList(this.repository);

  final PokemonRepository repository;

  Future<List<Pokemon>> cached({required int limit, required int offset}) {
    return repository.getCachedPokemonList(limit: limit, offset: offset);
  }

  Future<List<Pokemon>> refresh({required int limit, required int offset}) {
    return repository.refreshPokemonList(limit: limit, offset: offset);
  }
}
