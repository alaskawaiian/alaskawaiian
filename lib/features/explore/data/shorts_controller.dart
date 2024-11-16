import 'dart:async';
import 'dart:collection';
import 'package:alaskawaiian_rewards/features/explore/domain/video.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide Video;
import '../domain/shorts_state.dart';
import 'package:synchronized/synchronized.dart';
import 'video_source_controller.dart';

part 'video_controls.dart';

class ShortsController extends ValueNotifier<ShortsState> with VideoControls {
  final Lock _lock;
  final VideoSourceController _youtubeVideoInfoService;
  final VideoControllerConfiguration _defaultVideoControllerConfiguration;

  ShortsController({
    List<int> indexsWhereWillContainAds = const [],
    required VideoSourceController youtubeVideoSourceController,
    bool videosWillBeInLoop = true,
    bool startVideoMuted = false,
    VideoControllerConfiguration defaultVideoControllerConfiguration =
        const VideoControllerConfiguration(),
  })  : _defaultVideoControllerConfiguration =
            defaultVideoControllerConfiguration,
        _youtubeVideoInfoService = youtubeVideoSourceController,
        _lock = Lock(),
        indexsWhereWillContainAds =
            UnmodifiableListView(indexsWhereWillContainAds),
        super(const ShortsStateLoading()) {
    notifyCurrentIndex(0);
  }

  int prevIndex = -1;

  @override
  int currentIndex = -1;

  /// Will notify the controller that the current index has changed.
  /// This will trigger the preload of the previous 3 and next 3 videos.
  void notifyCurrentIndex(
    int newIndex, {
    OnNotifyCallback? onPrevVideoPause,
    OnNotifyCallback? onCurrentVideoPlay,
  }) async {
    prevIndex = currentIndex;
    currentIndex = newIndex;
    unawaited(
      _playCurrentVideoAndPausePreviousVideo(
        prevIndex: prevIndex,
        currentIndex: currentIndex,
        onPrevVideoPause: onPrevVideoPause,
        onCurrentVideoPlay: onCurrentVideoPlay,
      ),
    );

    _preloadVideos();
  }

  Future<void> _playCurrentVideoAndPausePreviousVideo({
    required int prevIndex,
    required int currentIndex,
    required OnNotifyCallback? onPrevVideoPause,
    required OnNotifyCallback? onCurrentVideoPlay,
  }) async {
    if (prevIndex != -1) {
      final previousVideo = getVideoInIndex(prevIndex);
      if (previousVideo != null) {
        if (previousVideo is ShortsVideoData) {
          final VideoData video = await previousVideo.video.future;
          unawaited(video.videoController.player.pause());
          onPrevVideoPause?.call(video, prevIndex, currentIndex);
        }
      }
    }

    final currentVideo = getVideoInIndex(currentIndex);
    if (currentVideo != null) {
      if (currentVideo is ShortsVideoData) {
        final VideoData video = await currentVideo.video.future;
        final hostedAudioUrl = Media.normalizeURI(
            video.videoData.hostedVideoInfo.audioUrl.toString());

        await video.videoController.player
            .setAudioTrack(AudioTrack.uri(hostedAudioUrl));
        await video.videoController.player.play();
        onCurrentVideoPlay?.call(video, prevIndex, currentIndex);
      }
    }
  }

  int get maxLength {
    return _indexToSource.length;
  }

  final UnmodifiableListView<int> indexsWhereWillContainAds;
  final Map<int, int?> _indexToSource = {};

  /// Will load the previous 3 and next 3 videos.
  Future<void> _preloadVideos() async {
    try {
      return _lock.synchronized(() async {
        ShortsStateWithData? currentState = _getCurrentState();
        final Map<int, ShortsData>? videos = currentState?.videos;

        final previus3Ids = [
          _getMapEntryFromIndex(videos, currentIndex - 3),
          _getMapEntryFromIndex(videos, currentIndex - 2),
          _getMapEntryFromIndex(videos, currentIndex - 1),
        ];

        final next3Ids = [
          _getMapEntryFromIndex(videos, currentIndex + 1),
          _getMapEntryFromIndex(videos, currentIndex + 2),
          _getMapEntryFromIndex(videos, currentIndex + 3),
        ];

        // Add in state the 3 previous videos and the 3 next videos
        final focusedItems = [
          ...previus3Ids,
          _getMapEntryFromIndex(videos, currentIndex), // Current index
          ...next3Ids,
        ];

        final targetIndex =
            focusedItems.indexWhere((e) => e.key == currentIndex);

        List<MapEntry<int, ShortsData?>>? ordoredList;

        if (targetIndex != -1) {
          final prevCurrentIndex = focusedItems.sublist(0, targetIndex);
          final currentIndexAndPosItems = focusedItems.sublist(targetIndex);
          ordoredList = [
            ...currentIndexAndPosItems,
            ...prevCurrentIndex,
          ];
        }
        // Load the videos that are not in state
        for (final item in ordoredList ?? focusedItems) {
          if (item.key.isNegative) continue;
          final int? index;
          if (_indexToSource.containsKey(item.key) == false) {
            final isAdIndex = indexsWhereWillContainAds.contains(item.key);
            if (isAdIndex) {
              _indexToSource[item.key] = null;
              index = null;
            } else {
              final withoutNullValues = _indexToSource.values.whereType<int>();
              final int sourceLenght = withoutNullValues.length;
              _indexToSource[item.key] = sourceLenght;
              index = sourceLenght;
            }
          } else {
            index = _indexToSource[item.key];
          }

          if (index == null) {
            if (currentState == null) {
              currentState = ShortsStateWithData(videos: {
                item.key: ShortsAdsData(),
              });

              value = currentState;
            } else {
              final newState = ShortsStateWithData(videos: {
                ...currentState.videos,
                item.key: ShortsAdsData(),
              });
              currentState = newState;
              value = newState;
            }
          } else if (item.value == null &&
              (currentState?.videos.containsKey(item.key) ?? false) == false) {
            final VideoStats? video =
                await _youtubeVideoInfoService.getVideoByIndex(
              index,
            );

            if (video == null) continue;

            if (currentState == null) {
              currentState = ShortsStateWithData(videos: {
                item.key: ShortsVideoData(video: VideoDataCompleter()),
              });

              value = currentState;
            } else if (currentState.videos.containsKey(item.key) == false) {
              final newState = ShortsStateWithData(videos: {
                ...currentState.videos,
                item.key: ShortsVideoData(video: VideoDataCompleter()),
              });
              currentState = newState;
              value = newState;
            }

            final player = Player(
                configuration: PlayerConfiguration(
              vo: video.hostedVideoInfo.url.toString(),
            ));
            final hostedVideoUrl =
                Media.normalizeURI(video.hostedVideoInfo.url.toString());

            await player.open(Media(hostedVideoUrl));

            // Begin playing audio for first video
            if (currentState.videos.length == 1) {
              final hostedAudioUrl =
                  Media.normalizeURI(video.hostedVideoInfo.audioUrl.toString());
              await player.setAudioTrack(AudioTrack.uri(hostedAudioUrl));
            }

            await player.setVolume(100);

            await player.setPlaylistMode(PlaylistMode.single);

            final ShortsData? state = currentState.videos[item.key];

            if (state is ShortsVideoData) {
              state.video.complete((
                videoController: VideoController(
                  player,
                  configuration: _defaultVideoControllerConfiguration,
                ),
                videoData: video,
              ));
            }
          }
        }
      });
    } catch (error, stackTrace) {
      value = ShortsStateError(
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  ShortsData? getVideoInIndex(int index) {
    ShortsStateWithData? currentState = _getCurrentState();
    if (currentState == null) return null;

    return currentState.videos[index];
  }

  @override
  ShortsStateWithData? _getCurrentState() {
    if (value is ShortsStateWithData) {
      final ShortsStateWithData currentValue = (value as ShortsStateWithData);
      return currentValue;
    } else {
      return null;
    }
  }

  MapEntry<int, ShortsData?> _getMapEntryFromIndex(
    Map<int, ShortsData>? videos,
    int index,
  ) {
    if (index < 0) return MapEntry(index, null);
    if (videos == null) return MapEntry(index, null);

    final targetController = videos[index];
    return MapEntry(index, targetController);
  }

  @override
  void dispose() {
    super.dispose();
    _youtubeVideoInfoService.dispose();

    ShortsStateWithData? currentState = _getCurrentState();
    final videos = currentState?.videos;
    videos?.forEach((key, value) async {
      try {
        if (value is ShortsVideoData) {
          final controller = await value.video.future;
          controller.videoController.player.dispose();
        }
      } finally {}
    });
  }
}
