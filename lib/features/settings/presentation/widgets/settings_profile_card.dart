import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/scrapbook_card.dart';
import '../../../session/domain/session_snapshot.dart';

/// Non-sensitive profile block (docs/screen-specs/settings.md). Never shows tokens.
class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({super.key, required this.snapshot});

  final SessionSnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nickname = snapshot?.member.nickname.trim();
    final displayName =
        (nickname == null || nickname.isEmpty) ? 'OurSpace' : nickname;

    String? anniversaryLabel;
    final ann = snapshot?.anniversaryDate;
    if (ann != null) {
      final local = ann.toLocal();
      anniversaryLabel =
          'Sejak ${local.day}/${local.month}/${local.year}';
    }

    final partner = _partnerNickname(snapshot);

    return ScrapbookCard(
      tone: ScrapTone.lavender,
      tape: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            displayName,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (partner != null) ...[
            const SizedBox(height: AppSpacing.x2),
            Text(
              'dengan $partner',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.mutedForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (anniversaryLabel != null) ...[
            const SizedBox(height: AppSpacing.x2),
            Text(
              anniversaryLabel,
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.mutedForeground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String? _partnerNickname(SessionSnapshot? snapshot) {
    if (snapshot == null) return null;
    final selfId = snapshot.member.id;
    for (final m in snapshot.members) {
      if (m.id != selfId) {
        final n = m.nickname.trim();
        if (n.isNotEmpty) return n;
      }
    }
    return null;
  }
}
