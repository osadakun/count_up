import 'package:count_up/providers/counter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CounterPage extends HookConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(counterViewModelProvider);
    final viewModel = ref.read(counterViewModelProvider.notifier);

    final controller = useTextEditingController();

    useEffect(() {
      if (controller.text != state.rotationCount.toString()) {
        controller.text = state.rotationCount.toString();
      }
      return null;
    }, [state.rotationCount]);

    // 割合を計算する関数
    String calculateRatio(int count) {
      if (state.rotationCount == 0) return '1/0.00';
      final ratio = state.rotationCount / count;
      return '1/${ratio.toStringAsFixed(2)}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ジャグラー小役カウンター'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('リセット'),
                  content: const Text('内容をリセットしますか？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              if (result == true) {
                viewModel.reset();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onTap: () => FocusScope.of(context).unfocus(),
                    decoration: const InputDecoration(
                      labelText: '回転数',
                      border: OutlineInputBorder(),
                    ),
                    controller: controller,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final intValue = int.tryParse(value) ?? 0;
                      if (intValue != state.rotationCount) {
                        viewModel.updateRotationCount(intValue);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    viewModel.updateRotationCount(state.rotationCount + 100);
                  },
                  child: const Text('+100'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildCounterItem(
              context,
              '🍇 ブドウ',
              state.grapeCount,
              (value) => viewModel.updateGrapeCount(value),
              Colors.greenAccent,
              calculateRatio(state.grapeCount),
            ),
            _buildCounterItem(
              context,
              '🍒 チェリー\n（ペカなし）',
              state.cherryCountWithoutDuplicates,
              (value) => viewModel.updateCherryCountWithoutDuplicates(value),
              Colors.redAccent,
              calculateRatio(state.cherryCountWithDuplicates +
                  state.cherryCountWithoutDuplicates),
            ),
            _buildCounterItem(
              context,
              '🎰 REG\n（チェリー重複）',
              state.regCountWithDuplicates,
              (value) => viewModel.updateRegCountWithDuplicates(value),
              Colors.blueGrey,
              calculateRatio(state.regCountWithDuplicates +
                  state.regCountWithoutDuplicates),
            ),
            _buildCounterItem(
              context,
              '🎰 REG\n（単独）',
              state.regCountWithoutDuplicates,
              (value) => viewModel.updateRegCountWithoutDuplicates(value),
              Colors.blueGrey,
              calculateRatio(state.regCountWithDuplicates +
                  state.regCountWithoutDuplicates),
            ),
            _buildCounterItem(
              context,
              '🎯 BIG\n（チェリー重複）',
              state.bigCountWithDuplicates,
              (value) => viewModel.updateBigCountWithDuplicates(value),
              Colors.black,
              calculateRatio(state.bigCountWithDuplicates +
                  state.bigCountWithoutDuplicates),
            ),
            _buildCounterItem(
              context,
              '🎯 BIG\n（単独）',
              state.bigCountWithoutDuplicates,
              (value) => viewModel.updateBigCountWithoutDuplicates(value),
              Colors.black,
              calculateRatio(state.bigCountWithDuplicates +
                  state.bigCountWithoutDuplicates),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterItem(
    BuildContext context,
    String label,
    int count,
    Function(int) onUpdate,
    Color color,
    String ratio,
  ) {
    final controller = useTextEditingController(text: count.toString());

    useEffect(() {
      controller.text = count.toString();
      return null;
    }, [count]);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: color)),
                Text('割合: $ratio',
                    style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                  iconSize: 32,
                  onPressed: () => onUpdate(-1),
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    onTap: () => FocusScope.of(context).unfocus(),
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (value) {
                      final newValue = int.tryParse(value) ?? 0;
                      onUpdate(newValue - count);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                  iconSize: 32,
                  onPressed: () => onUpdate(1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
