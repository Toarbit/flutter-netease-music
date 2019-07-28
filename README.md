# Quiet 
[![Build Status](https://travis-ci.com/boyan01/flutter-netease-music.svg?branch=master)](https://travis-ci.com/boyan01/flutter-netease-music)
[![codecov](https://codecov.io/gh/boyan01/flutter-netease-music/branch/master/graph/badge.svg)](https://codecov.io/gh/boyan01/flutter-netease-music)

Flutter网易云音乐播放器，基于[boyan01](https://github.com/boyan01/flutter-netease-music)。

希望制作为一个简单、流畅且漂亮的自用音乐APP。

---

因无iOS设备，iOS平台代码与上游同步。


## How to start
  1. clone 项目
  ```bash
  git clone https://github.com/boyan01/flutter-netease-music.git
  git submodule update --init --recursive
  ```
  2. 安装 [Flutter](https://flutter.io/docs/get-started/install) （**注意安装最新的stable版本**）
  3. 在命令行输入下面命令以 profile 模式运行（更快的运行效率）
 ```bash
 flutter run --profile
 ```

## 基本组件依赖

* 页面加载：[**loader**](https://github.com/boyan01/loader)
* Toast及应用内通知： [**overlay_support**](https://github.com/boyan01/overlay_support)

## 交互效果
| playing | playlist | lyric |
|------|-----|----|
|![playing](https://raw.githubusercontent.com/boyan01/boyan01.github.io/master/quiet/play_interaction.gif)| ![playlist](https://boyan01.github.io/quiet/interation_playlist.gif) | ![lyric](https://boyan01.github.io/quiet/lyric.gif) |


## 图片预览

| ![main_playlist](https://boyan01.github.io/quiet/main_playlist.png) | ![main_cloud](https://boyan01.github.io/quiet/main_playlist_dark.png) | ![main_cloud](https://boyan01.github.io/quiet/main_cloud.jpg) | ![artist_detail](https://boyan01.github.io/quiet/artist_detail.jpg) |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| ![playlist_detail](https://boyan01.github.io/quiet/playlist_detail.png) | ![page_comment](https://boyan01.github.io/quiet/page_comment.png) |   ![playing](https://boyan01.github.io/quiet/playing.png)    |    ![search](https://boyan01.github.io/quiet/search.jpg)     |
| ![music_selection](https://boyan01.github.io/quiet/music_selection.png) | ![playlist_selector](https://boyan01.github.io/quiet/playlist_selector.jpg) | ![music video](https://boyan01.github.io/quiet/music_video.png) | ![每日推荐](https://boyan01.github.io/quiet/daily_playlist.png) |
| ![ios](https://boyan01.github.io/quiet/ios_playlist_detail.jpg) |   ![ios](https://boyan01.github.io/quiet/user_detail.png)    |                                                              |                                                              |

