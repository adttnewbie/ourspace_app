import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/connectivity/connectivity_providers.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/scrapbook_card.dart';
import '../../../notes/presentation/notes_providers.dart';
import '../home_providers.dart';
import 'today_notes_section.dart';

/// Quick sticky draft + `notes.create` (screen-specs/home.md).
class QuickAddSticky extends ConsumerStatefulWidget {
  const QuickAddSticky({super.key});

  @override
  ConsumerState<QuickAddSticky> createState() => _QuickAddStickyState();
}

class _QuickAddStickyState extends ConsumerState<QuickAddSticky> {
  static const _hint = 'Tulis note singkat…';
  static const _submitA11y = 'Kirim';
  static const _offlineBlocked = 'Butuh internet buat mengubah data.';
  static const _maxLength = 280;

  final _controller = TextEditingController();
  String _color = 'pink';
  var _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final body = _controller.text.trim();
    if (body.isEmpty || _submitting) return;

    final online = ref.read(isOnlineProvider);
    if (!online) {
      _toast(_offlineBlocked);
      return;
    }

    setState(() => _submitting = true);
    try {
      ref.read(offlineGuardProvider).ensureOnline();
      await ref
          .read(notesRepositoryProvider)
          .create(body: body, color: _color);
      if (!mounted) return;
      _controller.clear();
      await ref.read(homeProvider.notifier).refresh();
    } on AppFailure catch (e) {
      if (!mounted) return;
      if (e.code == 'OFFLINE_MUTATION_BLOCKED') {
        _toast(_offlineBlocked);
      } else {
        _toast(e.message ?? 'Ada yang error nih');
      }
    } catch (_) {
      if (!mounted) return;
      _toast('Ada yang error nih');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(isOnlineProvider);
    final body = _controller.text.trim();
    final canSubmit =
        body.isNotEmpty && online && !_submitting;

    return ScrapbookCard(
      tone: ScrapTone.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              for (final key in NoteColorSwatch.keys) ...[
                NoteColorSwatch(
                  colorKey: key,
                  selected: _color == key,
                  onTap: _submitting
                      ? () {}
                      : () => setState(() => _color = key),
                ),
                if (key != NoteColorSwatch.keys.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          AppTextField(
            controller: _controller,
            hintText: _hint,
            enabled: !_submitting,
            maxLength: _maxLength,
            textInputAction: TextInputAction.send,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) {
              if (canSubmit) {
                _submit();
              }
            },
          ),
          const SizedBox(height: AppSpacing.x3),
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              icon: const Icon(LucideIcons.send, size: 18),
              semanticLabel: _submitA11y,
              onPressed: canSubmit ? _submit : null,
              isLoading: _submitting,
              size: AppButtonSize.icon,
            ),
          ),
        ],
      ),
    );
  }
}
