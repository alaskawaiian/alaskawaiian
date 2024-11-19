import 'package:flutter/material.dart';
import 'package:enchanted_collection/enchanted_collection.dart';
import 'package:media_kit_video/media_kit_video.dart' as media_kit show Video;

import '../../domain/video.dart';

class YoutubeShortsVideoPlayer extends StatefulWidget {
  final bool willHaveDefaultShortsControllers;
  final int index;
  final PageController pageController;
  final VideoData data;
  final VideoDataBuilder? videoBuilder;
  final VideoInfoBuilder? overlayWidgetBuilder;
  final double? initialVolume;
  const YoutubeShortsVideoPlayer({
    super.key,
    required this.willHaveDefaultShortsControllers,
    required this.index,
    required this.pageController,
    required this.data,
    this.videoBuilder,
    this.overlayWidgetBuilder,
    this.initialVolume,
  });

  @override
  State<YoutubeShortsVideoPlayer> createState() =>
      _YoutubeShortsVideoPlayerState();
}

class _YoutubeShortsVideoPlayerState extends State<YoutubeShortsVideoPlayer>
    with AutomaticKeepAliveClientMixin<YoutubeShortsVideoPlayer> {
  bool isControlsVisible = false;

  @override
  void initState() {
    _initialVolume();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _initialVolume();
    super.didChangeDependencies();
  }

  void _initialVolume() {
    final double? initialVolume = widget.initialVolume;
    if (initialVolume != null) {
      widget.data.videoController.player.setVolume(initialVolume);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        SizedBox.expand(
          child: Builder(
            builder: (context) {
              final videoPlayer = media_kit.Video(
                height: MediaQuery.sizeOf(context).height -
                    MediaQuery.paddingOf(context).bottom,
                fit: (widget.data.videoController.player.state.height ?? 720) <=
                        720
                    ? BoxFit.fitWidth
                    : BoxFit.fitHeight,
                controller: widget.data.videoController,
                controls: (state) {
                  return GestureDetector(
                    onTap: () {
                      state.widget.controller.player.playOrPause();
                      setState(() {
                        isControlsVisible = true;
                      });
                      if (!state.widget.controller.player.state.playing) {
                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            isControlsVisible = false;
                          });
                        });
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(16),
                      child: AnimatedOpacity(
                          opacity: isControlsVisible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 250),
                          child: Icon(
                            state.widget.controller.player.state.playing
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 48,
                          )),
                    ),
                  );
                },
              );
              if (widget.videoBuilder != null) {
                return widget.videoBuilder!(
                  widget.index,
                  widget.pageController,
                  widget.data.videoController,
                  widget.data.videoData.videoData,
                  widget.data.videoData.hostedVideoInfo,
                  videoPlayer,
                );
              }

              return videoPlayer;
            },
          ),
        ),
        widget.overlayWidgetBuilder?.call(
          widget.index,
          widget.pageController,
          widget.data.videoController,
          widget.data.videoData.videoData,
          widget.data.videoData.hostedVideoInfo,
        ),
      ].removeNull,
    );
  }
}
