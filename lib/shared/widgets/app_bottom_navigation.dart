import 'package:flutter/material.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/brand_colors.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.index,
    required this.onChanged,
  });
  final int index;
  final ValueChanged<int> onChanged;
  static const labels = ['Today', 'Add player', 'Messages', 'Profile'];
  static const icons = [
    Icons.space_dashboard_outlined,
    Icons.person_add_alt_1_rounded,
    Icons.chat_bubble_outline_rounded,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) => Material(
    color: BrandColors.surface,
    child: DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: BrandColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: List.generate(labels.length, (i) {
              final selected = i == index;
              return Expanded(
                child: Semantics(
                  selected: selected,
                  button: true,
                  label: labels[i],
                  child: InkWell(
                    onTap: () => onChanged(i),
                    borderRadius: BorderRadius.circular(12),
                    child: ExcludeSemantics(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 2,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: MediaQuery.disableAnimationsOf(context)
                                  ? Duration.zero
                                  : AppMotion.quick,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? BrandColors.primarySoft
                                    : BrandColors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                icons[i],
                                size: AppIcons.medium,
                                color: selected
                                    ? BrandColors.primary
                                    : BrandColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              labels[i],
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: selected
                                        ? BrandColors.primary
                                        : BrandColors.textMuted,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    ),
  );
}
