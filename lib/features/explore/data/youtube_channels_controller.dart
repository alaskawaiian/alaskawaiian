part of 'video_source_controller.dart';

class YoutubeChannelsController extends VideoSourceController {
  @override
  final Map<int, VideoStats> _cache = {};
  final List<String> _channelNames;
  final Map<String, Completer<ChannelUploadsList>> _data;

  int _channelIndex = 0;
  int _videoIndex = 0;

  YoutubeChannelsController({
    required List<String> channelNames,
  })  : _channelNames = channelNames,
        _data = Map.fromEntries(channelNames
            .map((value) => MapEntry(value, Completer<ChannelUploadsList>()))) {
    _obtainChannelsUploadList();
  }

  @override
  Future<VideoStats?> getVideoByIndex(int index) async {
    if (_cache.containsKey(index)) {
      return Future.value(_cache[index]);
    }
    return _fetchNext(index);
  }

  Future<VideoStats?> _fetchNext(int index) async {
    final String channelName = _channelNames[_channelIndex];
    final ChannelUploadsList channelUploads =
        (await _data[channelName]?.future)!;

    Video video = await _yt.videos.get(channelUploads[_videoIndex].id.value);

    final MuxedStreamInfo info = await getVideoInfoFromVideoModel(
      video.id.value,
    );
    final VideoStats response = (videoData: video, hostedVideoInfo: info);

    if (_videoIndex == channelUploads.length - 1) {
      _data[channelName] = Completer<ChannelUploadsList>();
      await channelUploads.nextPage().then((uploads) {
        if (uploads == null) {
          _channelNames.remove(channelName);
        } else {
          _data[channelName]!.complete(uploads);
        }
      });
    }

    if (_channelIndex == _channelNames.length - 1) {
      _channelIndex = 0;
      _videoIndex++;
    } else {
      _channelIndex++;
    }

    _cache[index] = response;
    return response;
  }

  void _obtainChannelsUploadList() async {
    Future.wait(
      _channelNames.map((channelName) async {
        final channel = await _yt.channels.getByHandle(channelName);
        await _yt.channels
            .getUploadsFromPage(
          channel.id,
          // channel.id,
          videoSorting: VideoSorting.popularity,
          videoType: VideoType.shorts,
        )
            .then((uploads) {
          _data[channelName]!.complete(uploads);
        }).onError((error, stackTrace) {
          if (error is FatalFailureException) {
            _data[channelName]!.completeError(error, stackTrace);
            throw error;
          }
          final exception = error ??
              Exception(
                'Unknown error. Please check $channelName',
              );
          _data[channelName]!.completeError(exception, stackTrace);
          throw exception;
        });
      }),
    );
  }
}
