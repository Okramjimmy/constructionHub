import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/project_model.dart';
import '../models/subtype_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../stages/providers/stages_provider.dart';
import '../../stages/models/stage_model.dart';
import '../../stages/models/stage_tree_node.dart';
import '../../stages/services/stages_service.dart';
import '../../form_types/providers/form_types_provider.dart';
import '../../form_types/models/form_type_model.dart';

// ── Projects (backed by Stages API) ───────────────────────────────────────────

/// Adapts the real Stage list from the API into the [ProjectModel] shape
/// expected by the existing UI.
///
/// Root-level stages (depth 0) are shown as top-level projects.
/// Status is always inProgress until the workflow state machine data is
/// plumbed through; colour cycling gives visual variety.
final projectsProvider = Provider<AsyncValue<List<ProjectModel>>>((ref) {
  final stagesAsync = ref.watch(stagesListProvider);
  return stagesAsync.whenData((stages) {
    final roots = stages.where((s) => s.depthLevel == 0).toList();
    return roots.asMap().entries.map((entry) {
      final i = entry.key;
      final s = entry.value;
      return _stageToProject(s, i);
    }).toList();
  });
});

/// Convenience: unwraps to an empty list while loading so the UI stays simple.
final projectsListProvider = Provider<List<ProjectModel>>((ref) {
  return ref.watch(projectsProvider).value ?? [];
});

ProjectModel _stageToProject(StageModel stage, int index) {
  // Cycle through gradient pairs for visual variety.
  final gradients = [
    (0xFFD4E3F7, 0xFFB8CCEE),
    (0xFFD4E8D4, 0xFFB8D4B8),
    (0xFFF7D4D4, 0xFFEEB8B8),
    (0xFFFEF3E8, 0xFFEED8B8),
  ];
  final g = gradients[index % gradients.length];

  return ProjectModel(
    id: stage.stageId,
    name: stage.stageName,
    address: stage.stagePath,
    zone: 'Zone ${String.fromCharCode(65 + index % 26)}',
    status: ProjectStatus.inProgress,
    checklistCount: stage.formTypeCount,
    updatedAgo: 'Updated just now',
    mapGradientStart: g.$1,
    mapGradientEnd: g.$2,
  );
}

// ── Sub-Types (backed by FormTypes API) ───────────────────────────────────────

/// Represents a stage and its resolved forms.
class StageWithForms {
  final StageTreeNode stage;
  final List<FormTypeModel> forms;

  const StageWithForms({
    required this.stage,
    required this.forms,
  });
}

/// Fetches the complete hierarchical tree under a given project/stage,
/// flattens it, and resolves all the full FormTypeModels based on the form IDs
/// returned by the /stages/tree response.
final projectStagesAndFormsProvider =
    FutureProvider.family<List<StageWithForms>, String>((ref, projectId) async {
  final stagesService = await ref.watch(stagesServiceProvider.future);

  // 1. Fetch the full stages tree
  final treeNodes = await stagesService.getTree();

  // 2. Find the sub-tree rooted at projectId
  StageTreeNode? targetNode;
  bool findNode(StageTreeNode node) {
    if (node.stageId == projectId) {
      targetNode = node;
      return true;
    }
    for (final child in node.children) {
      if (findNode(child)) return true;
    }
    return false;
  }

  for (final node in treeNodes) {
    if (findNode(node)) break;
  }

  // 3. Flatten the target sub-tree (or full tree if target not found)
  final List<StageTreeNode> flatNodes = [];
  void traverse(StageTreeNode node) {
    flatNodes.add(node);
    for (final child in node.children) {
      traverse(child);
    }
  }

  if (targetNode != null) {
    traverse(targetNode!);
  } else {
    for (final node in treeNodes) {
      traverse(node);
    }
  }

  // 3. For each stage, fetch the full FormTypeModel for its linked form_ids
  final List<StageWithForms> result = [];
  for (final node in flatNodes) {
    final List<FormTypeModel> fullForms = [];
    for (final summary in node.formTypes) {
      try {
        final ft = await ref.watch(formTypeDetailProvider(summary.formTypeId).future);
        fullForms.add(ft);
      } catch (e) {
        // Fallback placeholder FormTypeModel if fetching details fails
        fullForms.add(FormTypeModel(
          formTypeId: summary.formTypeId,
          formName: summary.formName,
          version: summary.version ?? '1.0.0',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          description: 'Linked form type',
        ));
      }
    }
    result.add(StageWithForms(stage: node, forms: fullForms));
  }

  return result;
});

/// Adapts [FormTypeModel] list for a given stage into [SubtypeModel] shape.
///
/// Usage: `ref.watch(subtypesByStageProvider(stageId))`
final subtypesByStageProvider =
    Provider.family<AsyncValue<List<SubtypeModel>>, String>((ref, stageId) {
  final formTypesAsync = ref.watch(formTypesByStageProvider(stageId));
  return formTypesAsync.whenData((formTypes) {
    return formTypes.asMap().entries.map((entry) {
      final i = entry.key;
      final ft = entry.value;
      return formTypeToSubtype(ft, i);
    }).toList();
  });
});

// ── Adapter helpers ────────────────────────────────────────────────────────────

final _subtypeIcons = [
  (Icons.foundation_outlined, AppColors.navy, const Color(0xFFE8F0FB)),
  (Icons.home_repair_service_outlined, AppColors.orange,
      const Color(0xFFFEF3E8)),
  (Icons.electrical_services_outlined, AppColors.green,
      const Color(0xFFE8F5ED)),
  (Icons.health_and_safety_outlined, AppColors.red, const Color(0xFFFDECEA)),
  (Icons.assignment_outlined, AppColors.navy, const Color(0xFFEFF3FA)),
];

SubtypeModel formTypeToSubtype(FormTypeModel ft, int index) {
  final style = _subtypeIcons[index % _subtypeIcons.length];
  return SubtypeModel(
    id: ft.formTypeId,
    name: ft.formName,
    tags: ft.description ?? ft.version,
    iconData: style.$1,
    iconColor: style.$2,
    bgColor: style.$3,
    checklistCount: ft.fields.length,
  );
}
