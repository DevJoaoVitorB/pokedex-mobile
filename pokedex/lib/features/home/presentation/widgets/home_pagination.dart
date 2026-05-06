import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class HomePagination extends StatelessWidget {
  const HomePagination({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 8,
        children: <Widget>[
          _PageButton(icon: Icons.chevron_left, isActive: false),
          const _PageNumber(label: '1', isActive: true),
          const _PageNumber(label: '2', isActive: false),
          const _PageNumber(label: '3', isActive: false),
          const _PageNumber(label: '...'),
          const _PageNumber(label: '10', isActive: false),
          _PageButton(icon: Icons.chevron_right, isActive: false),
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({required this.icon, required this.isActive});

  final IconData icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(
        icon,
        size: 20,
        color: isActive ? Colors.white : AppColors.textSecondary,
      ),
    );
  }
}

class _PageNumber extends StatelessWidget {
  const _PageNumber({required this.label, this.isActive = false});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isActive ? Colors.white : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
