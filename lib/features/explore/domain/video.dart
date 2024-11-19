import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart' show VideoController;

import '../../../youtube_explode_fork/youtube_explode_dart.dart';

/// The video data (url, title, description etc...) and the hosted video info.
typedef VideoStats = ({Video videoData, MuxedStreamInfo hostedVideoInfo});

/// The data to controll video player and the video stats.
typedef VideoData = ({VideoController videoController, VideoStats videoData});

/// The completer typedef of [VideoData].
typedef VideoDataCompleter = Completer<VideoData>;

/// The dispose function of [VideoDataCompleter].
typedef DisposeFunction = FutureOr<void> Function();

typedef OnNotifyCallback = FutureOr<void> Function(
  VideoData prevVideo,
  int prevIndex,
  int currentIndex,
);

typedef VideoDataBuilder = Widget Function(
  int index,
  PageController pageController,
  VideoController videoController,
  Video videoData,
  MuxedStreamInfo hostedVideoInfo,
  Widget child,
);

typedef AdsDataBuilder = Widget Function(
  int index,
  PageController pageController,
);

typedef VideoInfoBuilder = Widget Function(
  int index,
  PageController pageController,
  VideoController videoController,
  Video videoData,
  MuxedStreamInfo hostedVideoInfo,
);