import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class HomePagination extends StatelessWidget {
  const HomePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onPrevious,
    required this.onSelect,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final pageItems = _visiblePages();

    return Center(
      child: Wrap(
        spacing: 8,
        children: <Widget>[
          _PageButton(
            icon: Icons.chevron_left,
            isEnabled: currentPage > 1,
            onTap: currentPage > 1 ? onPrevious : null,
          ),
          for (final page in pageItems)
            _PageNumber(
              label: page.toString(),
              isActive: page == currentPage,
              onTap: () => onSelect(page),
            ),
          _PageButton(
            icon: Icons.chevron_right,
            isEnabled: currentPage < totalPages,
            onTap: currentPage < totalPages ? onNext : null,
          ),
        ],
      ),
    );
  }

  List<int> _visiblePages() {
    if (totalPages <= 3) {
      return List<int>.generate(totalPages, (index) => index + 1);
    }
    if (currentPage <= 1) {
      return <int>[1, 2, 3];
    }
    if (currentPage >= totalPages) {
      return <int>[totalPages - 2, totalPages - 1, totalPages];
    }
    return <int>[currentPage - 1, currentPage, currentPage + 1];
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.icon,
    required this.isEnabled,
    required this.onTap,
  });

  final IconData icon;
  final bool isEnabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = isEnabled ? AppColors.textSecondary : AppColors.border;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

class _PageNumber extends StatelessWidget {
  const _PageNumber({
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
        ),
      ),
    );
  }
}
