class Pokemon {
  const Pokemon({
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
    required this.weaknesses,
    required this.resistances,
  });

  final int id;
  final String name;
  final int height;
  final int weight;
  final String generation;
  final String? spriteUrl;
  final List<PokemonType> types;
  final List<PokemonAbility> abilities;
  final List<PokemonStat> stats;
  final String? summary;
  final List<TypeEffect> weaknesses;
  final List<TypeEffect> resistances;
}

class PokemonType {
  const PokemonType({required this.name});

  final String name;
}

class PokemonAbility {
  const PokemonAbility({required this.name});

  final String name;
}

class PokemonStat {
  const PokemonStat({required this.name, required this.baseValue});

  final String name;
  final int baseValue;
}

class TypeEffect {
  const TypeEffect({required this.typeName, required this.damageFactor});

  final String typeName;
  final int damageFactor;
}
