import 'date_time_utils.dart';

/// Converts between persisted task minutes and visual timeline coordinates.
///
/// Keeping this calculation in one place ensures zooming never changes the
/// task's actual start or end minutes.
abstract final class TimelinePositionCalculator {
  static const double minHourHeight = 12;
  static const double maxHourHeight = 120;
  static const double defaultDetailHourHeight = 56;
  static const double defaultOverviewHourHeight = 28;
  static const double zoomStep = 8;

  static double clampHourHeight(double value) =>
      value.clamp(minHourHeight, maxHourHeight).toDouble();

  static double totalHeight(
    double hourHeight, {
    int startMinutes = AppDateUtils.dayStartMinutes,
    int endMinutes = AppDateUtils.dayEndMinutes,
  }) => (endMinutes - startMinutes) / 60 * clampHourHeight(hourHeight);

  static double topForMinutes(
    int minutes,
    double hourHeight, {
    int startMinutes = AppDateUtils.dayStartMinutes,
  }) => (minutes - startMinutes) / 60 * clampHourHeight(hourHeight);

  static double heightForRange(int start, int end, double hourHeight) =>
      (end - start) / 60 * clampHourHeight(hourHeight);

  static double slotHeight(double hourHeight, {int slotMinutes = 15}) =>
      slotMinutes / 60 * clampHourHeight(hourHeight);

  static int rawMinutesForOffset(
    double offset,
    double hourHeight, {
    int startMinutes = AppDateUtils.dayStartMinutes,
  }) => startMinutes + (offset / clampHourHeight(hourHeight) * 60).round();

  static double fitHourHeight(
    double availableHeight, {
    int startMinutes = AppDateUtils.dayStartMinutes,
    int endMinutes = AppDateUtils.dayEndMinutes,
  }) => clampHourHeight(availableHeight / ((endMinutes - startMinutes) / 60));

  static int zoomPercentage(double hourHeight) =>
      (clampHourHeight(hourHeight) / defaultDetailHourHeight * 100).round();
}
