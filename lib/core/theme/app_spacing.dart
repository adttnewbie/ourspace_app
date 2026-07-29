/// 4 logical-px base scale from [design.md] §6.
class AppSpacing {
  AppSpacing._();

  static const double x0_5 = 2;
  static const double x1 = 4;
  static const double x1_5 = 6;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;

  /// Main content clearance above bottom nav (design.md §6 step 32).
  static const double contentClearance = 128;

  /// Phone content max width (design.md §3 / §16).
  static const double phoneMaxWidth = 480;

  /// Standalone card max (pairing, offline, error) — design.md §13.
  static const double standaloneCardMaxWidth = 420;
}
