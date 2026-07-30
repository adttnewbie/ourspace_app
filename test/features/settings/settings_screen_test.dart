import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ourspace_app/core/connectivity/connectivity_providers.dart';
import 'package:ourspace_app/core/router/session_auth.dart';
import 'package:ourspace_app/core/theme/app_theme.dart';
import 'package:ourspace_app/features/home/domain/home_repository.dart';
import 'package:ourspace_app/features/home/domain/home_snapshot.dart';
import 'package:ourspace_app/features/home/presentation/home_providers.dart';
import 'package:ourspace_app/features/notes/domain/notes_repository.dart';
import 'package:ourspace_app/features/notes/domain/sticky_note.dart';
import 'package:ourspace_app/features/notes/presentation/notes_providers.dart';
import 'package:ourspace_app/features/session/domain/member.dart';
import 'package:ourspace_app/features/session/domain/session_repository.dart';
import 'package:ourspace_app/features/session/domain/session_snapshot.dart';
import 'package:ourspace_app/features/session/presentation/session_controller.dart';
import 'package:ourspace_app/features/session/presentation/session_providers.dart';
import 'package:ourspace_app/features/settings/domain/settings_repository.dart';
import 'package:ourspace_app/features/settings/presentation/settings_providers.dart';
import 'package:ourspace_app/features/settings/presentation/settings_screen.dart';

class _OkSettingsRepo implements SettingsRepository {
  @override
  Future<void> checkHealth() async {}
}

class _SessionRepo implements SessionRepository {
  @override
  Future<void> clearLocal() async {}

  @override
  Future<bool> hasLocalCredentials() async => true;

  @override
  Future<SessionSnapshot?> resume({bool force = false}) async {
    return SessionSnapshot(
      member: const Member(id: 'member_a', nickname: 'Ae'),
      members: const [
        Member(id: 'member_a', nickname: 'Ae'),
        Member(id: 'member_b', nickname: 'Be'),
      ],
      anniversaryDate: DateTime.utc(2026, 7, 2),
      fetchedAt: DateTime.now(),
    );
  }

  @override
  Future<void> writeLocal({
    required String memberId,
    required String sessionToken,
  }) async {}
}

class _HomeRepo implements HomeRepository {
  @override
  Future<void> clearCache() async {}

  @override
  Future<HomeSnapshot> fetchFresh() async => get();

  @override
  Future<HomeSnapshot> get({bool force = false}) async {
    return HomeSnapshot(
      greeting: 'Hai',
      anniversaryDate: DateTime.utc(2026, 7, 2),
      daysTogether: 1,
      todayStickyNotes: const [],
      stickyNotesCount: 0,
      fetchedAt: DateTime.now(),
    );
  }

  @override
  Future<HomeSnapshot?> readCache() async => null;
}

class _NotesRepo implements NotesRepository {
  @override
  Future<void> clearCache() async {}

  @override
  Future<StickyNote?> create({
    required String body,
    required String color,
  }) async =>
      null;

  @override
  Future<void> delete({required String id}) async {}

  @override
  Future<NotesListResult> fetchFresh({int limit = 50, String? cursor}) async {
    return NotesListResult(items: const [], fetchedAt: DateTime.now());
  }

  @override
  Future<NotesListResult> list({
    int limit = 50,
    String? cursor,
    bool force = false,
  }) async {
    return NotesListResult(items: const [], fetchedAt: DateTime.now());
  }

  @override
  Future<NotesListResult?> readCache() async => null;

  @override
  Future<StickyNote?> update({
    required String id,
    required String body,
    required String color,
  }) async =>
      null;
}

void main() {
  group('SettingsScreen (step 2.5)', () {
    testWidgets('shows_v1_actions_without_token', (tester) async {
      final auth = SessionAuthNotifier()
        ..setStatus(SessionAuthStatus.authenticated);
      final container = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(_OkSettingsRepo()),
          sessionRepositoryProvider.overrideWithValue(_SessionRepo()),
          homeRepositoryProvider.overrideWithValue(_HomeRepo()),
          notesRepositoryProvider.overrideWithValue(_NotesRepo()),
          sessionAuthNotifierProvider.overrideWith((ref) => auth),
          isOnlineProvider.overrideWithValue(true),
        ],
      );
      addTearDown(container.dispose);

      await container.read(sessionControllerProvider.notifier).resume(force: true);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: SettingsScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Cek koneksi'), findsOneWidget);
      expect(find.text('Cek session'), findsOneWidget);
      expect(find.text('Hapus session lokal'), findsOneWidget);
      expect(find.text('Ae'), findsWidgets);
      expect(find.textContaining('token', findRichText: true), findsNothing);
      expect(find.textContaining('sessionToken'), findsNothing);

      await tester.tap(find.text('Cek koneksi'));
      await tester.pumpAndSettle();
      expect(find.text('Backend tersambung.'), findsOneWidget);
    });
  });
}
