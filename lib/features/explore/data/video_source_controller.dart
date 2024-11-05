import 'dart:async';

import '../../../youtube_explode_fork/youtube_explode_dart.dart';
import '../domain/video.dart';

part 'youtube_channels_controller.dart';

abstract class VideoSourceController {
  final YoutubeExplode _yt = YoutubeExplode();

  /// The key is the index of order of the video.
  /// Will always be in crescent order. (1, 2, 3).
  /// So if the index 4 exists, the index 3, 2 and 1 will also exist.
  /// The reason for using a map instead of a list is because a
  /// map is more perfomatic for inserting and removing elements.
  ///
  /// The value is the info of the video.
  abstract final Map<int, VideoStats> _cache;

  int get currentMaxLenght => _cache.length;

  Future<VideoStats?> getVideoByIndex(int index);

  void dispose() {
    _yt.close();
  }

  VideoSourceController();

  factory VideoSourceController.fromYoutubeChannels({
    /// The name of the channels.
    required List<String> channelNames,

    /// If false, will bring all videos, even the horizontal/not shorts ones.
    bool onlyVerticalVideos = true,
  }) {
    return YoutubeChannelsController(
      channelNames: channelNames,
    );
  }

  Future<MuxedStreamInfo> getVideoInfoFromVideoModel(String videoId) async {
    final StreamManifest streamInfo =
        await YoutubeExplode().videos.streamsClient.getManifest(videoId);
    AudioOnlyStreamInfo audioInfo = streamInfo.audioOnly.last;
    VideoOnlyStreamInfo videoInfo = streamInfo.videoOnly.firstWhere(
        (video) =>
            video.qualityLabel == '1080p' || video.qualityLabel == '720p',
        orElse: () => streamInfo.videoOnly.last);

    return MuxedStreamInfo(
        videoInfo.videoId,
        videoInfo.tag,
        videoInfo.url,
        audioInfo.url,
        videoInfo.container,
        videoInfo.size,
        videoInfo.bitrate,
        audioInfo.audioCodec,
        videoInfo.videoCodec,
        videoInfo.qualityLabel,
        videoInfo.videoQuality,
        videoInfo.videoResolution,
        videoInfo.framerate,
        videoInfo.codec);
  }
}
