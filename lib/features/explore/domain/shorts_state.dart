import './video.dart';

sealed class ShortsState {
  const ShortsState();
}

class ShortsStateError extends ShortsState {
  final Object error;
  final StackTrace stackTrace;
  const ShortsStateError({
    required this.error,
    required this.stackTrace,
  });
}

class ShortsStateLoading extends ShortsState {
  const ShortsStateLoading();
}

class ShortsStateWithData extends ShortsState {
  // The index and the video controller of the currently playing video.
  final Map<int, ShortsData> videos;
  const ShortsStateWithData({
    required this.videos,
  });
}

abstract class ShortsData {
  const ShortsData();
}

class ShortsVideoData implements ShortsData {
  final VideoDataCompleter video;
  ShortsVideoData({
    required this.video,
  });
}

class ShortsAdsData implements ShortsData {
  ShortsAdsData();
}

extension ShortsStateWithDataExtension on ShortsState {
  bool get isLoadingState => this is ShortsStateLoading;
  bool get isErrorState => this is ShortsStateError;
  bool get isDataState => this is ShortsStateWithData;
}
