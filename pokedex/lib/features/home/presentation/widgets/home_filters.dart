import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class HomeFilters extends StatelessWidget {
  const HomeFilters({
    super.key,
    required this.selectedType,
    required this.selectedGeneration,
    required this.selectedWeight,
    required this.selectedHeight,
    required this.typeOptions,
    required this.generationOptions,
    required this.weightOptions,
    required this.heightOptions,
    required this.onTypeSelected,
    required this.onGenerationSelected,
    required this.onWeightSelected,
    required this.onHeightSelected,
  });

  final String selectedType;
  final String selectedGeneration;
  final String selectedWeight;
  final String selectedHeight;
  final List<String> typeOptions;
  final List<String> generationOptions;
  final List<String> weightOptions;
  final List<String> heightOptions;
  final ValueChanged<String> onTypeSelected;
  final ValueChanged<String> onGenerationSelected;
  final ValueChanged<String> onWeightSelected;
  final ValueChanged<String> onHeightSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final itemWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: <Widget>[
            _FilterCard(
              label: 'Type',
              value: selectedType,
              width: itemWidth,
              onTap: () => _showOptions(
                context: context,
                title: 'Type',
                options: typeOptions,
                selected: selectedType,
                onSelected: onTypeSelected,
              ),
            ),
            _FilterCard(
              label: 'Gen',
              value: selectedGeneration,
              width: itemWidth,
              onTap: () => _showOptions(
                context: context,
                title: 'Gen',
                options: generationOptions,
                selected: selectedGeneration,
                onSelected: onGenerationSelected,
              ),
            ),
            _FilterCard(
              label: 'Weight',
              value: selectedWeight,
              width: itemWidth,
              onTap: () => _showOptions(
                context: context,
                title: 'Weight',
                options: weightOptions,
                selected: selectedWeight,
                onSelected: onWeightSelected,
              ),
            ),
            _FilterCard(
              label: 'Height',
              value: selectedHeight,
              width: itemWidth,
              onTap: () => _showOptions(
                context: context,
                title: 'Height',
                options: heightOptions,
                selected: selectedHeight,
                onSelected: onHeightSelected,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showOptions({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option == selected;
                    return ListTile(
                      title: Text(option),
                      trailing: isSelected ? const Icon(Icons.check) : null,
                      onTap: () {
                        onSelected(option);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({
    required this.label,
    required this.value,
    required this.width,
    required this.onTap,
  });

  final String label;
  final String value;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
