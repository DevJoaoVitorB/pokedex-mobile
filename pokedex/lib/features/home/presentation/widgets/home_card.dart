import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/features/home/domain/entities/pokemon.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final idText = '#${pokemon.id.toString().padLeft(3, '0')}';

    return Container(
      margin: const EdgeInsets.all(16),
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  idText,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.numberColor,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _titleCase(pokemon.name),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: pokemon.types.map((type) {
                    return _TypeIcon(typeName: type.name, size: 32);
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150,
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.network(
                pokemon.spriteUrl ?? '',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported_outlined);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _titleCase(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.typeName, required this.size});

  final String typeName;
  final double size;

  static final Map<String, Future<String>> _svgCache =
      <String, Future<String>>{};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadSvg(typeName.toLowerCase()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(width: size, height: size);
        }

        return SvgPicture.string(
          snapshot.data!,
          width: size,
          height: size,
          fit: BoxFit.contain,
        );
      },
    );
  }

  Future<String> _loadSvg(String name) {
    return _svgCache.putIfAbsent(name, () async {
      final raw = await rootBundle.loadString('assets/types/$name.svg');
      return _inlineStyleFills(raw);
    });
  }

  String _inlineStyleFills(String raw) {
    final styleRegex = RegExp(r'<style[^>]*>([\s\S]*?)</style>');
    final styleMatch = styleRegex.firstMatch(raw);
    if (styleMatch == null) {
      return raw;
    }

    final styleContent = styleMatch.group(1) ?? '';
    final classRegex = RegExp(
      r'\.([\w-]+)\s*\{\s*fill:\s*(#[0-9a-fA-F]{3,6})\s*;?\s*\}',
    );
    final fills = <String, String>{};
    for (final match in classRegex.allMatches(styleContent)) {
      final className = match.group(1);
      final fill = match.group(2);
      if (className != null && fill != null) {
        fills[className] = fill;
      }
    }

    final withoutStyle = raw.replaceAll(styleRegex, '');
    if (fills.isEmpty) {
      return withoutStyle;
    }

    return withoutStyle.replaceAllMapped(RegExp(r'class="([^"]+)"'), (match) {
      final classNames = match.group(1)?.split(' ') ?? <String>[];
      for (final name in classNames) {
        final fill = fills[name];
        if (fill != null) {
          return 'fill="$fill"';
        }
      }
      return match.group(0) ?? '';
    });
  }
}
