import 'package:flutter/material.dart';
import 'package:quiet/pages/playlist/music_list.dart';
import 'package:quiet/pages/playlist/page_playlist_detail.dart';
import 'package:quiet/part/part.dart';
import 'package:quiet/repository/netease.dart';

class MainCloudPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CloudPageState();
}

class CloudPageState extends State<MainCloudPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildHomeCategoryList(),
          _Header("热门歌单", () {}),
          _SectionTopPlaylist(),
          _Header("推荐歌单", () {}),
          _SectionPlaylist(),
          _Header("最新音乐", () {}),
          _SectionNewSongs(),
        ],
      ),
    );
  }


  /// 构建分类列表
  Widget _buildHomeCategoryList() {
    var map = {
      '每日推荐': 'assets/icon_daily.png',
      '歌单': 'assets/icon_playlist.png',
      '排行榜': 'assets/icon_rank.png',
      '电台': 'assets/icon_radio.png',
//      '直播': 'images/icon_look.png',
    };

    var keys = map.keys.toList();
    double width = 64;

    return GridView.custom(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: keys.length,
        childAspectRatio: 1 / 1.1,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
            (context, index) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, ROUTE_DAILY);
                  break;
                case 2:
                  Navigator.pushNamed(context, ROUTE_LEADERBOARD);
                  break;
              }
            },
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: width,
                      height: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width / 2),
                          border: Border.all(color: Colors.black12, width: 0.5),
                          gradient: RadialGradient(
                            colors: [Theme.of(context).primaryColor.withOpacity(0.5), Theme.of(context).primaryColor],
                            center: Alignment(-1.7, 0),
                            radius: 1,
                          ),
                          color: Theme.of(context).primaryColor),
                    ),
                    Image.asset(
                      map[keys[index]],
                      width: width,
                      height: width,
                      color: Theme.of(context).primaryTextTheme.body1.color,
                    ),
                    Container(
                     padding: EdgeInsets.only(top: 4),
                      child: keys[index] == '每日推荐'
                          ? Text(
                        '${DateTime.now().day}',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      )
                          : Text(''),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('${keys[index]}',
                    style: Theme.of(context).textTheme.subhead,
                  ),
                )
              ],
            ),
          );
        },
        childCount: keys.length,
      ),
    );
  }
}

class _NavigationLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _ItemNavigator(Icons.radio, "私人FM", () {
            notImplemented(context);
          }),
          _ItemNavigator(Icons.today, "每日推荐", () {
            Navigator.pushNamed(context, ROUTE_DAILY);
          }),
          _ItemNavigator(Icons.show_chart, "排行榜", () {
            Navigator.pushNamed(context, ROUTE_LEADERBOARD);
          }),
        ],
      ),
    );
  }
}

///common header for section
class _Header extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 12)),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(fontWeight: FontWeight.w800),
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  _Header(this.text, this.onTap);
}

class _ItemNavigator extends StatelessWidget {
  final IconData icon;

  final String text;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              elevation: 4,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  child: Container(
                    width: 64,
                    height: 64,
                    color: Theme.of(context).primaryColor,
                    child: Icon(
                      icon,
                      color: Theme.of(context).primaryIconTheme.color,
                    ),
                  ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            Text(text, style: Theme.of(context).textTheme.subhead),
          ],
        )
    );
  }

  _ItemNavigator(this.icon, this.text, this.onTap);
}

class _SectionPlaylist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Loader<Map>(
      loadTask: () => neteaseRepository.personalizedPlaylist(limit: 6),
      builder: (context, result) {
        List<Map> list = (result["result"] as List).cast();
        return GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 10 / 12,
          children: list.map<Widget>((p) {
            return _buildPlaylistItem(context, p);
          }).toList(),
        );
      },
    );
  }

  Widget _buildPlaylistItem(BuildContext context, Map playlist) {
    GestureLongPressCallback onLongPress;

    String copyWrite = playlist["copywriter"];
    if (copyWrite != null && copyWrite.isNotEmpty) {
      onLongPress = () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  playlist["copywriter"],
                  style: Theme.of(context).textTheme.body2,
                ),
              );
            });
      };
    }

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PlaylistDetailPage(
            playlist["id"],
          );
        }));
      },
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
//              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: AspectRatio(
                aspectRatio: 1,
                child: FadeInImage(
                  placeholder: AssetImage("assets/placeholder_album.png"),
                  image: CachedImage(playlist["picUrl"]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            Text(
              playlist["name"],
              style: Theme.of(context).textTheme.subtitle.copyWith(height: 0.97),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTopPlaylist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Loader<Map>(
      loadTask: () => neteaseRepository.topPlaylist(limit: 6),
      builder: (context, result) {
        List<Map> list = (result["playlists"] as List).cast();
        return GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 10 / 12,
          children: list.map<Widget>((p) {
            return _buildPlaylistItem(context, p);
          }).toList(),
        );
      },
    );
  }

  Widget _buildPlaylistItem(BuildContext context, Map playlist) {
    GestureLongPressCallback onLongPress;

    String copyWrite = playlist["copywriter"];
    if (copyWrite != null && copyWrite.isNotEmpty) {
      onLongPress = () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  playlist["copywriter"],
                  style: Theme.of(context).textTheme.body2,
                ),
              );
            });
      };
    }

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PlaylistDetailPage(
            playlist["id"],
          );
        }));
      },
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
//              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: AspectRatio(
                aspectRatio: 1,
                child: FadeInImage(
                  placeholder: AssetImage("assets/placeholder_album.png"),
                  image: CachedImage(playlist["coverImgUrl"]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            Text(
              playlist["name"],
              style: Theme.of(context).textTheme.subtitle.copyWith(height: 0.97),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionNewSongs extends StatelessWidget {
  Music _mapJsonToMusic(Map json) {
    Map<String, Object> song = json["song"];
    return mapJsonToMusic(song);
  }

  @override
  Widget build(BuildContext context) {
    return Loader<Map>(
      loadTask: () => neteaseRepository.personalizedNewSong(),
      builder: (context, result) {
        List<Music> songs = (result["result"] as List)
            .cast<Map>()
            .map(_mapJsonToMusic)
            .toList();
        return MusicTileConfiguration(
          musics: songs,
          token: 'playlist_main_newsong',
          onMusicTap: MusicTileConfiguration.defaultOnTap,
          leadingBuilder: MusicTileConfiguration.indexedLeadingBuilder,
          trailingBuilder: MusicTileConfiguration.defaultTrailingBuilder,
          child: Column(
            children: songs.map((m) => MusicTile(m)).toList(),
          ),
        );
      },
    );
  }
}
