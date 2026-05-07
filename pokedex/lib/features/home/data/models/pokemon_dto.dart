import 'package:json_annotation/json_annotation.dart';

part 'pokemon_dto.g.dart';

@JsonSerializable()
class PokemonDto {
  const PokemonDto({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.generation,
    required this.spriteUrl,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.summary,
    required this.typeEffects,
  });

  final int id;
  final String name;
  final int height;
  final int weight;
  final String generation;
  final String? spriteUrl;
  final List<PokemonTypeDto> types;
  final List<PokemonAbilityDto> abilities;
  final List<PokemonStatDto> stats;
  final String? summary;
  final List<TypeEffectDto> typeEffects;

  factory PokemonDto.fromJson(Map<String, dynamic> json) {
    return _$PokemonDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PokemonDtoToJson(this);
}

@JsonSerializable()
class PokemonTypeDto {
  const PokemonTypeDto({required this.name});

  final String name;

  factory PokemonTypeDto.fromJson(Map<String, dynamic> json) {
    return _$PokemonTypeDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PokemonTypeDtoToJson(this);
}

@JsonSerializable()
class PokemonAbilityDto {
  const PokemonAbilityDto({required this.name});

  final String name;

  factory PokemonAbilityDto.fromJson(Map<String, dynamic> json) {
    return _$PokemonAbilityDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PokemonAbilityDtoToJson(this);
}

@JsonSerializable()
class PokemonStatDto {
  const PokemonStatDto({required this.name, required this.baseValue});

  final String name;
  final int baseValue;

  factory PokemonStatDto.fromJson(Map<String, dynamic> json) {
    return _$PokemonStatDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PokemonStatDtoToJson(this);
}

@JsonSerializable()
class TypeEffectDto {
  const TypeEffectDto({required this.typeName, required this.damageFactor});

  final String typeName;
  final int damageFactor;

  factory TypeEffectDto.fromJson(Map<String, dynamic> json) {
    return _$TypeEffectDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TypeEffectDtoToJson(this);
}
