import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:otaupdater/comp/debug.dart';
import 'package:otaupdater/comp/filepicker.dart';
import 'package:otaupdater/src/rust/api/status.dart';
import 'package:otaupdater/comp/updatebutt.dart';

import 'package:otaupdater/src/rust/api/ota.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

var updateButtText = "Check for Update";

class _HomePageState extends State<HomePage> {
  bool _isUpdatable = false;
  String _currVersion = "Unknown";

  bool _isShowRealeaseNote = true;

  bool _showInstallButt = true;
  UpdateButtStatus _status = UpdateButtStatus.noUpdate;

  double _downloadProgress = 0.55;

  late Future<String> _releaseNotes;

  // 滑动感知
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _releaseNotes = getLatestReleaseNote();

    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;

      if (direction == ScrollDirection.forward && _showInstallButt) {
        setState(() => _showInstallButt = true);
      }

      if (direction == ScrollDirection.reverse && !_showInstallButt) {
        setState(() => _showInstallButt = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 主内容区域：SingleChildScrollView 加底部 padding 防止按钮遮挡
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 90), // 为底部按钮留空间
              child: Column(
                children: [
                  // top 返回 和 三点 更多
                  Row(
                    children: [
                      // back icon
                      BackButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Text(
                          "System Update",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      PopupMenuButton<int>(
                        // borderRadius: BorderRadius.circular(12),
                        onSelected: (int result) {
                          switch (result) {
                            case 0:
                              PickFile().then((path) {
                                if (context.mounted) {
                                  PrintDebugInfo.show(context, path);
                                }
                              });
                              break;
                            case 1:
                              Navigator.pushNamed(context, '/settings');
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<int>>[
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Text('本地安装'),
                              ),
                              const PopupMenuItem<int>(
                                value: 1,
                                child: Text('设置'),
                              ),
                            ],
                      ),
                    ],
                  ),

                  // 中间大框, background img 和标题
                  Container(
                    margin: const EdgeInsets.all(20),
                    height: 400,
                    child: Stack(
                      children: [
                        // 背景图
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              'lib/images/thumb.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // 标题
                        Positioned(
                          left: 16,
                          bottom: 16,
                          child: Text(
                            'ColorOS 16.0.5',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.yellow[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 版本文本
                  Container(
                    margin: const EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    padding: const EdgeInsets.only(
                      left: 14,
                      right: 14,
                      top: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.new_releases_rounded),
                            Expanded(
                              child: Text(
                                'Release Notes',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() {
                                _isShowRealeaseNote = !_isShowRealeaseNote;
                              }),
                              icon: Builder(
                                builder: (context) {
                                  return Icon(
                                    _isShowRealeaseNote
                                        ? Icons.expand_less_rounded
                                        : Icons.expand_more_rounded,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 1),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                            right: 4,
                            bottom: 12,
                          ),
                          // ai搓的动画
                          // child: _isShowRealeaseNote
                          //     ? FutureBuilder<String>(
                          //             key: const ValueKey(
                          //               'release_notes_builder',
                          //             ),
                          //             future: _releaseNotes,
                          //             builder: (context, snapshot) {
                          //               final text = switch (snapshot
                          //                   .connectionState) {
                          //                 ConnectionState.waiting ||
                          //                 ConnectionState.active ||
                          //                 ConnectionState.none =>
                          //                   'Loading release notes...',
                          //                 ConnectionState.done =>
                          //                   snapshot.hasError
                          //                       ? 'Failed to load release notes.'
                          //                       : (snapshot.data ??
                          //                             'No release notes available.'),
                          //               };
                          //               return Text(text);
                          //             },
                          //           )
                          //           // Apply the animation to the expanded view
                          //           .animate(
                          //             target: _isShowRealeaseNote ? 1 : 0,
                          //           )
                          //           .fadeIn(duration: 200.ms)
                          //           .slideY(
                          //             begin: 0.2,
                          //             end: 0,
                          //             curve: Curves.easeOutQuad,
                          //           )
                          //     : Text(
                          //             "Tap to expand full release notes.",
                          //             key: const ValueKey(
                          //               'release_notes_placeholder',
                          //             ),
                          //           )
                          //           // Apply a mirror animation to the collapsed view
                          //           .animate(
                          //             target: !_isShowRealeaseNote ? 1 : 0,
                          //           )
                          //           .fadeIn(duration: 200.ms)
                          //           .slideY(
                          //             begin: -0.2,
                          //             end: 0,
                          //             curve: Curves.easeOutQuad,
                          //           ),
                          child: AnimatedCrossFade(
                            duration: const Duration(milliseconds: 250),
                            reverseDuration: const Duration(milliseconds: 250),
                            crossFadeState: _isShowRealeaseNote
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            // The curve controls the smooth sliding/fading feel
                            firstCurve: Curves.easeInOut,
                            secondCurve: Curves.easeInOut,
                            sizeCurve: Curves.easeInOut,

                            // First Widget: The expanded FutureBuilder
                            firstChild: SizedBox(
                              width: double.infinity, // 锁定宽度，防止横向文字由于宽度变化而抖动
                              child: FutureBuilder<String>(
                                future: _releaseNotes,
                                builder: (context, snapshot) {
                                  final text = switch (snapshot
                                      .connectionState) {
                                    ConnectionState.waiting ||
                                    ConnectionState.active ||
                                    ConnectionState.none =>
                                      'Loading release notes...',
                                    ConnectionState.done =>
                                      snapshot.hasError
                                          ? 'Failed to load release notes.'
                                          : (snapshot.data ??
                                                'No release notes available.'),
                                  };
                                  return Text(text, textAlign: TextAlign.start);
                                },
                              ),
                            ),

                            // 第二状态：折叠的占位文本
                            secondChild: const SizedBox(
                              width: double.infinity, // 两边保持一致的无限宽度约束
                              child: Text(
                                "Tap to expand full release notes.",
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 小字注释
                  const Text(
                    "For more details about this Rom port, go XXXX",
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),

            // 底部悬浮按钮：滚动感知，下滑隐藏，上滑显示
            Expanded(
              child: Container(), // 占位，撑满剩余空间
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: SizedBox(
                width: double.infinity,
                child: UpdateButton(
                  status: _status,
                  progress: _downloadProgress,
                  onPressed: () => PrintDebugInfo.show(
                    context,
                    "Button Pressed! Current status: $_status",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
