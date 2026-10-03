import 'package:flutter/material.dart';
import '../../../../core/app_Assets.dart';
import '../../../../l10n/app_localizations.dart';

class AvatarSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onAvatarSelected;

  const AvatarSelector({
    super.key,
    required this.selectedIndex,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final avatars = AppAssets.avatars;
    final int prevIndex =
        (selectedIndex - 1 + avatars.length) % avatars.length;
    final int nextIndex = (selectedIndex + 1) % avatars.length;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => onAvatarSelected(prevIndex),
              child: Opacity(
                opacity: 0.65,
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(avatars[prevIndex]),
                ),
              ),
            ),
            const SizedBox(width: 18),
            CircleAvatar(
              radius: 56,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(avatars[selectedIndex]),
            ),
            const SizedBox(width: 18),
            GestureDetector(
              onTap: () => onAvatarSelected(nextIndex),
              child: Opacity(
                opacity: 0.65,
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(avatars[nextIndex]),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          locale.avatar,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
