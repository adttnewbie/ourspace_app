import '../domain/member.dart';
import '../domain/session_snapshot.dart';

/// Parses only documented `session.resume` data fields (api-contract.md).
abstract final class SessionDto {
  static SessionSnapshot fromResumeData(Map<String, dynamic> data) {
    final memberRaw = data['member'];
    if (memberRaw is! Map) {
      throw const FormatException('session.resume missing member');
    }
    final member = _memberFromMap(Map<String, dynamic>.from(memberRaw));

    final membersRaw = data['members'];
    final members = <Member>[];
    if (membersRaw is List) {
      for (final item in membersRaw) {
        if (item is Map) {
          members.add(_memberFromMap(Map<String, dynamic>.from(item)));
        }
      }
    }

    final anniversaryRaw = data['anniversaryDate'];
    if (anniversaryRaw is! String || anniversaryRaw.isEmpty) {
      throw const FormatException('session.resume missing anniversaryDate');
    }
    final anniversaryDate = DateTime.parse(anniversaryRaw);

    return SessionSnapshot(
      member: member,
      members: members,
      anniversaryDate: anniversaryDate,
      fetchedAt: DateTime.now(),
    );
  }

  static Member _memberFromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final nickname = map['nickname'];
    if (id is! String || id.isEmpty) {
      throw const FormatException('member.id required');
    }
    if (nickname is! String) {
      throw const FormatException('member.nickname required');
    }
    return Member(id: id, nickname: nickname);
  }
}
