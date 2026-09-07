import 'date_time_utils.dart';

/// Converts between persisted task minutes and visual timeline coordinates.
///
/// Keeping this calculation in one place ensures zooming never changes the
/// task's actual start or end minutes.
abstract final class TimelinePositionCalculator {
  static const double minHourHeight = 28;
  static const double maxHourHeight = 120;
  static const double defaultDetailHourHeight = 56;
  static const double defaultOverviewHourHeight = 28;
  static const double zoomStep = 8;

  static const int startMinutes = AppDateUtils.dayStartMinutes;
  static const int endMinutes = AppDateUtils.dayEndMinutes;
  static const double totalHours = (endMinutes - startMinutes) / 60;

  static double clampHourHeight(double value) =>
      value.clamp(minHourHeight, maxHourHeight).toDouble();

  static double totalHeight(double hourHeight) =>
      totalHours * clampHourHeight(hourHeight);

  static double topForMinutes(int minutes, double hourHeight) =>
      (minutes - startMinutes) / 60 * clampHourHeight(hourHeight);

  static double heightForRange(int start, int end, double hourHeight) =>
      (end - start) / 60 * clampHourHeight(hourHeight);

  static double slotHeight(double hourHeight, {int slotMinutes = 15}) =>
      slotMinutes / 60 * clampHourHeight(hourHeight);

  static int rawMinutesForOffset(double offset, double hourHeight) =>
      startMinutes + (offset / clampHourHeight(hourHeight) * 60).round();

  static double fitHourHeight(double availableHeight) =>
      clampHourHeight(availableHeight / totalHours);

  static int zoomPercentage(double hourHeight) =>
      (clampHourHeight(hourHeight) / defaultDetailHourHeight * 100).round();
}
