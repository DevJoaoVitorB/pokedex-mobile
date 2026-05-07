import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: <Widget>[
        Image.asset(
          'assets/ic_twotone-catching-pokemon.png',
          width: 32,
          height: 32,
        ),
        const SizedBox(width: 8),
        Text(
          'POKEDEX',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
