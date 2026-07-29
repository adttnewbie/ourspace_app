import 'member.dart';

/// In-memory result of a successful [session.resume] (docs/state-management.md).
class SessionSnapshot {
  const SessionSnapshot({
    required this.member,
    required this.members,
    required this.anniversaryDate,
    required this.fetchedAt,
  });

  final Member member;
  final List<Member> members;
  final DateTime anniversaryDate;
  final DateTime fetchedAt;
}
