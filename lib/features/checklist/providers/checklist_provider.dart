import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/checklist_item_model.dart';
import '../../form_types/providers/form_types_provider.dart';
import '../../form_records/services/form_records_service.dart';

class ChecklistState {
  const ChecklistState({
    required this.items,
    this.recordId,
    this.isSavingDraft = false,
    this.isSubmitting = false,
    this.submitted = false,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<ChecklistItemModel> items;
  final String? recordId;
  final bool isSavingDraft;
  final bool isSubmitting;
  final bool submitted;
  final bool isLoading;
  final String? errorMessage;

  int get completedCount =>
      items.where((i) => i.isCompleted).length;

  double get progress =>
      items.isEmpty ? 0 : completedCount / items.length;

  ChecklistState copyWith({
    List<ChecklistItemModel>? items,
    String? recordId,
    bool? isSavingDraft,
    bool? isSubmitting,
    bool? submitted,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChecklistState(
      items: items ?? this.items,
      recordId: recordId ?? this.recordId,
      isSavingDraft: isSavingDraft ?? this.isSavingDraft,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitted: submitted ?? this.submitted,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ChecklistNotifier extends StateNotifier<ChecklistState> {
  ChecklistNotifier(this.ref, this.formTypeId)
      : super(const ChecklistState(items: [], isLoading: true)) {
    _loadSchema();
  }

  final Ref ref;
  final String formTypeId;
  final _picker = ImagePicker();

  Future<void> _loadSchema() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Fetch the form type with schema
      final formType = await ref.read(formTypeWithSchemaProvider(formTypeId).future);
      final fields = formType.fields;

      if (fields.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          items: [],
          errorMessage: 'This form type has no fields configured in its schema.',
        );
        return;
      }

      final checklistItems = fields.asMap().entries.map((entry) {
        final idx = entry.key;
        final field = entry.value;

        final name = field['label'] as String? ??
            field['fieldname'] as String? ??
            field['name'] as String? ??
            'Checklist Item';

        final id = field['name'] as String? ?? 'field_$idx';
        final fieldType = field['fieldtype'] as String? ?? 'Select';
        final desc = field['description'] as String?;

        // Parse options if present (new-line separated)
        List<String> optionsList = [];
        final rawOptions = field['options'];
        if (rawOptions is String) {
          optionsList = rawOptions
              .split('\n')
              .map((o) => o.trim())
              .where((o) => o.isNotEmpty)
              .toList();
        }

        return ChecklistItemModel(
          id: id,
          number: idx + 1,
          name: name,
          fieldType: fieldType,
          options: optionsList,
          description: desc,
        );
      }).toList();

      state = state.copyWith(
        isLoading: false,
        items: checklistItems,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load checklist schema: ${e.toString()}',
      );
    }
  }

  void setResult(String itemId, dynamic value) {
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.id == itemId) return item.copyWith(value: value);
        return item;
      }).toList(),
    );
  }

  void setRemarks(String itemId, String remarks) {
    state = state.copyWith(
      items: state.items.map((item) {
        if (item.id == itemId) return item.copyWith(remarks: remarks);
        return item;
      }).toList(),
    );
  }

  Future<void> capturePhoto(String itemId) async {
    try {
      // Try camera first; fall back to gallery on web or unsupported devices
      XFile? image;
      try {
        image = await _picker.pickImage(
            source: ImageSource.camera, imageQuality: 80);
      } catch (_) {
        image = await _picker.pickImage(
            source: ImageSource.gallery, imageQuality: 80);
      }
      if (image != null) {
        state = state.copyWith(
          items: state.items.map((item) {
            if (item.id == itemId) {
              return item.copyWith(photoPath: image!.path);
            }
            return item;
          }).toList(),
        );
      }
    } catch (_) {
      // Handle permission denied gracefully
    }
  }

  /// Gathers all item values into a JSON data payload map and saves it as a backend Draft record.
  Future<bool> saveDraft() async {
    try {
      state = state.copyWith(isSavingDraft: true);
      final service = await ref.read(formRecordsServiceProvider.future);

      // Collect data map
      final dataMap = <String, dynamic>{};
      for (final item in state.items) {
        if (item.value != null) {
          dataMap[item.id] = item.value;
        }
      }

      if (state.recordId == null) {
        // Create new Form Record on backend
        final record = await service.create(formTypeId: formTypeId, data: dataMap);
        state = state.copyWith(recordId: record.recordId, isSavingDraft: false);
      } else {
        // Update existing draft Form Record on backend
        await service.update(state.recordId!, data: dataMap);
        state = state.copyWith(isSavingDraft: false);
      }
      return true;
    } catch (e) {
      state = state.copyWith(isSavingDraft: false);
      return false;
    }
  }

  /// Saves the current checklist progress as a draft and then transitions its status to 'Submitted'.
  Future<bool> submit() async {
    try {
      state = state.copyWith(isSubmitting: true);
      
      // 1. Ensure latest values are saved as draft first
      final saveSuccess = await saveDraft();
      if (!saveSuccess || state.recordId == null) {
        state = state.copyWith(isSubmitting: false);
        return false;
      }

      // 2. Submit / Transition draft record on backend using 'submit' trigger
      final service = await ref.read(formRecordsServiceProvider.future);
      await service.transition(state.recordId!, trigger: 'submit');

      state = state.copyWith(isSubmitting: false, submitted: true);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false);
      return false;
    }
  }

  void reset() {
    state = const ChecklistState(items: [], recordId: null);
    _loadSchema();
  }
}

final checklistProvider =
    StateNotifierProvider.family<ChecklistNotifier, ChecklistState, String>(
  (ref, formTypeId) => ChecklistNotifier(ref, formTypeId),
);
