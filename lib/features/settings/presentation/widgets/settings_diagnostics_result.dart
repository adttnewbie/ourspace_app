import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../settings_diagnostics_state.dart';

/// Last check summary text — never tokens (docs/screen-specs/settings.md).
class SettingsDiagnosticsResult extends StatelessWidget {
  const SettingsDiagnosticsResult({super.key, required this.state});

  final SettingsDiagnosticsState state;

  @override
  Widget build(BuildContext context) {
    final message = state.lastMessage;
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }

    final ok = state.lastOk == true;
    final bg = ok ? AppColors.scrapMint : AppColors.scrapPink;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      liveRegion: true,
      label: message,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.x4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
