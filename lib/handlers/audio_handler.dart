// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/helpers/logger.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);

  AudioPlayer get player => _player;

  PlaybackState playbackStateFor(PlaybackEvent event) {
    return playbackState.value.copyWith(
      // Which buttons should appear in the notification now
      controls: [
        MediaControl.skipToPrevious,
        _player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      // Which other actions should be enabled in the notification
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      // Which controls to show in Android's compact view.
      androidCompactActionIndices: const [0, 1, 3],
      // Whether audio is ready, buffering, ...
      processingState: {
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.completed: AudioProcessingState.completed,
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.ready: AudioProcessingState.ready
      }[_player.processingState]!,
      // Whether audio is playing
      playing: _player.playing,
      // The current position as of this update. You should not broadcast
      // position changes continuously because listeners will be able to
      // project the current position after any elapsed time based on the
      // current speed and whether audio is playing and ready. Instead, only
      // broadcast position updates when they are different from expected (e.g.
      // buffering, or seeking).

      updatePosition: _player.position,
      // The current buffered position as of this update
      bufferedPosition: _player.bufferedPosition,
      // The current speed
      speed: _player.speed,
      // The current queue position
      queueIndex: _player.currentIndex,
    );
  }

  MyAudioHandler() {
    _player.setAudioSource(_playlist);

    _updateQueue();

    _player.currentIndexStream.listen((int? index) {
      if (index != null && index < _playlist.children.length) {
        mediaItem.add((_playlist.children.elementAt(index) as UriAudioSource)
            .tag as MediaItem);
      }
    });

    _player.playbackEventStream.listen((event) {
      playbackState.add(playbackStateFor(event));
    });

    // _player.setUrl(
    //     "https://res.cloudinary.com/extelvogroup/video/upload/v1742799846/wajanja_tv/podcasts/Should_You_Watch_Porn____Middle_Ground_fabvha.mp3");
  }

  bool hasPodcasts() {
    return queue.value.any(
        (item) => item.id.contains(CloudinaryUploadPath.podcasts.describe));
  }

  // bool hasAudiobookChapter(Audiobook audiobook) {
  //   return queue.value.an
  // }

  void _updateQueue() {
    queue.add(List<MediaItem>.from(_playlist.children
        .map((el) => (el as UriAudioSource).tag as MediaItem)
        .toList()));
  }

  Future<void> playFrom(MediaItem item) async {
    final itemIndex = queue.value.indexWhere((el) => el.id == item.id);
    final currentItem = currentMediaItem();
    final isCurrentItem = currentItem?.id == item.id;

    if (itemIndex >= 0) {
      mediaItem.add(queue.value.elementAt(itemIndex));
      await _player.seek(isCurrentItem ? _player.position : Duration.zero,
          index: itemIndex);
      await _player.play();

      log.f("PLAYING NOW");
    }
  }

  MediaItem? currentMediaItem() {
    final currentlyPlayingIndex = _player.currentIndex;

    log.f("CURRENTLY PLAYING INDEX: $currentlyPlayingIndex");

    // log.f("CURRENTLY PLAYING INDEX: $currentlyPlayingIndex");

    // if (currentlyPlayingIndex == null ||
    //     queue.value.isEmpty ||
    //     _playlist.children.isEmpty ||
    //     currentlyPlayingIndex < 0) {
    //   return null;
    // }

    if (currentlyPlayingIndex == null ||
        (currentlyPlayingIndex) < 0 ||
        (queue.value.isNotEmpty &&
            currentlyPlayingIndex > queue.value.length - 1)) {
      return null;
    }

    try {
      final playingMediaItem = queue.value.elementAt(currentlyPlayingIndex);

      return playingMediaItem;
    } catch (e) {
      log.f("ERROR IS: $e");

      return null;
    }
  }

  Future<void> clearPlaylist() async {
    // mediaItem.add(event)
    await stop();
    _playlist.clear();
    queue.value.clear();
  }

  Future<void> clearPlaylistWhere(bool Function(MediaItem) test) async {
    final newQueue = queue.value.where(test).toList();
    await _playlist.clear();
    await _playlist.addAll(List<AudioSource>.generate(newQueue.length, (index) {
      final item = newQueue.elementAt(index);
      final uri = Uri.parse(item.id);

      return AudioSource.uri(uri);
    }));

    log.f("FINAL QUEUE: ${newQueue.map((el) => el.artUri)}");

    queue.value = newQueue;
  }

  bool isCurrentlyPlaying(MediaItem item) {
    final res = currentMediaItem();

    return res?.id == item.id && _player.playing;
  }

  bool inQueue(MediaItem item) {
    return queue.value.any((element) => element.id == item.id);
  }

  Future<void> addToPlaylist(MediaItem item) async {
    //! NOTE: item.id = audio url
    final itemInQueue = inQueue(item);

    if (itemInQueue) {
      log.f("MEDIA IS IN QUEUE, RETURING...");
      return;
    }

    final audio = AudioSource.uri(Uri.parse(item.id), tag: item);
    await _playlist.add(audio);
    _updateQueue();
  }

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> skipToNext() => _player.seekToNext();
  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  // mute() {}
}
