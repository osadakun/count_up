import 'package:count_up/models/counter_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'counter_view_model.g.dart';

@riverpod
class CounterViewModel extends _$CounterViewModel {
  @override
  CounterState build() {
    _loadFromPrefs();
    return const CounterState();
  }

  // 回転数を更新
  void updateRotationCount(int value) {
    state = state.copyWith(rotationCount: value);
    _saveToPrefs();
  }

  // ブドウのカウントを増減
  void updateGrapeCount(int value) {
    state = state.copyWith(grapeCount: state.grapeCount + value);
    _saveToPrefs();
  }

  // チェリー（重複あり）のカウントを増減
  void updateCherryCountWithDuplicates(int value) {
    state = state.copyWith(cherryCountWithDuplicates: state.cherryCountWithDuplicates + value);
    _saveToPrefs();
  }

  // チェリー（重複なし）のカウントを増減
  void updateCherryCountWithoutDuplicates(int value) {
    state = state.copyWith(cherryCountWithoutDuplicates: state.cherryCountWithoutDuplicates + value);
    _saveToPrefs();
  }

  // REG（重複あり）のカウントを増減
  void updateRegCountWithDuplicates(int value) {
    state = state.copyWith(regCountWithDuplicates: state.regCountWithDuplicates + value);
    _saveToPrefs();
  }

  // REG（重複なし）のカウントを増減
  void updateRegCountWithoutDuplicates(int value) {
    state = state.copyWith(regCountWithoutDuplicates: state.regCountWithoutDuplicates + value);
    _saveToPrefs();
  }

  // BIG（重複あり）のカウントを増減
  void updateBigCountWithDuplicates(int value) {
    state = state.copyWith(bigCountWithDuplicates: state.bigCountWithDuplicates + value);
    _saveToPrefs();
  }

  // BIG（重複なし）のカウントを増減
  void updateBigCountWithoutDuplicates(int value) {
    state = state.copyWith(bigCountWithoutDuplicates: state.bigCountWithoutDuplicates + value);
    _saveToPrefs();
  }

  // データをリセット
  void reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = const CounterState();
  }

  // データを保存
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rotationCount', state.rotationCount);
    await prefs.setInt('grapeCount', state.grapeCount);
    await prefs.setInt('cherryCountWithDuplicates', state.cherryCountWithDuplicates);
    await prefs.setInt('cherryCountWithoutDuplicates', state.cherryCountWithoutDuplicates);
    await prefs.setInt('regCountWithDuplicates', state.regCountWithDuplicates);
    await prefs.setInt('regCountWithoutDuplicates', state.regCountWithoutDuplicates);
    await prefs.setInt('bigCountWithDuplicates', state.bigCountWithDuplicates);
    await prefs.setInt('bigCountWithoutDuplicates', state.bigCountWithoutDuplicates);
  }

  // データを読み込み
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = CounterState(
      rotationCount: prefs.getInt('rotationCount') ?? 0,
      grapeCount: prefs.getInt('grapeCount') ?? 0,
      cherryCountWithDuplicates: prefs.getInt('cherryCountWithDuplicates') ?? 0,
      cherryCountWithoutDuplicates: prefs.getInt('cherryCountWithoutDuplicates') ?? 0,
      regCountWithDuplicates: prefs.getInt('regCountWithDuplicates') ?? 0,
      regCountWithoutDuplicates: prefs.getInt('regCountWithoutDuplicates') ?? 0,
      bigCountWithDuplicates: prefs.getInt('bigCountWithDuplicates') ?? 0,
      bigCountWithoutDuplicates: prefs.getInt('bigCountWithoutDuplicates') ?? 0,
    );
  }
}