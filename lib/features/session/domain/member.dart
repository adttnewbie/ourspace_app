/// Couple member identity from session.resume (docs/data-model.md, api-contract.md).
class Member {
  const Member({required this.id, required this.nickname});

  final String id;
  final String nickname;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Member && id == other.id && nickname == other.nickname;

  @override
  int get hashCode => Object.hash(id, nickname);
}
