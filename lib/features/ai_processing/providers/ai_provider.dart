import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../storage/services/storage_service.dart';

enum AiProcessingStep { idle, uploaded, processing, complete, error }

class AiState {
  const AiState({
    this.step = AiProcessingStep.idle,
    this.imagePath,
    this.overallAccuracy = 94.2,
    this.crackAccuracy = 96.1,
    this.honeycombAccuracy = 91.8,
    this.imagesProcessed = 2841,
    this.avgMs = 12,
    this.uploadedObjectName,
    this.errorMessage,
  });

  final AiProcessingStep step;
  final String? imagePath;
  final double overallAccuracy;
  final double crackAccuracy;
  final double honeycombAccuracy;
  final int imagesProcessed;
  final int avgMs;

  /// The MinIO object key returned after a successful upload.
  final String? uploadedObjectName;
  final String? errorMessage;

  AiState copyWith({
    AiProcessingStep? step,
    String? imagePath,
    String? uploadedObjectName,
    String? errorMessage,
  }) {
    return AiState(
      step: step ?? this.step,
      imagePath: imagePath ?? this.imagePath,
      overallAccuracy: overallAccuracy,
      crackAccuracy: crackAccuracy,
      honeycombAccuracy: honeycombAccuracy,
      imagesProcessed:
          imagesProcessed + (step == AiProcessingStep.complete ? 1 : 0),
      avgMs: avgMs,
      uploadedObjectName: uploadedObjectName ?? this.uploadedObjectName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AiNotifier extends StateNotifier<AiState> {
  AiNotifier(this._ref) : super(const AiState());

  final Ref _ref;

  /// Uploads [imagePath] to MinIO then triggers processing.
  ///
  /// The upload uses the real [StorageService]. After upload, the ML
  /// inference call can be wired to a dedicated endpoint — for now it
  /// completes with a short simulated delay to keep the existing UX intact
  /// until the ML endpoint is available.
  Future<void> uploadAndProcess(String imagePath) async {
    state = state.copyWith(
      step: AiProcessingStep.uploaded,
      imagePath: imagePath,
    );

    try {
      // ── Step 1: Upload image to MinIO ──────────────────────────────────
      final svc = await _ref.read(storageServiceProvider.future);
      final result = await svc.upload(
        imagePath,
        storagePath: 'ai-processing/',
      );

      state = state.copyWith(
        step: AiProcessingStep.processing,
        uploadedObjectName: result.objectName,
      );

      // ── Step 2: ML inference (wire real endpoint here) ─────────────────
      // TODO: Replace delay with:
      // await _callMlEndpoint(result.objectName);
      await Future.delayed(const Duration(milliseconds: 1500));

      state = state.copyWith(step: AiProcessingStep.complete);
    } catch (e) {
      state = state.copyWith(
        step: AiProcessingStep.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const AiState();
  }
}

final aiProvider = StateNotifierProvider<AiNotifier, AiState>(
  (ref) => AiNotifier(ref),
);
