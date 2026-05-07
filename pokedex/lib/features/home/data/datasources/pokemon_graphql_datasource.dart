import 'dart:convert';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/features/home/data/models/pokemon_dto.dart';

class PokemonGraphqlDatasource {
  PokemonGraphqlDatasource(this.client);

  final GraphQLClient client;

  Future<List<PokemonDto>> fetchPokemonList({
    required int limit,
    required int offset,
    required FetchPolicy fetchPolicy,
  }) async {
    final options = QueryOptions(
      document: gql(_pokemonListQuery),
      variables: <String, dynamic>{'limit': limit, 'offset': offset},
      fetchPolicy: fetchPolicy,
    );

    final result = await client.query(options);
    if (result.hasException) {
      if (fetchPolicy == FetchPolicy.cacheOnly) {
        return <PokemonDto>[];
      }
      log('GraphQL error', error: result.exception);
      throw Exception(result.exception.toString());
    }

    final data =
        result.data?['pokemon_v2_pokemon'] as List<dynamic>? ?? <dynamic>[];

    return data.whereType<Map<String, dynamic>>().map(_mapPokemon).toList();
  }

  PokemonDto _mapPokemon(Map<String, dynamic> pokemon) {
    final spritesList = pokemon['pokemon_v2_pokemonsprites'] as List<dynamic>?;
    final spriteValue = spritesList?.isNotEmpty == true
        ? spritesList?.first['sprites']
        : null;
    final spriteUrl = _extractSpriteUrl(spriteValue);

    final types = _mapTypes(pokemon);
    final abilities = _mapAbilities(pokemon);
    final stats = _mapStats(pokemon);
    final typeEffects = _mapTypeEffects(pokemon);
    final summary = _mapSummary(pokemon);
    final generation = _mapGeneration(pokemon);

    final dtoMap = <String, dynamic>{
      'id': pokemon['id'] as int? ?? 0,
      'name': pokemon['name'] as String? ?? 'unknown',
      'height': pokemon['height'] as int? ?? 0,
      'weight': pokemon['weight'] as int? ?? 0,
      'generation': generation,
      'spriteUrl': spriteUrl,
      'types': types,
      'abilities': abilities,
      'stats': stats,
      'summary': summary,
      'typeEffects': typeEffects,
    };

    return PokemonDto.fromJson(dtoMap);
  }

  List<Map<String, dynamic>> _mapTypes(Map<String, dynamic> pokemon) {
    final types =
        pokemon['pokemon_v2_pokemontypes'] as List<dynamic>? ?? <dynamic>[];

    return types.map((type) => type as Map<String, dynamic>).map((type) {
      final typeData = type['pokemon_v2_type'] as Map<String, dynamic>?;
      return <String, dynamic>{
        'name': typeData?['name'] as String? ?? 'unknown',
      };
    }).toList();
  }

  List<Map<String, dynamic>> _mapAbilities(Map<String, dynamic> pokemon) {
    final abilities =
        pokemon['pokemon_v2_pokemonabilities'] as List<dynamic>? ?? <dynamic>[];

    return abilities.map((ability) => ability as Map<String, dynamic>).map((
      ability,
    ) {
      final abilityData =
          ability['pokemon_v2_ability'] as Map<String, dynamic>?;
      return <String, dynamic>{
        'name': abilityData?['name'] as String? ?? 'unknown',
      };
    }).toList();
  }

  List<Map<String, dynamic>> _mapStats(Map<String, dynamic> pokemon) {
    final stats =
        pokemon['pokemon_v2_pokemonstats'] as List<dynamic>? ?? <dynamic>[];

    return stats.map((stat) => stat as Map<String, dynamic>).map((stat) {
      final statData = stat['pokemon_v2_stat'] as Map<String, dynamic>?;
      return <String, dynamic>{
        'name': statData?['name'] as String? ?? 'unknown',
        'baseValue': stat['base_stat'] as int? ?? 0,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _mapTypeEffects(Map<String, dynamic> pokemon) {
    final types =
        pokemon['pokemon_v2_pokemontypes'] as List<dynamic>? ?? <dynamic>[];

    final effects = <Map<String, dynamic>>[];
    for (final type in types) {
      final typeData =
          (type as Map<String, dynamic>)['pokemon_v2_type']
              as Map<String, dynamic>?;
      final efficacies =
          typeData?['pokemon_v2_typeefficacies'] as List<dynamic>? ??
          <dynamic>[];

      for (final efficacy in efficacies) {
        final efficacyData = efficacy as Map<String, dynamic>;
        final targetType =
            efficacyData['pokemonV2TypeByTargetTypeId']
                as Map<String, dynamic>?;
        effects.add(<String, dynamic>{
          'typeName': targetType?['name'] as String? ?? 'unknown',
          'damageFactor': efficacyData['damage_factor'] as int? ?? 100,
        });
      }
    }

    return effects;
  }

  String? _mapSummary(Map<String, dynamic> pokemon) {
    final species = pokemon['pokemon_v2_pokemonspecy'] as Map<String, dynamic>?;
    final flavorTexts =
        species?['pokemon_v2_pokemonspeciesflavortexts'] as List<dynamic>? ??
        <dynamic>[];

    if (flavorTexts.isEmpty) {
      return null;
    }

    final text = flavorTexts.first as Map<String, dynamic>;
    final raw = text['flavor_text'] as String?;
    return raw?.replaceAll('\n', ' ').replaceAll('\f', ' ');
  }

  String _mapGeneration(Map<String, dynamic> pokemon) {
    final species = pokemon['pokemon_v2_pokemonspecy'] as Map<String, dynamic>?;
    final generation =
        species?['pokemon_v2_generation'] as Map<String, dynamic>?;
    return generation?['name'] as String? ?? 'unknown';
  }

  String? _extractSpriteUrl(dynamic spriteJson) {
    if (spriteJson == null) {
      return null;
    }

    try {
      final decoded = spriteJson is String
          ? jsonDecode(spriteJson) as Map<String, dynamic>
          : spriteJson as Map<String, dynamic>;
      final other = decoded['other'] as Map<String, dynamic>?;
      final official = other?['official-artwork'] as Map<String, dynamic>?;
      final url = official?['front_default'] as String?;
      return url ?? decoded['front_default'] as String?;
    } catch (error) {
      log('Failed to parse sprite JSON', error: error);
      return null;
    }
  }
}

const String _pokemonListQuery = r'''
query PokemonList($limit: Int!, $offset: Int!) {
  pokemon_v2_pokemon(limit: $limit, offset: $offset, order_by: {id: asc}) {
    id
    name
    height
    weight
    pokemon_v2_pokemonsprites {
      sprites
    }
    pokemon_v2_pokemonabilities {
      pokemon_v2_ability {
        name
      }
    }
    pokemon_v2_pokemontypes {
      pokemon_v2_type {
        name
        pokemon_v2_typeefficacies {
          damage_factor
          pokemonV2TypeByTargetTypeId {
            name
          }
        }
      }
    }
    pokemon_v2_pokemonstats {
      base_stat
      pokemon_v2_stat {
        name
      }
    }
    pokemon_v2_pokemonspecy {
      pokemon_v2_generation {
        name
      }
      pokemon_v2_pokemonspeciesflavortexts(
        where: {language_id: {_eq: 9}},
        limit: 1,
        order_by: {version_id: desc}
      ) {
        flavor_text
      }
    }
  }
}
''';
