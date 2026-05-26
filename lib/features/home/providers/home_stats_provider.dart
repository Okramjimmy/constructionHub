import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../stages/providers/stages_provider.dart';
import '../../form_types/providers/form_types_provider.dart';
import '../../metadata/providers/metadata_provider.dart';

class HomeStats {
  const HomeStats({
    required this.activeSites,
    required this.inspections,
    required this.passRate,
    required this.pendingToday,
  });

  final int activeSites;
  final int inspections;
  final String passRate;
  final int pendingToday;
}

/// Derives home dashboard statistics from real API data:
///
/// - **activeSites** → total root-level stages (`GET /stages`)
/// - **inspections** → total form types (`GET /metadata/statistics`)
/// - **passRate** → placeholder until a dedicated analytics endpoint exists
/// - **pendingToday** → form types count as a proxy for now
final homeStatsProvider = Provider<HomeStats>((ref) {
  final stagesAsync = ref.watch(stagesListProvider);
  final formTypesAsync = ref.watch(formTypesProvider);
  final statsAsync = ref.watch(metadataStatisticsProvider);

  // Count root-level stages (depth 0) as "active sites".
  final stages = stagesAsync.value ?? [];
  final activeSites = stages.where((s) => s.depthLevel == 0).length;

  // Total form types as "inspection templates available".
  final formTypes = formTypesAsync.value ?? [];
  final inspections = formTypes.length;

  // If metadata statistics are available, prefer their totals.
  final metaStats = statsAsync.value;
  final totalStages = metaStats?.totalStages ?? activeSites;

  return HomeStats(
    activeSites: totalStages > 0 ? totalStages : activeSites,
    inspections: inspections,
    passRate: '94%', // TODO: wire to a real analytics endpoint
    pendingToday: stages.where((s) => s.isLeaf).length,
  );
});
