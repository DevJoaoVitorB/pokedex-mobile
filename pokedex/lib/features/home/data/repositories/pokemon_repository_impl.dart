import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/features/home/data/datasources/pokemon_graphql_datasource.dart';
import 'package:pokedex/features/home/data/models/pokemon_dto.dart';
import 'package:pokedex/features/home/domain/entities/pokemon.dart';
import 'package:pokedex/features/home/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  const PokemonRepositoryImpl(this.datasource);

  final PokemonGraphqlDatasource datasource;

  @override
  Future<List<Pokemon>> getCachedPokemonList({
    required int limit,
    required int offset,
  }) async {
    final dtoList = await datasource.fetchPokemonList(
      limit: limit,
      offset: offset,
      fetchPolicy: FetchPolicy.cacheOnly,
    );

    return dtoList.map(_toEntity).toList();
  }

  @override
  Future<List<Pokemon>> refreshPokemonList({
    required int limit,
    required int offset,
  }) async {
    final dtoList = await datasource.fetchPokemonList(
      limit: limit,
      offset: offset,
      fetchPolicy: FetchPolicy.networkOnly,
    );

    return dtoList.map(_toEntity).toList();
  }

  Pokemon _toEntity(PokemonDto dto) {
    final weaknesses = dto.typeEffects
        .where((effect) => effect.damageFactor > 100)
        .map(
          (effect) => TypeEffect(
            typeName: effect.typeName,
            damageFactor: effect.damageFactor,
          ),
        )
        .toList();
    final resistances = dto.typeEffects
        .where((effect) => effect.damageFactor < 100)
        .map(
          (effect) => TypeEffect(
            typeName: effect.typeName,
            damageFactor: effect.damageFactor,
          ),
        )
        .toList();

    return Pokemon(
      id: dto.id,
      name: dto.name,
      height: dto.height,
      weight: dto.weight,
      generation: dto.generation,
      spriteUrl: dto.spriteUrl,
      types: dto.types.map((type) => PokemonType(name: type.name)).toList(),
      abilities: dto.abilities
          .map((ability) => PokemonAbility(name: ability.name))
          .toList(),
      stats: dto.stats
          .map(
            (stat) => PokemonStat(name: stat.name, baseValue: stat.baseValue),
          )
          .toList(),
      summary: dto.summary,
      weaknesses: weaknesses,
      resistances: resistances,
    );
  }
}
