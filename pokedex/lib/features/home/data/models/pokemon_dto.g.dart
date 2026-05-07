// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_dto.dart';

PokemonDto _$PokemonDtoFromJson(Map<String, dynamic> json) => PokemonDto(
  id: json['id'] as int,
  name: json['name'] as String,
  height: json['height'] as int,
  weight: json['weight'] as int,
  generation: json['generation'] as String? ?? 'unknown',
  spriteUrl: json['spriteUrl'] as String?,
  types: (json['types'] as List<dynamic>)
      .map((e) => PokemonTypeDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  abilities: (json['abilities'] as List<dynamic>)
      .map((e) => PokemonAbilityDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  stats: (json['stats'] as List<dynamic>)
      .map((e) => PokemonStatDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  summary: json['summary'] as String?,
  typeEffects: (json['typeEffects'] as List<dynamic>)
      .map((e) => TypeEffectDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PokemonDtoToJson(PokemonDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'height': instance.height,
      'weight': instance.weight,
      'generation': instance.generation,
      'spriteUrl': instance.spriteUrl,
      'types': instance.types.map((e) => e.toJson()).toList(),
      'abilities': instance.abilities.map((e) => e.toJson()).toList(),
      'stats': instance.stats.map((e) => e.toJson()).toList(),
      'summary': instance.summary,
      'typeEffects': instance.typeEffects.map((e) => e.toJson()).toList(),
    };

PokemonTypeDto _$PokemonTypeDtoFromJson(Map<String, dynamic> json) =>
    PokemonTypeDto(name: json['name'] as String);

Map<String, dynamic> _$PokemonTypeDtoToJson(PokemonTypeDto instance) =>
    <String, dynamic>{'name': instance.name};

PokemonAbilityDto _$PokemonAbilityDtoFromJson(Map<String, dynamic> json) =>
    PokemonAbilityDto(name: json['name'] as String);

Map<String, dynamic> _$PokemonAbilityDtoToJson(PokemonAbilityDto instance) =>
    <String, dynamic>{'name': instance.name};

PokemonStatDto _$PokemonStatDtoFromJson(Map<String, dynamic> json) =>
    PokemonStatDto(
      name: json['name'] as String,
      baseValue: json['baseValue'] as int,
    );

Map<String, dynamic> _$PokemonStatDtoToJson(PokemonStatDto instance) =>
    <String, dynamic>{'name': instance.name, 'baseValue': instance.baseValue};

TypeEffectDto _$TypeEffectDtoFromJson(Map<String, dynamic> json) =>
    TypeEffectDto(
      typeName: json['typeName'] as String,
      damageFactor: json['damageFactor'] as int,
    );

Map<String, dynamic> _$TypeEffectDtoToJson(TypeEffectDto instance) =>
    <String, dynamic>{
      'typeName': instance.typeName,
      'damageFactor': instance.damageFactor,
    };
