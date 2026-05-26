import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage_service.dart';

// ── Upload State ──────────────────────────────────────────────────────────────

enum UploadStatus { idle, uploading, success, error }

class FileUploadState {
  const FileUploadState({
    this.status = UploadStatus.idle,
    this.sentBytes = 0,
    this.totalBytes = 0,
    this.result,
    this.errorMessage,
  });

  final UploadStatus status;
  final int sentBytes;
  final int totalBytes;
  final UploadResult? result;
  final String? errorMessage;

  bool get isUploading => status == UploadStatus.uploading;
  bool get isSuccess => status == UploadStatus.success;

  double get progress =>
      totalBytes > 0 ? sentBytes / totalBytes : 0.0;

  FileUploadState copyWith({
    UploadStatus? status,
    int? sentBytes,
    int? totalBytes,
    UploadResult? result,
    String? errorMessage,
  }) {
    return FileUploadState(
      status: status ?? this.status,
      sentBytes: sentBytes ?? this.sentBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class FileUploadNotifier extends StateNotifier<FileUploadState> {
  FileUploadNotifier(this._ref) : super(const FileUploadState());

  final Ref _ref;

  Future<UploadResult?> upload(
    String filePath, {
    String? storagePath,
  }) async {
    state = const FileUploadState(status: UploadStatus.uploading);
    try {
      final svc = await _ref.read(storageServiceProvider.future);
      final result = await svc.upload(
        filePath,
        storagePath: storagePath,
        onProgress: (sent, total) {
          state = state.copyWith(
            sentBytes: sent,
            totalBytes: total,
          );
        },
      );
      state = state.copyWith(
        status: UploadStatus.success,
        result: result,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        status: UploadStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  void reset() => state = const FileUploadState();
}

// ── Providers ─────────────────────────────────────────────────────────────────

final fileUploadProvider =
    StateNotifierProvider<FileUploadNotifier, FileUploadState>(
  (ref) => FileUploadNotifier(ref),
);

/// Fetches a presigned URL for a known file.
final presignedUrlProvider =
    FutureProvider.family<String, String>((ref, fileName) async {
  final svc = await ref.watch(storageServiceProvider.future);
  final result = await svc.getPresignedUrl(fileName);
  return result.url;
});
