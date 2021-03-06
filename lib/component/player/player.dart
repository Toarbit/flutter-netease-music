import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:music_player/music_player.dart';
import 'package:quiet/component/player/lryic.dart';
import 'package:quiet/model/model.dart';
import 'package:quiet/part/part.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:quiet/component/player/bottom_player_bar.dart';
export 'package:quiet/component/player/lryic.dart';

///key which save playing music to local preference
const String _PREF_KEY_PLAYING = "quiet_player_playing";

///key which save playing music list to local preference
const String _PREF_KEY_PLAYLIST = "quiet_player_playlist";

///key which save playing list token to local preference
const String _PREF_KEY_TOKEN = "quiet_player_token";

const String _PREF_KEY_PLAYLIST_TITLE = "quiet_player_playlist_title";

///key which save playing mode to local preference
const String _PREF_KEY_PLAY_MODE = "quiet_player_play_mode";

extension PlayModeGetNext on PlayMode {
  PlayMode get next {
    switch (this) {
      case PlayMode.sequence:
        return PlayMode.shuffle;
      case PlayMode.shuffle:
        return PlayMode.single;
      case PlayMode.single:
        return PlayMode.sequence;
    }
    throw "illegal state";
  }
}

extension QuitPlayerExt on BuildContext {
  MusicPlayer get player {
    try {
      return ScopedModel.of<QuietModel>(this).player;
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      rethrow;
    }
  }

  TransportControls get transportControls => player.transportControls;

  MusicPlayerValue get playerValue {
    return ScopedModel.of<QuietModel>(this, rebuildOnChange: true).player.value;
  }

  PlaybackState get playbackState => playerValue.playbackState;

  PlayList get playList => playerValue.playList;
}

extension MusicPlayerExt on MusicPlayer {
  //FIXME is this logic right???
  bool get initialized => value.metadata != null && value.metadata.duration > 0;
}

extension MusicPlayerValueExt on MusicPlayerValue {
  ///might be null
  Music get current => Music.fromMetadata(metadata);

  List<Music> get playingList => playList.queue.map((e) => Music.fromMetadata(e)).toList();
}

extension PlaybackStateExt on PlaybackState {
  bool get hasError => state == PlaybackState.STATE_ERROR;

  bool get isPlaying => (state == PlaybackState.STATE_PLAYING) && !hasError;

  ///audio is buffering
  bool get isBuffering => state == PlaybackState.STATE_BUFFERING;

  bool get initialized => state != PlaybackState.STATE_NONE;

  /// Current real position
  int get positionWithOffset => position + (DateTime.now().millisecondsSinceEpoch - lastPositionUpdateTime);
}

@visibleForTesting
class QuietModel extends Model {
  MusicPlayer player = MusicPlayer(onServiceConnected: (player) async {
    if (player.value.playList.queue.isNotEmpty && player.value.metadata != null) {
      return;
    }
//    try {
//      //load former player information from SharedPreference
//      var preference = await SharedPreferences.getInstance();
//      final playingMediaId = preference.getString(_PREF_KEY_PLAYING);
//      final token = preference.getString(_PREF_KEY_TOKEN);
//      final title = preference.getString(_PREF_KEY_PLAYLIST_TITLE) ?? "Now Playing";
//      final playingList = (json.decode(preference.get(_PREF_KEY_PLAYLIST)) as List)
//          ?.cast<Map>()
//          ?.map((e) => MediaMetadata.fromMap(e))
//          ?.toList();
//      final playMode = PlayMode.values[preference.getInt(_PREF_KEY_PLAY_MODE) ?? 0];
////      player.transportControls
////        ..setPlayMode(playMode)
////        ..prepareFromMediaId(playingMediaId);
//      player
//        ..setQueueAndId(playingList, token, queueTitle: title)
//        ..transportControls.setPlayMode(playMode)
//        ..transportControls.prepareFromMediaId(playingMediaId);
//      debugPrint("loaded : $playingMediaId");
////      debugPrint("loaded : $playingList");
//      debugPrint("loaded : $token");
//      debugPrint("loaded : $playMode");
//    } catch (e, stacktrace) {
//      debugPrint(e.toString());
//      debugPrint(stacktrace.toString());
//    }
  });

  QuietModel() {
    player.addListener(() {
      this.notifyListeners();
    });
  }
}

class Quiet extends StatefulWidget {
  Quiet({@Required() this.child, Key key}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => _QuietState();
}

class _QuietState extends State<Quiet> {
  final QuietModel _quiet = QuietModel();

  PlayingLyric _playingLyric;

  @override
  void initState() {
    super.initState();
    _playingLyric = PlayingLyric(_quiet.player);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _quiet,
      child: ScopedModel(
        model: _playingLyric,
        child: widget.child,
      ),
    );
  }
}
