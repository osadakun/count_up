import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_state.freezed.dart';

@freezed
class CounterState with _$CounterState {
  const factory CounterState({
    @Default(0) int rotationCount,
    @Default(0) int grapeCount,
    @Default(0) int cherryCountWithDuplicates,
    @Default(0) int cherryCountWithoutDuplicates,
    @Default(0) int regCountWithDuplicates,
    @Default(0) int regCountWithoutDuplicates,
    @Default(0) int bigCountWithDuplicates,
    @Default(0) int bigCountWithoutDuplicates,
  }) = _CounterState;
}